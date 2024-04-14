#' mapsummaryAB UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_mapsummaryAB_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::fluidPage(
      theme = shinythemes::shinytheme("flatly"),
      shiny::titlePanel(h1("Well Leaks Summary"), windowTitle = "Well Leaks Summary by Descriptor"),

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
                             choices = c("All", "0-749.99"= '0-749.999999',
                                         "750-1249.99" = "750-1249.99999",
                                         "1250-1999.99" = "1250-1999.99999",
                                         "2000+" = "2000-100000")),
          shiny::checkboxInput(ns("seriousFilter"), "Show Only Serious Leaks", FALSE)
        ),

        shiny::mainPanel(
          shiny::fluidRow(
            shiny::column(width = 8,
                          leaflet::leafletOutput(ns("mapsummaryAB"), height = "600px")
            ),
            shiny::column(width = 4,
                          DT::dataTableOutput(ns("provinceSummary"))
            )
          ),
          tags$div(p("Created by: Luke Talman"), style = "text-align: center; margin-top: 20px;")
        )
      )
    )
  )
}

#' mapsummaryAB Server Functions
#'
#' @noRd
#'
mod_mapsummaryAB_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    summarized_data <- shiny::reactive({

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

      summarizedDesc <- data %>%
        dplyr::group_by(DESCRIPTOR) %>%
        dplyr::summarise(
          totalWells = dplyr::n(),
          minDepth = if (all(is.na(TotalDep))) NA_real_ else min(TotalDep, na.rm = TRUE),
          maxDepth = if (all(is.na(TotalDep))) NA_real_ else max(TotalDep, na.rm = TRUE),
          meanDepth = if (all(is.na(TotalDep))) NA_real_ else mean(TotalDep, na.rm = TRUE),
          meanFlowRateM3 = if (all(is.na(flow_rate_m3perday))) NA_real_ else mean(flow_rate_m3perday, na.rm = TRUE),
          propSerious = if (dplyr::n() == 0) NA_real_ else sum(classification == 'Serious') / dplyr::n(),
          minAge = if (all(is.na(LicenceIssueDate))) NA_real_ else min(LicenceIssueDate, na.rm = TRUE),
          maxAge = if (all(is.na(LicenceIssueDate))) NA_real_ else max(LicenceIssueDate, na.rm = TRUE),
          geometry = dplyr::first(geometry),
          .groups = "drop"
        ) %>%
        sf::st_as_sf()

      summarizedProv <- data %>%
        dplyr::summarise(
          totalWells = dplyr::n(),
          minDepth = if (all(is.na(TotalDep))) NA_real_ else min(TotalDep, na.rm = TRUE),
          maxDepth = if (all(is.na(TotalDep))) NA_real_ else max(TotalDep, na.rm = TRUE),
          meanDepth = if (all(is.na(TotalDep))) NA_real_ else round(mean(TotalDep, na.rm = TRUE),2),
          meanFlowRateM3 = if (all(is.na(flow_rate_m3perday))) NA_real_ else round(mean(flow_rate_m3perday, na.rm = TRUE),2),
          minAge = if (all(is.na(LicenceIssueDate))) NA_real_ else min(LicenceIssueDate, na.rm = TRUE),
          maxAge = if (all(is.na(LicenceIssueDate))) NA_real_ else max(LicenceIssueDate, na.rm = TRUE),
          .groups = "drop"
        ) %>%
        dplyr::mutate(Summary = "Province Wide") %>%
        dplyr::rename(`Mean Depth (M)` = meanDepth,
                      `Min Depth (M)` = minDepth,
                      `Max Depth (M)` = maxDepth,
                      `Min Age` = minAge,
                      `Max Age` = maxAge,
                      `Total Wells` = totalWells) %>%
        dplyr::mutate_all(as.character) %>%
        tidyr::pivot_longer(names_to = "Variable", values_to = "Value", -Summary) %>%
        dplyr::select(-Summary) %>%
        dplyr::mutate(Variable = dplyr::case_when(
          Variable == "meanFlowRateM3" ~ "Mean Flow Rate (M\u00B3)",
          TRUE ~ Variable
        ))

      list(desc = summarizedDesc, prov = summarizedProv)

    })
    output$mapsummaryAB <- leaflet::renderLeaflet({
      summarizedDesc <- summarized_data()$desc
      pal <- leaflet::colorNumeric(palette = "YlOrRd", summarizedDesc$totalWells)

      leaflet::leaflet(data = summarizedDesc) %>%
        leaflet::addTiles() %>%
        leaflet::addPolygons(color = "#444444",
                             weight = 1,
                             smoothFactor = 0.5,
          fillColor = ~pal(totalWells),
          fillOpacity = 0.5,
          popup = ~paste("Descriptor:", DESCRIPTOR,
                         "<br>Total Wells:", totalWells,
                         "<br>Depth Range (M):", minDepth,"-", maxDepth,
                         "<br>Mean Depth (M):", meanDepth,
                         "<br>Licence Date Range:",
                         minAge, "-", maxAge,
                         "<br>Mean Flow Rate (M\u00B3):", meanFlowRateM3)
        )
    })

    output$provinceSummary <- DT::renderDataTable({

      data <- summarized_data()$prov

      DT::datatable(data,
                    options = list(
                      pageLength = 10,
                      dom = 't',
                      paging = FALSE,
                      ordering = FALSE,
                      info = FALSE,
                      searching = FALSE
                    ),
                    class = "display compact nowrap",
                    style = "bootstrap",
                    rownames = FALSE,
                    caption = htmltools::tags$caption(style = "caption-side: top; font-size: 24px;", "Provincial Summary")  # Hide row names
      )
    })
  })
}

## To be copied in the UI
# mod_mapsummaryAB_ui("mapsummaryAB_1")

## To be copied in the server
# mod_mapsummaryAB_server("mapsummaryAB_1")



