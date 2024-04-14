#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  r <- shiny::reactiveValues()
  r$leakReport <- abwellleaks::leakReport
  mod_mapsummaryAB_server("mapsummaryAB_1", r = r)
  mod_mapwellsAB_server("mapwellsAB_1", r = r)
}
