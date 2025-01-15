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
# correct list, still missing some info for mpa and nms
d1<-read_csv("./results/network_analysis_all_access_FINAL.csv")
d2<-read_csv("./results/network_analysis_mpa_FINAL.csv")
d3<-read_csv("./results/network_analysis_nms_almost_FINAL.csv") #update this when Lucas Fixes this file
d4<-read_csv("./results/network_analysis_piers_jetties_FINAL.csv") # does not have id codes (d4d does, but missing some)


# All ACCESS ---------------------------
# graph etc
plot(d1$Total_TravelTime~d1$Total_Kilometers)

# percent of CAP that are efficent access points
length(unique(d1$pap))
length(unique(d1$pap))/ 3684*100


m1<-lm(Total_TravelTime~Total_Kilometers,d1)
m1
summary(m1)




# MPAs -------------------------------------------
plot(d2$Total_TravelTime~d2$Total_Kilometers)

m2<-lm(Total_TravelTime~Total_Kilometers,d2)
m2
summary(m2)


# nms ----------------------
plot(d3$Total_TravelTime~d3$Total_Kilometers)

m3<-lm(Total_TravelTime~Total_Kilometers,d3)
m3
summary(m3)


# piers and jetties --------------------------------------
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


# save ---------------------------------



