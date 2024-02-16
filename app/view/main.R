box::use(
  shiny[NS, tabsetPanel, tabPanel],
  DT[DTOutput]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tabsetPanel(
    tabPanel(
      "Classes",
      DTOutput(ns("classes"))
    ),
    tabPanel(
      "Changes",
      DTOutput(ns("changes"))
    )
  )

}

box::use(
  shiny[moduleServer],
  DT[renderDataTable]
)

#' @export
server <- function(id, rct_df_classes, rct_df_changes) {
  moduleServer(id, function(input, output, session) {
    output$classes <- renderDataTable(rct_df_classes())

    output$changes <- renderDataTable(rct_df_changes())
  })
}
