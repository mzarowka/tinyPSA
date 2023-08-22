#' Read GRADISTAT data and save to Excel file
#'
#' @param path path to single file or directory
#'
#' @return  tibble with cleaned data
#' @export
tpsa_gstat_read <- function(path){
  # Get file name
  file_name <- basename(path) |>
    # Remove extension
    fs::path_ext_remove()

  cli::cli_alert_info("Reading GRADISTAT xlsm file {file_name}.")

  # Read data
  data <- path |>
    # Read data anchored at cell C4
    readxl::read_excel(sheet = "Multiple Sample Statistics",
                       range = cellranger::cell_limits(c(4, 3), c(NA, NA))) |>
    # Bind with variable names
    dplyr::bind_cols(gstat_vars[1]) |>
    # Relocate variable names to front
    dplyr::relocate(variable)

  gstat_descriptors <- data |>
    # Keep only description rows
    dplyr::filter(variable %in% gstat_desc) |>
    # Pivot longer
    tidyr::pivot_longer(-variable, names_to = "sample", values_to = "value") |>
    # Pivot wider
    tidyr::pivot_wider(names_from = variable, values_from = value)

  gstat_num <- data |>
    # Keep only numeric variables
    dplyr::filter(!variable %in% gstat_desc) |>
    # Convert to numeric
    dplyr::mutate(dplyr::across(-variable, \(x) as.numeric(x))) |>
    # Pivot longer
    tidyr::pivot_longer(-variable, names_to = "sample", values_to = "value") |>
    # Pivot wider
    tidyr::pivot_wider(names_from = variable, values_from = value)

  data <- dplyr::left_join(gstat_descriptors, gstat_num, dplyr::join_by(sample == sample))

  cli::cli_alert_info("Writing cleaned {file_name}.xlsx.")

  # Write to file
  writexl::write_xlsx(data, path = fs::path(fs::path_dir(path), file_name, ext = "xlsx"))

  cli::cli_alert_success("Finished {file_name}.")

  # Return data
  data
}
