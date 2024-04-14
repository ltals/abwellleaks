#' mapwellsAB UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_mapwellsAB_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::fluidPage(
      theme = shinythemes::shinytheme("flatly"),
      shiny::titlePanel(h1("Filtered Well Leaks Map"), windowTitle = "Filtered Well Leaks by Descriptor"),

      shiny::sidebarLayout(
        shiny::sidebarPanel(
          shiny::selectInput(ns("resInput"), "Report type:",
                             choices = c("All", "Resolution Reported", "No Resolution Reported")),
          shiny::conditionalPanel(
            condition = sprintf('input["%s"] == "Resolution Reported"', ns("resInput")),
            shiny::selectInput(ns("resTypeInput"), "Resolution Type:",
                               choices = c("All", "Repaired", "Abated", "Repair Unsuccessful"))
          ),
          shiny::selectInput(ns("depthRangeInput"), "Total Vertical Depth (Metres):",
                             choices = c("All", "0-749.99" = '0-749.999999',
                                         "750-1249.99" = "750-1249.99999",
                                         "1250-1999.99" = "1250-1999.99999",
                                         "2000+" = "2000-100000")),
          shiny::checkboxInput(ns("seriousFilter"), "Show Only Serious Leaks", FALSE)
        ),

        shiny::mainPanel(
          shiny::fluidRow(
            shiny::column(width = 12,
                          leaflet::leafletOutput(ns("mapfiltAB"), height = "600px")
            )
          ),
          tags$div(p("Created by: Luke Talman"), style = "text-align: center; margin-top: 20px;")
        )
      )
    )
  )
}

#' mapwellsAB Server Functions
#'
#' @noRd
mod_mapwellsAB_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    all_data <- shiny::reactive({

      data <- r$leakReport

      if (input$resInput != "All") {
        if(input$resTypeInput != "All"){
          data <- data %>%
            dplyr::filter(resolutionType == input$resTypeInput)
        } else {
          data <- data %>%
            dplyr::filter(reportType == input$resInput)
        }
      }

      if (input$depthRangeInput != "All") {
        depthRange <- stringr::str_split(input$depthRangeInput, "-")[[1]]
        data <- data %>%
          dplyr::filter(TotalDep >= as.numeric(depthRange[1]) & TotalDep <= as.numeric(depthRange[2]))
      }

      if (input$seriousFilter) {
        data <- data %>%
          dplyr::filter(classification == 'Serious')
      }

      data

  })

  output$mapfiltAB <- leaflet::renderLeaflet({
    filtWells <- all_data()
    leaflet::leaflet(data = filtWells) %>%
      leaflet::addTiles() %>%
      leaflet::addCircleMarkers(
        lng = ~Longitude,
        lat = ~Latitude,
        radius = 6,
        fillOpacity = 1,
        color = "darkred",
        popup = ~paste("Licensee:", LicenseeName,
                       "<br>Status:", LicenceStatus,
                       "<br>Licence Issued:", LicenceIssueDate,
                       "<br>Leak Reported:", report_date,
                       "<br>Leak Type:", type,
                       "<br>Classification:", classification,
                       "<br>Daily Flow Rate M\u00B3:", flow_rate_m3perday,
                       "<br>Reported Resolution:", reported_resolution,
                       "<br>Resolution Date", resolution_date,
                       "<br>Total Vertical Depth (M):", TotalDep,
                       "<br>Terminating Formation:", TerminatingFormation),
        group = 'markers',
        clusterOptions = leaflet::markerClusterOptions(
          spiderfyOnMaxZoom = TRUE,
          animate = TRUE,
          disableClusteringAtZoom = 14
        )
      )
    })
  })
}

## To be copied in the UI
# mod_mapwellsAB_ui("mapwellsAB_1")

## To be copied in the server
# mod_mapwellsAB_server("mapwellsAB_1")
