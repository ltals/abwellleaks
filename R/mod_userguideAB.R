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
    shiny::titlePanel("User Guide"),
    shiny::fluidRow(
      shiny::column(12,
                    shiny::wellPanel(
                      h3("Alberta Well Leaks Dashboard"),
                      p("The Alberta Well Leaks Dashboard serves as a platform to anaylsis and
                        visulize the AER's Well Vent Flow/Gas Migration Report at a provincial
                        and well-specific level.The analyzed dataset is a merged dataset of the following
                        reports:"),
                      # make a list

                      p("AER Well Vent Flow/Gas Migration Report:"),
                      p("AER ST37: List of Wells in Alberta Surface Holes:"),
                      p("AER ST37: List of Wells in Alberta Bottom Holes:"),
                      p("Pertrinex Well Infrastructure Report:"),

                      h4("Research Application"),
                      p("This tool supports research efforts surround the
                        detection, repair and prevention of well leaks in Alberta,
                        serving as consildated data source for publically available well data.
                        Leaking wells have a high cost to well owners and the public."),

                      p("Geospacial components support the communication and framing of the problem
                        at a province-wide level, while satallite imagery supports in the detection
                        of leaks at a well-specific level through killzone analysis."),

                      p("The repository for this golem application can be forked with credit to
                        proprietary well leak data for further analysis."),

                      #bold title
                      h4("Realestate Application"),
                      p("Existing or prospective landowners can use this tool to geolocate or
                        search for specfic wells on their land to see if they appear in the
                        AER's Well Vent Flow/Gas Migration Report. Landowners can further explore
                        the nature of the leak, as well as the reolution of leak.")
                    )
      ),
      shiny::column(12,
                    shiny::wellPanel(
                      h3("Leak Report: By Township & Range"),
                      p("Filter data in the Well Leak Report by report type (existince of a reported resolution),
                        resolution type, total vertical of the wells, and severity of the leak.
                        Data based on your selected filters will be agregated by Township and Range and displayed on the map.
                        Click on a specific Township and Range to see the computed summary for that given area. The Provincial summary provides the
                        same summary given the filters applied at a Province-wide level."),
                      p("Toggle between satellite view and regular
                        when browsing the map.")
                    )
      ),
      shiny::column(12,
                    shiny::wellPanel(
                      h3("Leak Report: By Well"),
                      p("Using the same filters as the previous tab, filter and view
                        the Well Leak Report at a well specific level. Click on as specific well to see key information
                        about the specific well sourced from the merged dataset."),
                      p("Wells are searchable by UWI; enter your UWI in the required
                        format and it will appear on map if it's present in the leak report.")
                    )
      ),
      shiny::column(12,
                    shiny::wellPanel(
                      h3("Leak Report: By Well"),
                      p("Explore additional features such as toggling between satellite view and regular view.")
                    )
      ),
      shiny::column(12,
                    shiny::wellPanel(
                      h3("Questions/Bugs/Concerns"),
                      p("Reach out to talman@ualberta with any bug reports or questions.")
                    ))
    )
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
