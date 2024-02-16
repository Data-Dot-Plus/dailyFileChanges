box::use(
  shiny[NS, fileInput]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  fileInput(
    ns("upload"),
    "Upload the class CSV or XLS* files",
    multiple = TRUE,
    accept = c(".csv", ".xls*")
  )
}

box::use(
  shiny[moduleServer, reactive, validate, need]
)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive({
      validate(
        need(input$upload, message = "Please upload data files")
      )

      input$upload
    })
  })
}
