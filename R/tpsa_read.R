#' Read and write Beckman Coulter Laser diffraction output spreadsheets
#'
#' @param path path to single file or directory
#' @param mode processing one file or directory
#'
#' @return a tibble with cleaned data
#' @export
tpsa_read <- function(path, mode) {
  if (mode == "file") {
    # Get file name
    file_name <- basename(path) |>
      # Remove extension
      fs::path_ext_remove()

    cli::cli_alert_info("Reading file {file_name}.")

    # Read data
    data <- path |>
      vroom::vroom(
        skip = 88, # skip rows
        col_select = c(1, 2), # select columns
        col_names = c("size_um", "volume_p"), # name selected columns
        col_types = "dd"
      ) # set data type for columns

    cli::cli_alert_info("Writing cleaned {file_name}.xlsx.")

    # Write to file
    writexl::write_xlsx(data, path = fs::path(fs::path_dir(path), file_name, ext = "xlsx"))

    cli::cli_alert_success("Finished {file_name}.")

    # Return data
    data

  } else {
    # List all files in the directory and provide extension for globbing
    files <- fs::dir_ls(path, glob = "*.csv", recurse = TRUE)

    # Get file names == sample names
    file_names <- fs::path_file(files) |>
      # Remove extension
      fs::path_ext_remove()

    cli::cli_alert_info("Reading files from {basename(fs::path(path))}.")

    # Read data
    data <- files |>
      # Read all .csv into list
      purrr::map(\(x) vroom::vroom(x,
        skip = 88, # skip rows
        col_select = c(1, 2), # select columns
        col_names = c("size_um", "volume_p"), # name selected columns
        col_types = "dd" # set data type for columns
      )) |>
      # Set names based on the file names
      purrr::set_names(nm = file_names) |>
      # Bind the list into tibble
      purrr::list_rbind(names_to = "sample") |>
      # Pivot so every sample is a one row
      tidyr::pivot_wider(
        names_from = size_um,
        names_prefix = "size_",
        values_from = "volume_p"
      )

    cli::cli_alert_info("Writing cleaned {basename(fs::path(path))}.xlsx.")

    # Write to file
    writexl::write_xlsx(data, path = fs::path(fs::path(path), basename(fs::path(path)), ext = "xlsx"))

    cli::cli_alert_success("Finished directory {basename(fs::path(path))}.")

    # Return data
    data
  }
}
