# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: identify which access points are near MPAs and sanctuaries
# note: ferry access not included because not within buffer

# guide to acronyms ----

#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate)# 


#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel")


# access points -------------------

# checks layers in the gpkg
st_layers("./gis/public_access_points_CA2_buf/access_ca_buf.gpkg")

# load 250m
d1<-(st_read("./gis/public_access_points_CA2_buf/access_ca_buf.gpkg", layer = "beach_access_ca_250m"))%>%
  glimpse()

d2<-(st_read("./gis/public_access_points_CA2_buf/access_ca_buf.gpkg", layer = "beach_parking_ca_250m"))%>%
  glimpse()

d3<-(st_read("./gis/public_access_points_CA2_buf/access_ca_buf.gpkg", layer = "piers_jetties_ca_250m"))%>%
# st_transform(4326)%>%
  glimpse()

d98<-(st_read("./gis/public_access_points_CA2_buf/access_ca_buf.gpkg", layer = "ferries_250m"))%>%
  glimpse()

# load 500m
d4<-(st_read("./gis/public_access_points_CA2_buf/access_ca_buf.gpkg", layer = "beach_access_ca_500m"))%>%
  glimpse()

d5<-(st_read("./gis/public_access_points_CA2_buf/access_ca_buf.gpkg", layer = "beach_parking_ca_500m"))%>%
  glimpse()

d6<-(st_read("./gis/public_access_points_CA2_buf/access_ca_buf.gpkg", layer = "piers_jetties_ca_500m"))%>%
  st_transform(4326)%>%
  glimpse()


d99<-(st_read("./gis/public_access_points_CA2_buf/access_ca_buf.gpkg", layer = "ferries_500m"))%>%
  glimpse()

# load MPA & sanctuary files-------------------------------------

# checks layers in the gpkg
st_layers("./gis/mpa_nms_all/mpa_nms_all.gpkg")

# mpas
d7<-(st_read("./gis/mpa_nms_all/mpa_nms_all.gpkg", layer = "mpa_ca"))%>%
  st_transform(4326)%>%
  glimpse()

# nms
d8<-(st_read("./gis/mpa_nms_all/mpa_nms_all.gpkg", layer = "nms_ca"))%>%
  glimpse()
plot(d8)

# chnms agency prefered alternative 
# https://nmssanctuaries.blob.core.windows.net/sanctuaries-prod/media/chumash/2023-chnms-boundary-alternative-maps.pdf
d9<-st_read("./gis/mpa_nms_all/mpa_nms_all.gpkg", layer = "nms_chnms_alt")%>%
  glimpse()

plot(d9)


# Intersections ------------------------------
# MPAs
d1_m<-d1%>%
  select(id_pap)%>%
  st_filter(d7)%>% #access
  st_join(d7)%>%
  select(id_pap,id_mpa,mpa_name=NAME,mpa_name_short=SHORTNAME,mpa_name_full=FULLNAME,mpa_type=Type,mpa_ccr=CCR, mpa_ccr_int=CCR_Int,mpa_area_sq_mi=Area_sq_mi,mpa_study_region=Study_Regi, mpa_acres=Acres, mpa_ha=Hectares)%>%
  mutate(mpa_250m=1)%>%
 glimpse()
# plot(d1_m)

d2_m<-d2%>%
  select(id_ppk)%>%
  st_filter(d7)%>% #parking
  st_join(d7)%>%
  select(id_ppk,id_mpa,mpa_name=NAME,mpa_name_short=SHORTNAME,mpa_name_full=FULLNAME,mpa_type=Type,mpa_ccr=CCR, mpa_ccr_int=CCR_Int,mpa_area_sq_mi=Area_sq_mi,mpa_study_region=Study_Regi,mpa_acres=Acres, mpa_ha=Hectares)%>%
  mutate(mpa_250m=1)%>%
  glimpse()
# plot(d2_m)


d3_m<-d3%>%
  select(id_paj)%>%
  st_filter(d7)%>% #jetties
  st_join(d7)%>%
  select(id_paj,id_mpa,mpa_name=NAME,mpa_name_short=SHORTNAME,mpa_name_full=FULLNAME,mpa_type=Type,mpa_ccr=CCR, mpa_ccr_int=CCR_Int,mpa_area_sq_mi=Area_sq_mi,mpa_study_region=Study_Regi,mpa_acres=Acres, mpa_ha=Hectares)%>%
  mutate(mpa_250m=1)%>%
  glimpse()
# plot(d3_m)

d4_m<-d4%>%
  select(id_pap)%>%
  st_filter(d7)%>% #parking
  st_join(d7)%>%
  select(id_pap,id_mpa,mpa_name=NAME,mpa_name_short=SHORTNAME,mpa_name_full=FULLNAME,mpa_type=Type,mpa_ccr=CCR, mpa_ccr_int=CCR_Int,mpa_area_sq_mi=Area_sq_mi,mpa_study_region=Study_Regi,mpa_acres=Acres, mpa_ha=Hectares)%>%
  mutate(mpa_500m=1)%>%
  glimpse()


d5_m<-d5%>%
  select(id_ppk)%>%
  st_filter(d7)%>% #parking
  st_join(d7)%>%
  select(id_ppk,id_mpa,mpa_name=NAME,mpa_name_short=SHORTNAME,mpa_name_full=FULLNAME,mpa_type=Type,mpa_ccr=CCR, mpa_ccr_int=CCR_Int,mpa_area_sq_mi=Area_sq_mi,mpa_study_region=Study_Regi,mpa_acres=Acres, mpa_ha=Hectares)%>%
  mutate(mpa_500m=1)%>%
  glimpse()
# plot(d5_m)

