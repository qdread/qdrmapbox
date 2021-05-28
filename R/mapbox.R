#' Download tiles from mapbox given zoom level and the calculated tile indices
#'
#' @export
download_mapbox_tiles <- function(zoom, tile_numbers_mat, download_dir, resolution = 'high', jpg_quality = 90) {
  res <- ifelse(resolution == 'high', '@2x', '')
  baseurl <- 'https://api.mapbox.com/v4/mapbox.satellite'
  api_calls <- glue::glue('{baseurl}/{zoom}/{tile_numbers_mat[,"x"]}/{tile_numbers_mat[,"y"]}{res}.jpg{jpg_quality}?access_token=')
  file_names <- glue::glue('{download_dir}/tile_{tile_numbers_mat[,"x"]}_{tile_numbers_mat[,"y"]}.jpg')

  tile_numbers_df <- data.frame(tile_numbers_mat, api_call = api_calls, file_name = file_names, output_file_name = output_file_names)

  purrr::pwalk(tile_numbers_df, function(api_call, file_name, ...) curl::curl_download(url = glue('{api_call}{Sys.getenv("MAPBOXAPIKEY")}'), destfile = file_name))

  return(tile_numbers_df)

}

#' Set Mapbox API key as environment variable
#'
#' @export
set_mapbox_api_key <- function(keyfile) {
  Sys.setenv(MAPBOXAPIKEY = readLines(keyfile))
}

