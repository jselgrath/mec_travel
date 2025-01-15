# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: join access buffers mpa data with access points
# note: ferry access not included because not within buffer

# guide to acronyms ----

#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate)# 


#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel")
# setwd("C:/Users/jselg/OneDrive/Documents/research/R_projects/mec_travel")

# access points -------------------

# non-buffered ferries
d0<-(st_read("./gis/public_access_points_CA2/access_ca2.gpkg", layer = "ferries"))%>%
  glimpse()
d0

d00<-d0%>%
  select(id_pap=id_ferry,access_name=id_ferry,access_location,access_type, access_type_detail=access_name)%>%
  mutate(access_county=if_else(id_pap=="ferry_3" | id_pap=="ferry_4","Ventura",
                               if_else(id_pap=="ferry_5","Orange","Los Angeles")))%>%
  mutate(id_mpa=if_else(id_pap=="ferry_3" | id_pap=="ferry_4", 
                        "mpa_northern_channel_islands","mpa_catalina"))%>%
  mutate(mpa_name=if_else(id_pap=="ferry_3" | id_pap=="ferry_4", 
                          "mpa_northern_channel_islands","mpa_catalina"))%>%
  mutate(mpa_type="mixed")%>%
  mutate(id_nms=if_else(id_pap=="ferry_3" | id_pap=="ferry_4",
                        "nms_2",NA))%>%
  mutate(nms_name=if_else(id_pap=="ferry_3" | id_pap=="ferry_4",
                          "CINMS",NA))%>%
  mutate(nms_full_name= if_else(id_pap=="ferry_3" | id_pap=="ferry_4",
                                "Channel Islands National Marine Sanctuary",NA))%>%
  select(id_pap, id_mpa,mpa_name,mpa_type,access_name:access_type_detail,access_county,id_nms,nms_name,nms_full_name)%>%
  glimpse()
d00


st_write(d00,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","ferries2",delete_layer=T)