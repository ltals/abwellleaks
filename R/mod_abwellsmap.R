#' abwellsmap UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_abwellsmap_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' abwellsmap Server Functions
#'
#' @noRd 
mod_abwellsmap_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_abwellsmap_ui("abwellsmap_1")
    
## To be copied in the server
# mod_abwellsmap_server("abwellsmap_1")
