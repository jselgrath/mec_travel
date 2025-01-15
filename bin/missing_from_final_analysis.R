# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: pull travel data for missing zip codes from final run


# guide to acronyms ----
# PAP = public access point - same as coastal access point (CAP)

#--------------------------------------------------------
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate); library (leaflet)# 
#--------------------------------------------------------

remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel/")

# mpa and nms zips without travel info
d1<-read_csv("./results/network_analysis_mpa_nms_missing.csv")%>%
  mutate(ZIP_CODE=as.character(zip_code))%>%
  glimpse

d2<-st_read("./data/California_Zip_Codes/california_zip_codes/california_zip_codes.gpkg",layer="California_Zip_Codes")%>%
  glimpse
plot(d2[,1])

d3<-d2%>%
  right_join(d1)%>%
  select(-ZIP_CODE)%>%
  glimpse()

plot(d3)
plot(d3[,1])

st_write(d3,"./gis/California_Zip_Codes_missing.shp")
# manually edited in ArcPro