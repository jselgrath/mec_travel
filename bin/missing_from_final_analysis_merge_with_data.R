# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: add in missing zip code data to final runs for MPA and NMS

# guide to acronyms ----
# PAP = public access point - same as coastal access point (CAP)

#--------------------------------------------------------
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate); library (leaflet) 
#--------------------------------------------------------

remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel/")

# list of correct zip codes (not PO boxes, not military bases, etc)
d0<-read_csv("./results/California_Zip_Codes_matched.csv")%>%
  select(zip_code)%>%
  glimpse()

# missing data and guide to correct locations from visually looking in ArcPRo
d1<-st_read("./gis/California_Zip_Codes_missing_edited.shp")%>%
  st_drop_geometry()%>%
  select(zip_code:nms_access)%>%
  glimpse()
plot(d1)


# travel times from old analyses
# all
d2a<-read_csv("./data/network_analyses_20240503/zipcode/all_access_zipcode_driving.txt")%>%
  select(Name,Total_TravelTime, Total_Kilometers)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origin and destination
  arrange(zip_code)%>%
  mutate(zip_code=as.numeric(zip_code))%>%
  right_join(d0)%>%
  glimpse()

filter(d2a,zip_code==93222)

# ferry
d2f<-read_csv("./data/network_analyses_20240503/zipcode/ferry_zipcode_driving.txt")%>%
  select(Name,Total_TravelTime, Total_Kilometers)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origin and destination
  arrange(zip_code)%>%
  mutate(zip_code=as.numeric(zip_code))%>%
  right_join(d0)%>%
  glimpse()

# mpa
d2m<-read_csv("./data/network_analyses_20240503/zipcode/mpa_zipcode_driving.txt")%>%
  select(Name,Total_TravelTime, Total_Kilometers)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origin and destination
  arrange(zip_code)%>%
  mutate(zip_code=as.numeric(zip_code))%>%
  right_join(d0)%>%
  glimpse()

# nms
d2n<-read_csv("./data/network_analyses_20240503/zipcode/nms_zipcode_driving.txt")%>%
  select(Name,Total_TravelTime, Total_Kilometers)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origin and destination
  arrange(zip_code)%>%
  mutate(zip_code=as.numeric(zip_code))%>%
  right_join(d0)%>%
  glimpse()

# near final travel analyses with missing zip codes
# remove missing zip codes
d3m<-read_csv("./results/network_analysis_mpa_some_missing.csv")%>%
  select(-StartTimeUTC,-EndTimeUTC,-geometry)%>%
  anti_join(d1)%>%
  glimpse()

d3n<-read_csv("./results/network_analysis_nms_some_missing.csv")%>%
  select(-StartTimeUTC,-EndTimeUTC,-geometry)%>%
  anti_join(d1)%>%
  glimpse()

names(d3m) #"zip_code", "pap", "Total_TravelTime", "Total_Kilometers", "geometry"


# --------------------------------------
# MPAS
# ferry= closest mpa
d4m<-d1%>% 
  filter(mpa_access=="ferry")%>% # missing that are closest to ferry 3
  select(zip_code)%>%
  left_join(d2f)%>%
  select(zip_code,pap,Total_TravelTime,Total_Kilometers)%>%
  glimpse()

# non-ferry mpa - this has mpas not pap but can join later
d5m<-d1%>% 
  filter(mpa_access!="ferry")%>% # missing that are closest to ferries
  select(zip_code)%>%
  left_join(d2m)%>%
  select(zip_code,pap,Total_TravelTime,Total_Kilometers)%>%
  filter(!is.na(pap))%>%
  glimpse()

# add avalon manually - not on access list - estimating time and distance, but is VERY Short
av<-c(90704,"mpa_82",3,.3)


# append
# mpa
d9m<-rbind(d3m,d4m,d5m,av)%>%
  arrange()%>%
  mutate(zip_code=as.numeric(zip_code))%>%
  glimpse()

# check
test<-d0%>%anti_join(d9m)%>% # was missing avalon
  glimpse()


# ------------------------------------
# nms


# ferry= closest nms
d4n<-d1%>% 
  filter(nms_access=="ferry3")%>% # missing that are closest to ferry 3
  select(zip_code)%>%
  left_join(d2f)%>%
  select(zip_code,pap,Total_TravelTime,Total_Kilometers)%>%
  glimpse()


# chnms
# ferry= closest nms
d5n<-d1%>% 
  filter(nms_access=="see beach")%>% 
  select(zip_code)%>%
  left_join(d2a)%>%
  select(zip_code,pap,Total_TravelTime,Total_Kilometers)%>%
  glimpse()

d6n<-d1%>% 
  filter(nms_access!="see beach"&nms_access!="ferry3")%>% 
  select(zip_code)%>%
  left_join(d2a)%>%
  select(zip_code,pap,Total_TravelTime,Total_Kilometers)%>%
  glimpse()

# nms
d9n<-rbind(d3n,d4n,d5n,d6n)%>%
  arrange(zip_code)%>%
  glimpse()

# check
test2<-d0%>%anti_join(d9n)%>% 
  glimpse()
  

# save
write_csv(d9m,"./results/network_analysis_mpa_FINAL.csv")
write_csv(d9n,"./results/network_analysis_nms_almost_FINAL.csv")
