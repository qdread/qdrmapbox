georeference_tile <- function(file_name, output_file_name, x, y, zoom, ...) {
  # Determine the two extreme corners of the tile.
  corners <- corner_coords(zoom, x, y)

  gdalUtils::gdal_translate(file_name,
                            output_file_name,
                            of = 'GTiff',
                            a_ullr = c(corners[1, 'lon'], corners[1, 'lat'], corners[2, 'lon'], corners[2, 'lat']),
                            a_srs = "EPSG:4326")
}
