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



# ALL ACCESS ------------------------
# d1<-read_csv("./data/network_analyses_20240503/zipcode/all_access_zipcode_driving.txt")%>%
d1<-st_read("./data/network_analysis_20240909_FINAL/zipcode/all_access/all_access_zipcode_driving.gpkg")%>%
  select(Name,StartTime ,EndTime, Total_TravelTime,Total_Kilometers)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origion and destination
  arrange(zip_code)%>%
  glimpse()

plot(d1$Total_TravelTime~d1$Total_Kilometers)

m1<-lm(Total_TravelTime~Total_Kilometers,d1)
m1
summary(m1)

# MPAs -------------------------------------------
d2<-st_read("./data/network_analysis_20240909_FINAL/zipcode/mpa_ferry/shapefile/main_zipcode_mpa_f_driving.shp")%>%
  select(Name,StartTimeUTC=StartTimeU, EndTimeUTC, Total_TravelTime=Total_Trav, Total_Kilometers=Total_Kilo)%>%#FacilityID,Total_TravelTime,Total_Kilometers,Shape)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origin and destination
  arrange(zip_code)%>%
  glimpse()

plot(d2$Total_TravelTime~d2$Total_Kilometers)

m2<-lm(Total_TravelTime~Total_Kilometers,d2)
m2
summary(m2)


# nms ----------------------
d3<-st_read("./data/network_analysis_20240909_FINAL/zipcode/nms_ferry_new_ch/shapefile/main_nms_ch_ferry_zipcode_driving.shp")%>%
  select(Name,StartTimeUTC=StartTimeU, EndTimeUTC, Total_TravelTime=Total_Trav, Total_Kilometers=Total_Kilo)%>%#FacilityID,Total_TravelTime,Total_Kilometers,Shape)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origin and destination
  arrange(zip_code)%>%
  glimpse()

plot(d3$Total_TravelTime~d3$Total_Kilometers)

m3<-lm(Total_TravelTime~Total_Kilometers,d3)
m3
summary(m3)


# piers and jetties
d4<-read_csv("./data/network_analyses_20240503/zipcode/piers_jetties_zip_code_driving_routes_attribute_table.csv")%>%  #note: this analysis not updated in sept 2024 because no change in access points
  select(XCoord,YCoord,Name,StartTime ,EndTime, Total_TravelTime=Total_Trav,Total_Kilometers=Total_Kilo)%>%
  separate_wider_delim(Name,names=c("zip_code","pier")," - ")%>%
  mutate(zip_code=as.numeric(zip_code))%>%#separate origion and destination
  mutate(Total_TravelTime=as.numeric(Total_TravelTime),
         StartTime=as_datetime(StartTime),
         EndTime=as_datetime(EndTime))%>%
  glimpse()

plot(d4$Total_TravelTime~d4$Total_Kilometers)

m4<-lm(Total_TravelTime~Total_Kilometers,d4)
m4
summary(m4)
