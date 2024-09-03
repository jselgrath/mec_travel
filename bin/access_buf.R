# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: create buffers for access points and piers
# ferries run separately

# guide to acronyms ----

#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate)# 


#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel")


# access points -------------------

# checks layers in the file
st_layers("./gis/public_access_points_CA2/access_ca2.gpkg")

# load
d1<-(st_read("./gis/public_access_points_CA2/access_ca2.gpkg", layer = "beach_access_ca"))%>%
  glimpse()

d2<-(st_read("./gis/public_access_points_CA2/access_ca2.gpkg", layer = "beach_parking_ca"))%>%
  glimpse()

d3<-(st_read("./gis/public_access_points_CA2/access_ca2.gpkg", layer = "piers_jetties"))%>%
  glimpse()

d4<-(st_read("./gis/public_access_points_CA2/access_ca2.gpkg", layer = "ferries"))%>%
  glimpse()

# 250m buffer ---------------------------
d1_250 <- d1%>%
  st_buffer(250)%>%
  glimpse()
plot(d1_250)

d2_250 <- d2%>%
  st_buffer(250)%>%glimpse()
plot(d2_250)

d3_250 <- d3%>%
  st_buffer(250)%>%glimpse()
plot(d3_250)

d4_250 <- d4%>%
  st_buffer(250)%>%glimpse()
plot(d4_250)

# 500m buffer ---------------------------
d1_500 <- d1%>%
  st_buffer(500)%>%
  glimpse()
plot(d1_500)

d2_500 <- d2%>%
  st_buffer(500)%>%glimpse()
plot(d2_500)

d3_500 <- d3%>%
  st_buffer(500)%>%glimpse()
plot(d3_500)

d4_500 <- d4%>%
  st_buffer(500)%>%glimpse()
plot(d4_500)

#all in one geopackage as layers
st_write(d1_250,"./gis/public_access_points_CA2_buf/access_ca_buf.gpkg","beach_access_ca_250m",delete_layer=T)
st_write(d2_250,"./gis/public_access_points_CA2_buf/access_ca_buf.gpkg","beach_parking_ca_250m", delete_layer=T)
st_write(d3_250,"./gis/public_access_points_CA2_buf/access_ca_buf.gpkg","piers_jetties_ca_250m", delete_layer=T)
st_write(d4_250,"./gis/public_access_points_CA2_buf/access_ca_buf.gpkg","ferries_250m", delete_layer=T)

st_write(d1_500,"./gis/public_access_points_CA2_buf/access_ca_buf.gpkg","beach_access_ca_500m",delete_layer=T)
st_write(d2_500,"./gis/public_access_points_CA2_buf/access_ca_buf.gpkg","beach_parking_ca_500m", delete_layer=T)
st_write(d3_500,"./gis/public_access_points_CA2_buf/access_ca_buf.gpkg","piers_jetties_ca_500m", delete_layer=T)
st_write(d4_500,"./gis/public_access_points_CA2_buf/access_ca_buf.gpkg","ferries_500m", delete_layer=T)
