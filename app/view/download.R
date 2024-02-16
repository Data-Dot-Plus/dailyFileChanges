box::use(
  shiny[NS, downloadButton]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  downloadButton(ns("download"), "Download best combinations")
}

box::use(
  shiny[moduleServer, downloadHandler],
  openxlsx[write.xlsx]
)

#' @export
server <- function(id, rct_df_best_combination) {
  moduleServer(id, function(input, output, session) {
    output$download <- downloadHandler(
      filename = "best_combination_subset.xlsx",
      content = function(file) {
        write.xlsx(rct_df_best_combination(), file)
      }
    )
  })
}
