box::use(
  shiny[NS, downloadButton]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  downloadButton(ns("download"), "Download changes")
}

box::use(
  shiny[moduleServer, downloadHandler],
  openxlsx[write.xlsx]
)

#' @export
server <- function(id, rct_df_changes) {
  moduleServer(id, function(input, output, session) {
    output$download <- downloadHandler(
      filename = "changes.xlsx",
      content = function(file) {
        write.xlsx(rct_df_changes(), file)
      }
    )
  })
}
