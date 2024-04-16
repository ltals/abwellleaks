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
                      h3("Alberta Well Leak Report Dashboard"),
                      p("The Alberta Well Leak Report Dashboard serves as a platform to anaylze and
                        visulize the AER's Well Vent Flow/Gas Migration Report at a provincial
                        and well-specific level. The analyzed dataset is a merged dataset of the following
                        reports:"),
                      shiny::tags$ul(
                          shiny::tags$li(
                            shiny::tags$a(href = "https://www1.aer.ca/productcatalogue/365.html",
                                          "AER Well Vent Flow/Gas Migration Report")
                          ),
                          shiny::tags$li(
                            shiny::tags$a(href = "https://www.aer.ca/providing-information/data-and-reports/statistical-reports/st37",
                                          "AER ST37: List of Wells in Alberta Surface Holes")
                          ),
                          shiny::tags$li(
                            shiny::tags$a(href = "https://www.aer.ca/providing-information/data-and-reports/statistical-reports/st37",
                                          "AER ST37: List of Wells in Alberta Bottom Holes")
                          ),
                          shiny::tags$li(
                            shiny::tags$a(href = "https://www.petrinex.ca/PD/Documents/PD_Well_Infrastructure_Report.pdf",
                                          "Pertrinex Well Infrastructure Report")
                          )
                        ),

                      h4("Research Application"),
                      p("This tool supports research efforts surround the
                        detection, repair and prevention of well leaks in Alberta,
                        serving as consildated data source for publically available well leak data.
                        Leaking wells have a high cost to well owners and the public."),

                      p("Geospacial components support the communication and framing of the problem
                        at a province-wide level, while satallite imagery supports in the detection
                        of leaks at a well-specific level through killzone analysis."),

                      p("The repository for this golem application can be forked and built upon to include
                        proprietary well leak data for further analysis."),

                      h4("Realestate Application"),
                      p("Existing or prospective landowners can use this tool to geolocate or
                        search for specfic wells on their land to see if they appear in the
                        AER's Well Vent Flow/Gas Migration Report. Landowners can further explore
                        the nature of the leak, as well as the resolution of leak."),
                      h4("Resolution Classification per AER Reported Resolution"),
                      p("Repaired: Problem Repaired, Repaired - Scvf/Gm, Well Abandoned,
                        Not Converted, Wellhead Seal Leak, Casing Failure, Died Out"),
                      p("Abated: Monitor As Required, Considered Non-Serious, Well Capped W/ Pressure"),
                      p("Repair Unsuccessful: Repair Unsuccessful")

                    )
      ),
      shiny::column(12,
                    shiny::wellPanel(
                      h3("Leak Report: By Township & Range"),
                      p("Filter data in the Well Leak Report by report type (existince of a reported resolution),
                        resolution type, total vertical of the wells, and severity of the leak.
                        Data based on your selected filters will be agregated by Township and Range and displayed on the map.
                        Click on a specific Township and Range to see the computed summary for that given area. The provincial summary provides the
                        same summary given the filters applied at a province-wide level."),
                      p("Toggle between satellite view and regular
                        when browsing the map.")
                    )
      ),
      shiny::column(12,
                    shiny::wellPanel(
                      h3("Leak Report: By Well"),
                      p("Using the same filters as the previous tab, filter and view
                        the Well Leak Report at a well-specific level. Click on a specific well to see key information
                        sourced from the merged dataset."),
                      p("Wells are searchable by UWI; enter your UWI in the required
                        format and it will appear on map if it's present in the leak report.")
                    )
      ),
      shiny::column(12,
                    shiny::wellPanel(
                      h3("Leak Report: Plots"),
                      p("Visulize and explore relationships in the Leak Report dataset."),
                      p("Generated plots can be saved locally using the plot toolbar in the
                        top right corner of your plot.")
                    )
      ),
      shiny::column(12,
                    shiny::wellPanel(
                      h3("Questions/Bugs/Concerns"),
                      p("Reach out to ",
                        shiny::tags$a(href = "mailto:talman@ualberta", "talman@ualberta"),
                        " with bug reports, comments, or questions."
                      )
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
