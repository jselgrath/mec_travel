# ocean access
# jenny Selgrath
# goal - make hex grids for CA

# -----------------------------
# useful R blogs:
# https://rpubs.com/dieghernan/beautifulmaps_I # hexagon grids
# https://urbandatapalette.com/post/2021-08-tessellation-sf/
# https://ucd-cws.github.io/CABW2020_R_training/m2_3_using_sf.html #projecting in sf
# -----------------------------

library(sf)
library(rnaturalearth)
library(dplyr)
library(RColorBrewer)
library(tidyverse)

# -------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/gis/")

# ca  boundary downloaded from CA website (see readme file)
ca<-read_sf("./ca_state_boundary/ca_state_boundaries.shp")
ca
plot(ca)

# blocks
ca_b<-read_csv("./mec_access/origins/block_group/block_group_all.csv")%>%
  
  # turn into spatial file in sf (simple features R package)
  st_as_sf(coords = c("LONGITUDE", "LATITUDE"), # note we put lon (or X) first!
           remove = F, # don't remove these lat/lon cols from the dataframe
           crs = 4326) # add projection (this is WGS84)
plot(ca_b)
st_crs(ca_b)



# Create my own color palette
mypal <- colorRampPalette(c("#F3F8F8", "#008080"))


#test from blog
# GB <- ne_download(50,
#                   type = "map_subunits",
#                   returnclass = "sf",
#                   destdir = tempdir()
# ) %>%
#   subset(CONTINENT == "Europe") %>%
#   subset(ADM0_A3 == "GBR")
# 
# # Projecting and cleaning
# GB <- st_transform(GB, 3857) %>% select(NAME_EN, ADM0_A3)
# initial <- GB
# initial$index_target <- 1:nrow(initial)
# target <- st_geometry(initial)
# 




setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel") 
ca2<-read_sf("./gis/public_access_points_CA2/access_ca2.gpkg","ca") # file from kiki in access data 
ca2
plot(ca2)

# check projection
st_crs(ca2)

# transform to CA Albers (equal area)
ca3<-st_transform(ca2,crs=3310)
st_crs(ca3)

initial <- ca3
initial$index_target <- 1:nrow(initial)
target <- st_geometry(initial)


plot(target)

# ideally 2 or 2.5 km
grid <- st_make_grid(target,
                     2 * 1000, # Kms   #  edge length is cellsize/sqrt(3)
                     crs = st_crs(initial),
                     what = "polygons",
                     square = FALSE # This is the only piece that changes!!!
)
# Make sf
grid <- st_sf(index = 1:length(lengths(grid)), grid) # Add index

# We identify the grids that belongs to a entity by assessing the centroid
cent_grid <- st_centroid(grid)
cent_merge <- st_join(cent_grid, initial["index_target"], left = F)
grid_new <- inner_join(grid, st_drop_geometry(cent_merge))

# Honeycomb
Honeygeom <- aggregate(
  grid_new,
  by = list(grid_new$index_target),
  FUN = min,
  do_union = FALSE
)

# Lets add the dataframe - joins back to original data - not a spatial join
Honeycomb <- left_join(
  Honeygeom %>%
    select(index_target),
  st_drop_geometry(initial)
) %>%
  select(-index_target)

# create the Hexbin

Hexbingeom <- aggregate(
  st_buffer(grid_new, 0.5), # Avoid slivers
  by = list(grid_new$index_target),
  FUN = min,
  do_union = TRUE
)

# binned - we do not need this
Hexbin <- left_join(
  Hexbingeom %>%
    select(index_target),
  st_drop_geometry(initial)
) %>%
  select(-index_target)

# Plot
par(mfrow = c(1, 2), mar = c(1, 1, 1, 1))
plot(st_geometry(Honeycomb), col = mypal(4), main = "Honeycomb")
plot(st_geometry(Hexbin), col = mypal(4), main = "Hexbin")
plot(st_geometry(Honeygeom), col = mypal(4), main = "Honeygeom")

# save 
st_write(Honeycomb,"./gis/ca_hexagons/ca_hexagon.gpkg","honeycomb",delete_layer=T)
st_write(Honeygeom,"./gis/ca_hexagons/ca_hexagon.gpkg","honeygeom",delete_layer=T)
