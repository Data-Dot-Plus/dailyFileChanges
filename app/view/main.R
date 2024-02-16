box::use(
  shiny[NS, tabsetPanel, tabPanel],
  DT[DTOutput]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tabsetPanel(
    tabPanel(
      "Success",
      DTOutput(ns("success"))
    ),
    tabPanel(
      "Best Combinations",
      DTOutput(ns("best_combinations"))
    )
  )

}

box::use(
  shiny[moduleServer],
  DT[renderDataTable]
)

#' @export
server <- function(id, rct_df_success, rct_df_best_combination) {
  moduleServer(id, function(input, output, session) {
    output$success <- renderDataTable(rct_df_success())

    output$best_combinations <- renderDataTable(rct_df_best_combination())
  })
}
