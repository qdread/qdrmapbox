#remotes::install_github('qdread/qdrmapbox')

# Setup
library(qdrmapbox)
set_mapbox_api_key('~/Documents/mapboxapikey.txt')

# Define zoom level and map corners, then find corresponding tile numbers.
zoom <- 8
upper_left <- c(39.8, -79.5)
lower_right <- c(37.8, -74.8)

md_tile_index <- find_tile_numbers(zoom = zoom, upper_left = upper_left, lower_right = lower_right)

# Define download directory, then query API to download the high-resolution tiles there
download_dir <- '~/mdtiles'

md_tile_df <- download_mapbox_tiles(tile_numbers_mat = md_tile_index, download_dir = download_dir, resolution = 'high', jpg_quality = 90)

# Use GDAL to georeference and mosaic the tiles
georeference_all_tiles(md_tile_df)

build_virtual_raster(md_tile_df, file.path(download_dir, 'mdimage.vrt'))

# Load packages for making the map
library(sf)
library(raster)
library(USAboundaries)
library(ggspatial)
library(ggplot2)

# Read mosaicked image back in as a raster stack
mdimage_raster <- stack(file.path(download_dir, 'mdimage.vrt'))

# Get data on Maryland counties and cities for making map
md_counties <- us_counties(resolution = 'high', states = 'MD')
md_cities <- us_cities(states = 'MD')

# Make the map with the background image, in web Mercator projection, and add the proper attribution
ggplot() +
  annotation_spatial(data = mdimage_raster, alpha = 0.9) +
  geom_sf(data = st_geometry(md_counties), color = 'white', fill = NA) +
  geom_sf(data = md_cities, aes(color = population), size = 2) +
  coord_sf(crs = 3857) +
  mapbox_logo(xmin = -8870000, xmax = -8820000, ymin = 4535000, ymax = 4590000) +
  annotate('text', x = Inf, y = -Inf, label = '\u00a9 Mapbox \u00a9 OpenStreetMap', hjust = 1, vjust = -1, color = 'white', size = 2) +
  scale_color_viridis_c(trans = 'log10', labels = function(x) format(x, scientific = FALSE))
