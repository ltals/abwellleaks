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

    h3("Flow Rate Analysis"),
    shiny::selectInput(ns("xInput"), "Select X Variable:",
                choices = c("Stabilized Shut-In Pressure (kPa)" = "stabilized_shut_in_pressure_kpa",
                            "Total Depth (m)" = "TotalDep",
                            "Total Depth Below MSL" = "belowMSl",
                            "Source Depth (mkb)" = "source_depth_mkb")),
    plotly::plotlyOutput(ns("leakPlot"), height = "300px"),

    h3("Most Frequently Occuring Terminating Formations in Leak Report"),
    shiny::sliderInput(ns("numFormations"), "Number of Formations:",
                       min = 5, max = 20, value = 10),
    plotly::plotlyOutput(ns("formationPlot"), height = "300px"),

    h3("Mean Resolution Times"),
    shiny::selectInput(ns("groupBy"), "Group By:",
                       choices = c("Leak Type" = "type",
                                   "Well Substance" = "WellSubstance",
                                   "Severity Classification" = "classification")),
    plotly::plotlyOutput(ns("meanResolutionPlot"), height = "300px")
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


    output$formationPlot <- plotly::renderPlotly({

      data <- r$leakReport %>%
        dplyr::group_by(TerminatingFormation) %>%
        dplyr::count() %>%
        dplyr::arrange(desc(n)) %>%
        head(input$numFormations) %>%
        dplyr::arrange(TerminatingFormation)

      plotly::plot_ly(data, x = ~TerminatingFormation, y = ~n, type = 'bar',
                      marker = list(color = 'orange')) %>%
        plotly::layout(xaxis = list(title = "", tickangle = 45),
                       yaxis = list(title = "Count of Wells"))
    })



    output$meanResolutionPlot <- plotly::renderPlotly({

      data <- r$leakReport %>%
        dplyr::mutate(diff = as.numeric(difftime(resolution_date, report_date, units = "days"))) %>%
        dplyr::group_by(get(input$groupBy)) %>%
        dplyr::summarise(mean_diff = mean(diff, na.rm = TRUE)) %>%
        na.omit() %>%
        dplyr::ungroup()


      plotly::plot_ly(data, x = ~`get(input$groupBy)`,
                      y = ~mean_diff,
                      type = 'bar',
                      marker = list(color = 'darkred')) %>%
        plotly::layout(xaxis = list(title = ""),
                       yaxis = list(title = "Mean Resolution Time (days)"))
    })
  })
}


## To be copied in the UI
# mod_plotwellsAB_ui("plotwellsAB_1")

## To be copied in the server
# mod_plotwellsAB_server("plotwellsAB_1")
