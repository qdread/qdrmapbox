#' Find all tiles given a zoom level and the coordinates of each corner
#'
#' @export
find_tile_number <- function(zoom, lat_deg, lon_deg) {
  lat_rad <- lat_deg * pi / 180 # Convert lat to radians
  n <- 2 ^ zoom
  xtile <- floor(n * ((lon_deg + 180) / 360))
  ytile <- floor(n * (1 - (log(tan(lat_rad) + 1/cos(lat_rad)) / pi)) / 2)

  xtileseq <- seq(min(xtile), max(xtile))
  ytileseq <- seq(min(ytile), max(ytile))
  expand.grid(x = xtileseq, y = ytileseq)
}

#' Find coordinates of the upper left and lower right corners of a tile
#'
#' @export
corner_coords <- function(zoom, xtile, ytile) {
  n = 2 ^ zoom
  xcorners <- xtile + c(0, 1) # NW, SE
  ycorners <- ytile + c(0, 1)
  lon_deg = xcorners / n * 360.0 - 180.0
  lat_rad = atan(sinh(pi * (1 - 2 * ycorners / n)))
  lat_deg = lat_rad * 180.0 / pi
  cbind(lat = lat_deg, lon = lon_deg)
}

