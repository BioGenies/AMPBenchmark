library(shiny)
library(shinycssloaders)
library(bslib)
library(DT)

shinyUI(
  fluidPage(title = "AMPBenchmark",
            theme = bs_theme(version = 4, bootswatch = "lux"),
            tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "progress.css")),
            includeMarkdown("./man/readme.md"),
            fileInput("user_preds", "Provide input data"),
            tabsetPanel(
              tabPanel("New architecture overview",
                       withSpinner(DT::dataTableOutput("new_architecture_dt"))),
              tabPanel("Comparison with other architectures",
                       includeMarkdown("./man/heatmap.md"),
                       tabsetPanel(
                         tabPanel("Chart", plotOutput("heatmap_plot", height = "1200px")),
                         tabPanel("Source data", DT::dataTableOutput("heatmap_dt"))
                       )),
              tabPanel("Impact of the sampling method",
                       includeMarkdown("./man/sampling-impact.md"),
                       tabsetPanel(
                         tabPanel("Chart", 
                                  checkboxInput("sd", "Show standard deviations"),
                                  plotOutput("reference_vs_nonreference_plot")),
                         tabPanel("Source data", DT::dataTableOutput("reference_vs_nonreference_dt"))
                       )
              )
            )
  )
)