d6_m<- d6%>%
  select(id_paj)%>%
  st_filter(d7)%>% #jetties
  st_join(d7)%>%
  select(id_paj,id_mpa,mpa_name=NAME,mpa_name_short=SHORTNAME,mpa_name_full=FULLNAME,mpa_type=Type,mpa_ccr=CCR, mpa_ccr_int=CCR_Int,mpa_area_sq_mi=Area_sq_mi,mpa_study_region=Study_Regi,mpa_acres=Acres, mpa_ha=Hectares)%>%
  mutate(mpa_500m=1)%>%
  glimpse()
# plot(d6_m)

# NMS ---------------------------------------------------
d1_n<-d1%>%
  select(id_pap)%>%
  st_filter(d8)%>%
  st_join(d8)%>%
  select(id_pap,id_nms,nms_name,nms_full_name)%>%
  mutate(nms_250m=1)%>%
  glimpse()
# plot(d1_n)

d2_n<-d2%>%
  select(id_ppk)%>%
  st_filter(d8)%>%
  st_join(d8)%>%
  select(id_ppk,id_nms,nms_name,nms_full_name)%>%
  mutate(nms_250m=1)%>%
  glimpse()
# plot(d2_n)

d3_n<-d3%>%
  select(id_paj)%>%
  st_filter(d8)%>%
  st_join(d8)%>%
  select(id_paj,id_nms,nms_name,nms_full_name)%>%
  mutate(nms_250m=1)%>%
  glimpse()
# plot(d3_n)

d4_n<-d4%>%
  select(id_pap)%>%
  st_filter(d8)%>%
  st_join(d8)%>%
  select(id_pap,id_nms,nms_name,nms_full_name)%>%
  mutate(nms_500m=1)%>%
  glimpse()
# plot(d4_n)

d5_n<-d5%>%
  select(id_ppk)%>%
  st_filter(d8)%>%
  st_join(d8)%>%
  select(id_ppk,id_nms,nms_name,nms_full_name)%>%
  mutate(nms_500m=1)%>%
  glimpse()
# plot(d5_n)

d6_n<-d6%>%
  select(id_paj)%>%
  st_filter(d8)%>%
  st_join(d8)%>%
  select(id_paj,id_nms,nms_name,nms_full_name)%>%
  mutate(nms_500m=1)%>%
  glimpse()
# plot(d6_n)

# chumash ----------------------------------------------
# NMS
d1_c<-d1%>%
  select(id_pap)%>%
  st_filter(d9)%>%
  st_join(d9)%>%
  select(id_pap,id_nms,nms_name,nms_full_name)%>%
  mutate(ch_250m=1)%>%
  glimpse()
# plot(d1_c)

d2_c<-d2%>%
  select(id_ppk)%>%
  st_filter(d9)%>%
  st_join(d9)%>%
  select(id_ppk,id_nms,nms_name,nms_full_name)%>%
  mutate(ch_250m=1)%>%
  glimpse()
# plot(d2_c)

d3_c<-d3%>%
  select(id_paj)%>%
  st_filter(d9)%>%
  st_join(d9)%>%
  select(id_paj,id_nms,nms_name,nms_full_name)%>%
  mutate(ch_250m=1)%>%
  glimpse()
# plot(d3_c)

d4_c<-d4%>%
  select(id_pap)%>%
  st_filter(d9)%>%
  st_join(d9)%>%
  select(id_pap,id_nms,nms_name,nms_full_name)%>%
  mutate(ch_500m=1)%>%
  glimpse()
# plot(d4_c)

d5_c<-d5%>%
  select(id_ppk)%>%
  st_filter(d9)%>%
  st_join(d9)%>%
  select(id_ppk,id_nms,nms_name,nms_full_name)%>%
  mutate(ch_500m=1)%>%
  glimpse()
# plot(d5_c)

d6_c<-d6%>%
  select(id_paj)%>%
  st_filter(d9)%>%
  st_join(d9)%>%
  select(id_paj,id_nms,nms_name,nms_full_name)%>%
  mutate(ch_500m=1)%>%
  glimpse()
# plot(d6_c)




# -------------------------------------------------
# save all in one geopackage as layers---------------------------------

#mpas
st_write(d1_m,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","mpa_access_250m_buf",delete_layer=T)

st_write(d2_m,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","mpa_parking_250m_buf",delete_layer=T)

st_write(d3_m,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","mpa_jetties_250m_buf",delete_layer=T)

st_write(d4_m,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","mpa_access_500m_buf",delete_layer=T)

st_write(d5_m,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","mpa_parking_500m_buf",delete_layer=T)

st_write(d6_m,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","mpa_jetties_500m_buf",delete_layer=T)


#nms
st_write(d1_n,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","nms_access_250m_buf",delete_layer=T)

st_write(d2_n,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","nms_parking_250m_buf",delete_layer=T)

st_write(d3_n,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","nms_jetties_250m_buf",delete_layer=T)

st_write(d4_n,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","nms_access_500m_buf",delete_layer=T)

st_write(d5_n,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","nms_parking_500m_buf",delete_layer=T)

st_write(d6_n,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","nms_jetties_500m_buf",delete_layer=T)

#chumash
st_write(d1_c,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","ch_access_250m_buf",delete_layer=T)

st_write(d2_c,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","ch_parking_250m_buf",delete_layer=T)

st_write(d3_c,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","ch_jetties_250m_buf",delete_layer=T)

st_write(d4_c,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","ch_access_500m_buf",delete_layer=T)

st_write(d5_c,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","ch_parking_500m_buf",delete_layer=T)

st_write(d6_c,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","ch_jetties_500m_buf",delete_layer=T)
