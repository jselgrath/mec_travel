# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: join access buffers mpa data with access points
# note: ferry access not included because not within buffer

# guide to acronyms ----

#---------------------------------------------------------------
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate)# 
library(data.table)


#---------------------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel/")


# ALL ACCESS ------------------------

# older run of model ---------------------
d0<-read_csv("./data/network_analyses_20240503/zipcode/all_access_zipcode_driving.txt")%>%
  select(Name,StartTime ,EndTime, Total_TravelTime,Total_Kilometers)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origion and destination
  glimpse()

length(unique(d0$zip_code))
length(unique(d0$pap))

# final run of model - routes ---------------------
d1a<-st_read("./data/network_analysis_20240909_FINAL/zipcode/all_access/all_access_zipcode_driving.gpkg")%>%
  select(Name,StartTime ,EndTime, Total_TravelTime,Total_Kilometers)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origion and destination
  arrange(zip_code)%>%
  glimpse()

d1<-d1a%>%
  st_drop_geometry()%>%
  select(-Shape)%>%
  glimpse()
d1
glimpse(d1)

length(unique(d1$zip_code))
length(unique(d1$pap))

# state zip code data - areas ---------------------
# graphed in GIS and looks like islands, national parks, forests, military bases are not included in this list.
d2a<-st_read("./data/California_Zip_Codes/california_zip_codes/California_Zip_Codes.gpkg")%>%
  select(zip_code='ZIP_CODE')%>%
  mutate(type="state")%>%
  glimpse()

d2<-d2a%>%
  st_drop_geometry()%>%
  glimpse()

glimpse(d2)
glimpse(d2)

length(unique(d2$zip_code))

# left join by zip code from state data - includes zip codes for islands, national parks, forests, military bases
# 2328
d3<-d2%>%
  full_join(d1,by="zip_code")%>%
  unique()%>%
  glimpse()
# view(d3)

# anti join by zip code from state data - 109 records. graphed in GIS and looks like islands, national parks, forests, military bases.
d3a<-d2%>%
  anti_join(d1,by="zip_code")%>%
  select(zip_code)%>%
  glimpse()

# anti join by zip code from state data - 109 records. graphed in GIS and looks like islands, national parks, forests, military bases.
# 607 included in runs, but not included in state zip code list. these are po box zip codes
d3b<-d1%>%
  anti_join(d2,by="zip_code")%>%
  select(zip_code)%>%
  glimpse()

# total unmatched (includes po boxes, miliatary bases, etc)
d3e<-d3a%>%
  full_join(d3b)%>%
  glimpse()


# unmatched - these are po boxes based on checking on the internet
d4<-d0%>% 
  right_join(d3b)%>% 
  glimpse()
d4

# check total number with spatial data, not po boxes, etc
d5<-d2a%>%
  inner_join(d1)%>%
  glimpse()


# write_csv(d4,"./results/unmatched_zip_codes.csv")
st_write(d5,"./gis/California_Zip_Codes_matched.shp")
write_csv(d5,"./results/California_Zip_Codes_matched.csv")
write_csv(d3e,"./results/California_Zip_Codes_unmatched_all.csv")

