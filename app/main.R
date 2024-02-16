box::use(
  shiny[NS, fluidPage, sidebarLayout, sidebarPanel, mainPanel, numericInput],
  app/view/upload,
  app/view/download,
  app/view/main
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  fluidPage(
    sidebarLayout(
      sidebarPanel(
        upload$ui(ns("upload")),
        download$ui(ns("download"))
      ),
      mainPanel(
        main$ui(ns("main"))
      )
    )
  )
}

box::use(
  shiny[moduleServer, reactive, req, renderText],
  app/view/upload,
  app/logic/read_clean[read_clean],
  app/logic/find_changes[find_changes],
  app/logic/summarise_classes[summarise_classes],
  app/view/main,
  app/view/download
)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    rct_upload_path <- upload$server("upload")

    rct_df_classes <- reactive({
      req(rct_upload_path())

      rct_upload_path() |>
        read_clean()
    })

    rct_df_classes_summary <- reactive({
      rct_df_classes() |>
        summarise_classes()
    })

    rct_df_changes <- reactive({
      rct_df_classes() |>
        find_changes()
    })

    main$server(
      "main", rct_df_classes_summary, rct_df_changes
    )

    download$server("download", rct_df_changes)
  })
}
