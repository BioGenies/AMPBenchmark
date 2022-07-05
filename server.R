library(shiny)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(DT)
library(shinythemes)
library(hmeasure)
library(tidyr)

options(shiny.maxRequestSize=100000*1024)

my_DT <- function(x, ...)
  datatable(x, ..., escape = FALSE, extensions = 'Buttons', 
            filter = "top", rownames = FALSE,
            style = "bootstrap", 
            options = list(dom = "Brt",
                           buttons = c("copy", "csv", "excel", "print"),
                           pageLength = 50)
  )

#source("utils.R")

shinyServer(function(input, output) {
  
  new_architecture_res <- reactive({
    validate(
      need(input[["user_preds"]], "Provide prediction file")
    )
    
    dat <- read.csv(input[["user_preds"]][["datapath"]])
    
    rep_method_df <- dplyr::mutate(dat, 
                                   rep = sapply(strsplit(ID, "_"), last),
                                   training_sampling = sapply(strsplit(ID, "_"), 
                                                              function(i) i[length(i) - 2])) %>% 
      dplyr::mutate(target = grepl(pattern = "AMP=1", x = ID, fixed = TRUE),
                    positive = !grepl(pattern = "method", x = training_sampling, fixed = TRUE),
                    training_sampling = ifelse(positive, "positive", training_sampling),
                    training_sampling = gsub(pattern = "method=", replacement = "", 
                                             x = training_sampling)) %>% 
      dplyr::select(-positive)
    
    percentage <- 0
    total_len <- length(setdiff(unique(rep_method_df[["training_sampling"]]), "positive")) * 
      length(unique(rep_method_df[["rep"]])) * length(unique(rep_method_df[["benchmark_sampling"]]))
    
    full_res <- withProgress(lapply(unique(rep_method_df[["rep"]]), function(ith_rep) {
      lapply(setdiff(unique(rep_method_df[["training_sampling"]]), "positive"),
             function(ith_training_sampling) {
               lapply(unique(rep_method_df[["benchmark_sampling"]]), function(ith_benchmark_sampling) {
                 
                 percentage <<- percentage + 1/total_len*100
                 incProgress(1/total_len, message = "", 
                             detail = paste0("Progress: ", round(percentage, 4), "%"))
                 
                 part_rep_method_df <- dplyr::filter(rep_method_df, 
                                                     training_sampling %in% c(ith_training_sampling, "positive"),
                                                     rep == ith_rep)
                 metrics <- hmeasure::HMeasure(part_rep_method_df[["target"]], 
                                               part_rep_method_df[["AMP_probability"]])[["metrics"]]
                 
                 data.frame(AUC = metrics[["AUC"]],
                            benchmark_sampling = ith_benchmark_sampling,
                            training_sampling = ith_training_sampling,
                            rep = ith_rep)
               }) %>% bind_rows()
             }) %>% bind_rows()
    })) 
    
    dplyr::bind_rows(full_res) %>% 
      dplyr::mutate(rep = as.numeric(substr(rep, 4, 4))) %>% 
      dplyr::group_by(benchmark_sampling, training_sampling) %>%
      dplyr::summarise(mean_AUC = mean(AUC),
                       sd_AUC = sd(AUC)) %>%
      dplyr::ungroup() %>% 
      dplyr::mutate(architecture = "New model") %>% 
      dplyr::select(architecture, training_sampling, benchmark_sampling, mean_AUC, sd_AUC)
  })
  
  heatmap_df <- reactive({
    dat <- readRDS("./data/heatmap_df.RDS") 
    
    if(!is.null(input[["user_preds"]][["datapath"]])) {
      dat <- dplyr::bind_rows(dat, 
                              dplyr::mutate(new_architecture_res(), 
                                            benchmark_sampling = ifelse(benchmark_sampling == "Wang-et-al", "Wang et al.", benchmark_sampling),
                                            training_sampling = ifelse(training_sampling == "Wang-et-al", "Wang et al.", training_sampling)))
    }
    
    dat
  })
  
  
  output[["heatmap_plot"]] <- renderPlot({
    plot_dat <- heatmap_df() %>% 
      mutate(ident = training_sampling == benchmark_sampling,
             architecture = paste0("A:", architecture),
             architecture = factor(architecture, levels = unique(architecture)))
    
    ggplot(plot_dat, aes(x = training_sampling, y = benchmark_sampling, 
                         fill = mean_AUC, size = sd_AUC)) +
      geom_tile(size = 1) +
      geom_tile(data = plot_dat[plot_dat[["ident"]] == TRUE, ], 
                aes(color = ident), size = 1) +
      geom_point(color = "black") +
      facet_wrap(~ architecture, ncol = 4) +
      scale_fill_gradient("Mean AUC", low =  "#ffe96b",  high = "#ff4242",
                          trans = scales::trans_new("square_exp", function(x) exp(x)^2, function(x) log(sqrt(x)))) +
      scale_size_continuous("Standard deviation") +
      scale_color_manual(guide = "none", values = c(`TRUE` = "black")) +
      theme_bw(base_size = 16) +
      theme(axis.text.x = element_text(angle = 90), legend.position = "bottom",
            legend.key.width = unit(2, "cm")) +
      xlab("Sampling method used for generation of training negative data set (TSM)") +
      ylab("Sampling method used for generation of benchmark negative data set (BSM)")
    
  })
  
  output[["heatmap_dt"]] <- DT::renderDataTable({
    heatmap_df() %>% 
      mutate(architecture = factor(architecture), 
             training_sampling = factor(training_sampling),
             benchmark_sampling = factor(benchmark_sampling)) %>% 
      setNames(c("Architecture", "TSM", "BSM", "Mean AUC", "SD AUC")) %>%
      my_DT() %>%
      formatRound(columns = 4L:5, digits = 4)
  })
  
  output[["reference_vs_nonreference_plot"]] <- renderPlot({
    architecture_colors <- c(AMAP = "#b67f49", AmPEP = "#6cb649", AmPEPpy = "#33803f", 
                             AmpGram = "#bc5658", Ampir = "#497db6", AMPScannerV2 = "#7f49b6", 
                             `CS-AMPPred` = "#49b5b6", `Deep-AmPEP30` = "#b6498b", `iAMP-2L` = "#e1df81", 
                             MACREL = "#81b6e1", MLAMP = "#8e8e8e", `SVM-LZ` = "#d0ad2f",
                             `New model` = "black")
    
    p <- ggplot(reference_nonreference_df(), 
                aes(x = mean_AUC_reference, y = mean_AUC_nonreference,
                    color = architecture, label = architecture)) +
      geom_point(size = 3) +
      geom_abline(slope = 1, intercept = 0) +
      geom_label_repel(show.legend = FALSE) +
      scale_x_continuous("Mean AUC if trained and tested using\ndata sampled with the same method", 
                         limits = c(0.5, 1)) +
      scale_y_continuous("Mean AUC if trained and tested using\ndata sampled with different methods", 
                         limits = c(0.5, 1)) +
      scale_color_manual("Architecture", values = architecture_colors) + 
      coord_equal() +
      theme_bw() 
    if(input[["sd"]] == TRUE) {
      p +
        geom_errorbar(aes(ymin = mean_AUC_nonreference-sd_AUC_nonreference, ymax = mean_AUC_nonreference+sd_AUC_nonreference)) +
        geom_errorbar(aes(xmin = mean_AUC_reference-sd_AUC_reference, xmax = mean_AUC_reference+sd_AUC_reference))
    } else{
      p
    }
  })
  
  
  
  reference_nonreference_df <- reactive({
    dat <- readRDS("./data/reference_nonreference_df.RDS")
    
    if(!is.null(input[["user_preds"]][["datapath"]])) {
      dat <- dplyr::mutate(new_architecture_res(), 
                           both = benchmark_sampling == training_sampling) %>%
        rename(AUC = mean_AUC) %>% 
        dplyr::group_by(both, architecture) %>%
        dplyr::summarise(mean_AUC = mean(AUC),
                         sd_AUC = sd(AUC)) %>% 
        dplyr::ungroup() %>% 
        dplyr::mutate(both = ifelse(both, "reference", "nonreference")) %>% 
        tidyr::pivot_wider(names_from = both, values_from = c(mean_AUC, sd_AUC)) %>% 
        dplyr::bind_rows(dat)
    }
    
    dat
  })
  
  output[["reference_vs_nonreference_dt"]] <- DT::renderDataTable({
    reference_nonreference_df() %>% 
      setNames(c("Architecture", 
                 "Mean AUC (same method)", "Mean AUC (different methods)",
                 "SD AUC (same method)", "SD AUC (different methods)")) %>% 
      my_DT() %>% 
      formatRound(columns = 2L:5, digits = 4)
  }) 
  
  output[["new_architecture_dt"]] <- DT::renderDataTable({
    new_architecture_res() %>% 
      setNames(c("Architecture", "Training sampling", "Benchmark sampling", 
                 "Mean AUC", "SD AUC")) %>% 
      my_DT() %>% 
      formatRound(columns = 4L:5, digits = 4)
  }) 
})  
