#' Download tiles from mapbox given zoom level and the calculated tile indices
#'
#' @export
download_mapbox_tiles <- function(tile_numbers_mat, download_dir, resolution = 'high', jpg_quality = 90) {
  if (!dir.exists(download_dir)) dir.create(path.expand(download_dir))

  res <- ifelse(resolution == 'high', '@2x', '')
  baseurl <- 'https://api.mapbox.com/v4/mapbox.satellite'
  api_calls <- glue::glue('{baseurl}/{tile_numbers_mat[,"zoom"]}/{tile_numbers_mat[,"x"]}/{tile_numbers_mat[,"y"]}{res}.jpg{jpg_quality}?access_token=')
  file_names <- glue::glue('{download_dir}/tile_{tile_numbers_mat[,"x"]}_{tile_numbers_mat[,"y"]}.jpg')
  output_file_names <- gsub('jpg', 'tif', file_names)

  tile_numbers_df <- data.frame(tile_numbers_mat, api_call = api_calls, file_name = file_names, output_file_name = output_file_names)

  purrr::pwalk(tile_numbers_df, function(api_call, file_name, ...) curl::curl_download(url = glue::glue('{api_call}{Sys.getenv("MAPBOXAPIKEY")}'), destfile = file_name))

  return(tile_numbers_df)

}

#' Set Mapbox API key as environment variable
#'
#' @export
set_mapbox_api_key <- function(keyfile) {
  Sys.setenv(MAPBOXAPIKEY = readLines(keyfile))
}

#' Add Mapbox logo to plot
#'
#' @export
mapbox_logo <- function(xmin, xmax, ymin, ymax) {
  img <- png::readPNG(system.file("extdata/mapboxlogo.png", package="qdrmapbox"))
  g <- grid::rasterGrob(img, interpolate=TRUE)
  ggplot2::annotation_custom(g, xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax)
}
