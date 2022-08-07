#' Georeference a Mapbox jpg tile and create GeoTiff
#'
#' @export
georeference_tile <- function(file_name, output_file_name, x, y, zoom, ...) {
  # Determine the two extreme corners of the tile.
  corners <- corner_coords(zoom, x, y)

  gdalUtilities::gdal_translate(path.expand(file_name),
                                path.expand(output_file_name),
                                of = 'GTiff',
                                a_ullr = c(corners[1, 'lon'], corners[1, 'lat'], corners[2, 'lon'], corners[2, 'lat']),
                                a_srs = "EPSG:4326")
}

#' Walk through tile file names and georeference all of them
#'
#' @export
georeference_all_tiles <- function(tile_numbers_df) {
  purrr::pwalk(tile_numbers_df, georeference_tile)
}

#' Build a virtual raster from GeoTIFFs
#'
#' @export
build_virtual_raster <- function(tile_numbers_df, vrt_file) {
  gdalUtilities::gdalbuildvrt(path.expand(tile_numbers_df$output_file_name), path.expand(vrt_file))
}
