read_clean <- function(upload_path, ...) {
  box::use(
    dplyr[mutate, select, arrange],
    purrr[map],
    tidyr[unnest_wider]
  )

  upload_path |>
    mutate(
      data = map(datapath, read_clean_csv_xls)
    ) |>
    unnest_wider(data) |>
    select(-c(size, type, datapath)) |>
    arrange(run_date)
}

read_clean_csv_xls <- function(filepath) {
  box::use(
    tools[file_ext],
    readr[read_csv, cols, col_character],
    janitor[clean_names, convert_to_date],
    dplyr[pull],
    utils[head],
    lubridate[mdy],
    dplyr[select]
  )

  filepath_ext <- filepath |>
    file_ext()

  func_read <- filepath_ext |>
    switch(
      csv = read_csv_classes,
      read_excel_classes
    )

  df <- filepath |>
    func_read() |>
    clean_names()

  if (!"run_date" %in% names(df)) {
    return(
      list(run_date = mdy("1/1/1900"), data = data.frame(error = "No run date"))
    )
  }

  func_convert_date <- filepath_ext |>
    switch(
      csv = mdy,
      \(x) convert_to_date(x, character_fun = mdy)
    )

  run_date <- df |>
    pull(run_date) |>
    head(1) |>
    func_convert_date()

  df_thin <- df |>
    select(-c(run_date, percent, enrl, waiting))

  list(run_date = run_date, data = df_thin)
}

read_csv_classes <- function(filepath) {
  box::use(
    readr[read_csv, cols, col_character]
  )

  filepath |>
    read_csv(col_types = cols(.default = col_character()), skip = 1)
}

read_excel_classes <- function(filepath) {
  box::use(
    readxl[read_excel]
  )

  filepath |>
    read_excel(col_types = "text", skip = 1)
}
