#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    shiny::navbarPage(title = "Alberta Well Leak Report", id = "main_navbar",
                      shiny::tabPanel("Map Summary",
                                      mod_mapsummaryAB_ui("mapsummaryAB_1")
                      ),
                      shiny::tabPanel("Map Wells",
                                      mod_mapwellsAB_ui("mapwellsAB_1")
                      ),
                      shiny::tabPanel("Plot Wells",
                                      mod_plotwellsAB_ui("plotwellsAB_1")
                      ),
                      shiny::tabPanel("User Guide",
                                      mod_userguideAB_ui("userguideAB_1")
                      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "abwellleaks"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
