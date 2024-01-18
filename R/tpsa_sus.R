#' Read and write Bartington magnetic susceptibility sus files.
#'
#' @param path path to single file.
#'
#' @return a tibble with cleaned data.
#' @export
tpsa_read_sus <- function(path){
  # Get file name
  file_name <- basename(path) |>
    # Remove extension
    fs::path_ext_remove()

  cli::cli_alert_info("Reading file {file_name}.")

  # Read data
  data <- path |>
    readr::read_delim(delim = ",",
                      skip = 15,
                      col_names = c("position.cm", "mag_sus.si"))

  cli::cli_alert_info("Writing cleaned {file_name}.xlsx.")

  # Write to file
  writexl::write_xlsx(data, path = fs::path(fs::path_dir(path), file_name, ext = "xlsx"))

  cli::cli_alert_success("Finished {file_name}.")

  # Return data
  return(data)
}
