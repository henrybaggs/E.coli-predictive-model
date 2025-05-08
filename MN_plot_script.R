library(dplyr)
library(ebirdst)
library(fields)
library(ggplot2)
library(lubridate)
library(rnaturalearth)
library(sf)
library(terra)
library(tidyr)
extract <- terra::extract



# This is an example from the ebirdst documentation: NOT original work


# set_ebirdst_access_key("bnta6b38igiq")


# download the canada goose data
ebirdst_download_status("cangoo",
                        pattern = "abundance_seasonal_mean")

# load seasonal mean relative abundance at 3km resolution
abd_seasonal <- load_raster("cangoo", 
                            product = "abundance", 
                            period = "seasonal",
                            metric = "mean",
                            resolution = "3km")

# extract just the breeding season relative abundance
abd_breeding <- abd_seasonal[["breeding"]]

plot(abd_breeding, axes = FALSE)


# MN boundary
region_boundary <- ne_states(iso_a2 = "US") %>%
  filter(name == "Minnesota")

# project boundary to match raster data
region_boundary_proj <- st_transform(region_boundary, st_crs(abd_breeding))

# crop and mask to boundary of MN
abd_breeding_mask <- crop(abd_breeding, region_boundary_proj) %>%
  mask(region_boundary_proj)

# map the cropped data
plot(abd_breeding_mask, axes = FALSE)


# find the centroid of the region
region_centroid <- region_boundary %>% 
  st_geometry() %>% 
  st_transform(crs = 4326) %>% 
  st_centroid() %>% 
  st_coordinates() %>% 
  round(1)

# define projection
crs_laea <- paste0("+proj=laea +lat_0=", region_centroid[2],
                   " +lon_0=", region_centroid[1])

# transform to the custom projection using nearest neighbor resampling
abd_breeding_laea <- project(abd_breeding_mask, crs_laea, method = "near") %>% 
  # remove areas of the raster containing no data
  trim()

# map the cropped and projected data
plot(abd_breeding_laea, axes = FALSE, breakby = "cases")


# quantiles of non-zero values
v <- values(abd_breeding_laea, na.rm = TRUE, mat = FALSE)
v <- v[v > 0]
breaks <- quantile(v, seq(0, 1, by = 0.1))
# add a bin for 0
breaks <- c(0, breaks)

# status and trends palette
pal <- ebirdst_palettes(length(breaks) - 2)
# add a color for zero
pal <- c("#e6e6e6", pal)

# map using the quantile bins
plot(abd_breeding_laea, breaks = breaks, col = pal, axes = FALSE)



