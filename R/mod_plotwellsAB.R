#' plotwellsAB UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plotwellsAB_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::fluidPage(
      theme = shinythemes::shinytheme("flatly"),
      shiny::titlePanel(h1("Leak Report: Plots")),

    shiny::selectInput(ns("xInput"), "Select X Variable:",
                choices = c("Stabilized Shut-In Pressure (kPa)" = "stabilized_shut_in_pressure_kpa",
                            "Total Depth (m)" = "TotalDep",
                            "Total Depth Below MSL" = "belowMSl",
                            "Source Depth (mkb)" = "source_depth_mkb")),
    plotly::plotlyOutput(ns("leakPlot"), height = "250px")
    )
  )
}

#' plotwellsAB Server Functions
#'
#' @noRd
mod_plotwellsAB_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$leakPlot <- plotly::renderPlotly({

      data <- r$leakReport %>%
        dplyr::mutate(belowMSl = KBE - TotalDep)


      plotly::plot_ly(data, x = ~get(input$xInput),
              y = ~flow_rate_m3perday,
              color = ~type,
              type = 'scatter',
              mode = 'markers') %>%
        plotly::layout(xaxis = list(title = ""),
               yaxis = list(title = "Flow Rate (m\u00B3/day)"))

      })
  })
}


## To be copied in the UI
# mod_plotwellsAB_ui("plotwellsAB_1")

## To be copied in the server
# mod_plotwellsAB_server("plotwellsAB_1")
