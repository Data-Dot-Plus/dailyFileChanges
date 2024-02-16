read_csvs_clean <- function(upload_path, ...) {
  box::use(
    dplyr[mutate, select, arrange],
    purrr[map],
    tidyr[unnest_wider]
  )

  upload_path |>
    mutate(
      data = map(datapath, read_clean_csv)
    ) |>
    unnest_wider(data) |>
    select(-c(size, type, datapath)) |>
    arrange(run_date)
}

read_clean_csv <- function(filepath) {
  box::use(
    readr[read_csv, cols, col_character],
    janitor[clean_names],
    dplyr[pull],
    utils[head],
    lubridate[mdy],
    dplyr[select]
  )

  df <- filepath |>
    read_csv(col_types = cols(.default = col_character()), skip = 1) |>
    clean_names()

  if (!"run_date" %in% names(df)) {
    return(
      list(run_date = mdy("1/1/1900"), data = data.frame(error = "No run date"))
    )
  }

  run_date <- df |>
    pull(run_date) |>
    head(1) |>
    mdy()

  df_thin <- df |>
    select(-run_date)

  list(run_date = run_date, data = df_thin)
}
