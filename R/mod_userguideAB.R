#' userguideAB UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_userguideAB_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' userguideAB Server Functions
#'
#' @noRd 
mod_userguideAB_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_userguideAB_ui("userguideAB_1")
    
## To be copied in the server
# mod_userguideAB_server("userguideAB_1")
