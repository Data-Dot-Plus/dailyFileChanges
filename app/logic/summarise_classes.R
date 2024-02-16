summarise_classes <- function(df_classes) {
  box::use(
    dplyr[mutate, select],
    purrr[map_int]
  )

  df_classes |>
    mutate(
      n_rows = map_int(data, nrow)
    ) |>
    select(-data)
}
