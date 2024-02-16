find_changes <- function(df_classes) {
  box::use(
    dplyr[filter, mutate, lag, select],
    lubridate[mdy],
    purrr[map2],
    tidyr[unnest]
  )

  df_classes |>
    filter(run_date != mdy("1/1/1900")) |>
    mutate(
      changes = map2(data, lag(data), get_changes)
    ) |>
    select(-c(name, data)) |>
    unnest(changes)
}

get_changes <- function(df_new, df_old) {
  box::use(
    arsenal[comparedf],
    dplyr[bind_rows]
  )

  if (is.null(df_old)) {
    return(NULL)
  }

  df_compare <- comparedf(
    df_old, df_new,
    by = c("subject", "catalog", "section", "class_nbr", "pat_nbr")
  ) |>
    summary()

  df_new_observations <- df_compare |>
    get_observations(df_new, "y", "ALL NEW")

  df_removed_observations <- df_compare |>
    get_observations(df_old, "x", "ALL REMOVED")

  df_changed_observations <- df_compare |>
    get_change(df_new)

  bind_rows(
    df_new_observations, df_removed_observations, df_changed_observations
  )
}

get_observations <- function(df_compare, df, xy, changed_from) {
  box::use(
    dplyr[pull, filter, row_number, mutate]
  )

  observations <- df_compare$obs.table |>
    filter(version == xy) |>
    pull(observation)

  df |>
    filter(row_number() %in% observations) |>
    mutate(
      changed_from = !!changed_from
    )
}

get_change <- function(df_compare, df_new) {
  box::use(
    dplyr[group_by, mutate, summarise, row_number, inner_join, select],
    glue[glue]
  )

  df_changes <- df_compare$diffs.table |>
    group_by(row.y) |>
    mutate(
      change = glue("{var.y}: {values.x}")
    ) |>
    summarise(
      changed_from = paste(change, collapse = "; ")
    )

  df_new |>
    mutate(
      row.y = row_number()
    ) |>
    inner_join(df_changes, by = "row.y") |>
    select(-row.y)
}
