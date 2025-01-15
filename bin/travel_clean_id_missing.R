# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: stats for time vs distance


# guide to acronyms ----
# PAP = public access point - same as coastal access point (CAP)

#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate); library (leaflet)# 


#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel/")

# list of correct zip codes (not PO boxes, not military bases, etc)
d0<-read_csv("./results/California_Zip_Codes_matched.csv")%>%
  select(zip_code)%>%
  glimpse()


# ALL ACCESS ------------------------

# d1<-read_csv("./data/network_analyses_20240503/zipcode/all_access_zipcode_driving.txt")%>%
# routes (polyline)
d1a<-st_read("./data/network_analysis_20240909_FINAL/zipcode/all_access/all_access_zipcode_driving.gpkg")%>%
  select(Name,StartTime ,EndTime, Total_TravelTime,Total_Kilometers)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origion and destination
  arrange(zip_code)%>%
  st_drop_geometry()%>%
  select(-Shape)%>%
  mutate(zip_code=as.numeric(zip_code))%>%
  glimpse()

# merge with correct list of zip codes so not counting po boxes etc
d1<-d0%>%
  left_join(d1a)%>%
  glimpse()

# plot(d1)

plot(d1$Total_TravelTime~d1$Total_Kilometers)

# percent of CAP that are efficent access points
length(unique(d1$pap))
length(unique(d1$pap))/ 3684*100


m1<-lm(Total_TravelTime~Total_Kilometers,d1)
m1
summary(m1)




# MPAs -------------------------------------------

# length of this file is for each zip code with travel information
d2a<-st_read("./data/network_analysis_20240909_FINAL/zipcode/mpa_ferry/shapefile/main_zipcode_mpa_f_driving.shp")%>%
  select(Name,StartTimeUTC=StartTimeU, EndTimeUTC, Total_TravelTime=Total_Trav, Total_Kilometers=Total_Kilo)%>%#FacilityID,Total_TravelTime,Total_Kilometers,Shape)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origin and destination
  arrange(zip_code)%>%
  mutate(zip_code=as.numeric(zip_code))%>%
  glimpse()

# merge with correct list of zip codes so not counting po boxes etc
d2<-d0%>%
  left_join(d2a)%>%
  glimpse()


# zip codes with no mpa travel info
d2b<-d2%>%
  filter(is.na(pap))%>%
  select(zip_code)%>%
  glimpse()


plot(d2$Total_TravelTime~d2$Total_Kilometers)

m2<-lm(Total_TravelTime~Total_Kilometers,d2)
m2
summary(m2)


# nms ----------------------


d3a<-st_read("./data/network_analysis_20240909_FINAL/zipcode/nms_ferry_new_ch/shapefile/main_nms_ch_ferry_zipcode_driving.shp")%>%
  select(Name,StartTimeUTC=StartTimeU, EndTimeUTC, Total_TravelTime=Total_Trav, Total_Kilometers=Total_Kilo)%>%#FacilityID,Total_TravelTime,Total_Kilometers,Shape)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origin and destination
  arrange(zip_code)%>%
  mutate(zip_code=as.numeric(zip_code))%>%
  glimpse()

# merge with correct list of zip codes so not counting po boxes etc
d3<-d0%>%
  left_join(d3a)%>%
  glimpse()

plot(d3$Total_TravelTime~d3$Total_Kilometers)

m3<-lm(Total_TravelTime~Total_Kilometers,d3)
m3
summary(m3)


# zip codes with no nms travel info
d3b<-d3%>%
  filter(is.na(pap))%>%
  select(zip_code)%>%
  glimpse()




# piers and jetties --------------------------------------
d4a<-read_csv("./data/network_analyses_20240503/zipcode/piers_jetties_zip_code_driving_routes_attribute_table.csv")%>%  #note: this analysis not updated in sept 2024 because no change in access points
  select(XCoord,YCoord,Name,StartTime ,EndTime, Total_TravelTime=Total_Trav,Total_Kilometers=Total_Kilo)%>%
  separate_wider_delim(Name,names=c("zip_code","pier")," - ")%>%
  mutate(zip_code=as.numeric(zip_code))%>%#separate origion and destination
  mutate(Total_TravelTime=as.numeric(Total_TravelTime))%>%
  select(XCoord:pier,Total_TravelTime,Total_Kilometers)%>%
  glimpse()

# merge with correct list of zip codes so not counting po boxes etc
d4<-d0%>%
  left_join(d4a)%>%
  glimpse()

# view(d4)

d4b<-st_read("./gis/public_access_points_CA2/piers_jetties_ca.gpkg")%>% glimpse()


# includes PAJ that are not the closest
d4c<-d4%>%
  full_join(d4b)%>%
  glimpse()

# only closest PAJ
# note that a handful of PAJ do not have IDs
d4d<-d4%>%
  left_join(d4b)%>%
  glimpse()


plot(d4$Total_TravelTime~d4$Total_Kilometers)

m4<-lm(Total_TravelTime~Total_Kilometers,d4)
m4
summary(m4)

# zip codes with no pier travel info
d4b<-d4d%>%
  filter(is.na(id_paj))%>%
  select(zip_code)%>%
  glimpse()

# check if missing nms and mpa are the same ----------------------
d5<-full_join(d2b,d3b)%>%
  glimpse()

# save ---------------------------------

# correct list, still missing some info for mpa and nms
write_csv(d1,"./results/network_analysis_all_access_FINAL.csv")
write_csv(d2,"./results/network_analysis_mpa_some_missing.csv")
write_csv(d3,"./results/network_analysis_nms_some_missing.csv")
write_csv(d4,"./results/network_analysis_piers_jetties_FINAL.csv") # does not have id codes (d4d does, but missing some)

# mpa and nms zips without travel info
write_csv(d5,"./results/network_analysis_mpa_nms_missing.csv")

