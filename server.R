library(shiny)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(DT)
library(shinythemes)
library(hmeasure)

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
  
  reference_nonreference_df <- reactive({
    readRDS("./data/reference_nonreference_df.RDS")
  })
  
  new_architecture_res <- reactive({
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
    
    full_res <- lapply(unique(rep_method_df[["rep"]]), function(ith_rep) {
      lapply(setdiff(unique(rep_method_df[["training_sampling"]]), "positive"),
             function(ith_training_sampling) {
               lapply(unique(rep_method_df[["benchmark_sampling"]]), function(ith_benchmark_sampling) {
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
    }) %>% bind_rows() %>% 
      dplyr::mutate(rep = as.numeric(substr(rep, 4, 4)))
    
    dplyr::group_by(full_res, benchmark_sampling, training_sampling) %>%
      dplyr::summarise(mean_AUC = mean(AUC),
                       sd_AUC = sd(AUC)) %>%
      dplyr::ungroup() %>% 
      dplyr::mutate(architecture = "New model") %>% 
      dplyr::select(architecture, training_sampling, benchmark_sampling, mean_AUC, sd_AUC)
  })
  
  output[["reference_vs_nonreference_plot"]] <- renderPlot({
    architecture_colors <- c(AMAP = "#b67f49", AmPEP = "#6cb649", AmPEPpy = "#33803f", 
                             AmpGram = "#bc5658", Ampir = "#497db6", AMPScannerV2 = "#7f49b6", 
                             `CS-AMPPred` = "#49b5b6", `Deep-AmPEP30` = "#b6498b", `iAMP-2L` = "#e1df81", 
                             MACREL = "#81b6e1", MLAMP = "#8e8e8e", `SVM-LZ` = "#d0ad2f",
                             `New model` = "black")
    
    ggplot(reference_nonreference_df(), 
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