# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: create csuci ID for beach/ocean public access points

# guide to acronyms ----
# MPA = state MPA network (CA)
# updated 20240905 to final prefered alternative boundary for CHNMS
#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate)# 
library(sp); 

#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel")


# access points -------------------

# load MPAs
d1<-(st_read("./gis/California_Marine_Protected_Areas_[ds582]/California_Marine_Protected_Areas_[ds582].shp"))%>%
  select(-Shape__Are,-Shape__Len,-OBJECTID)%>%
  mutate(id_mpa=paste0("mpa_",row_number()))%>%
  st_transform(4326)

d1%>%glimpse()%>% plot()
plot(d1[,2])

length(unique(d1$CCR_Int)) #147
length(unique(d1$NAME)) #155





# load sanctuaries -------------
d2<-(st_read("./gis/NMS_west_coast/National_Marine_Sanctuaries_WestCoast.shp"))%>%
  filter(SANCTUARY!="OCNMS")%>%
  mutate(id_nms=paste0("nms_",row_number()))%>%
  select(id_nms,nms_name=SANCTUARY,nms_full_name=FullName,geometry)%>%
  glimpse()

d2%>%glimpse()%>% plot()
plot(d2[,2])




# load proposed sanctuary ----------------------

# original files moved to different sub folder

# initial proposal
# d3<-st_read("./gis/Chumash_proposed_shapefile/Chumash_proposed_shapefile.shp")%>%
#   mutate(SANCTUARY="CHNMS",FullName="Chumash Heritage National Marine Sanctuary",id_nms="nms_5")%>%
#   select(id_nms,nms_name=SANCTUARY,nms_full_name=FullName,geometry)%>%
#   glimpse()
# 
# d3%>%glimpse()%>% plot()
# plot(d3[,2])
# 
# 
# # agency alternative
# d4<-st_read("./gis/ChumashHeritage_AgencySelectAlt_12012022/Chumash_AgencySelectAlternative_12012022.shp")%>%
#   mutate(SANCTUARY="CHNMS",FullName="Chumash Heritage National Marine Sanctuary",id_nms="nms_5")%>%
#   select(id_nms,nms_name=SANCTUARY,nms_full_name=FullName,geometry)%>%
#   st_transform(4326)%>%
#   glimpse()

# final proposed boundary of chnms (20240906)
# initial proposal
d44<-st_read("./gis/CHNMS_FinalPreferredAlternative/CHNMS_FPA_05142024.shp")%>%
  mutate(SANCTUARY="CHNMS",FullName="Chumash Heritage National Marine Sanctuary",id_nms="nms_5")%>%
  select(id_nms,nms_name=SANCTUARY,nms_full_name=FullName,geometry)%>%
  st_transform(4326)%>%
  glimpse()

d44%>%glimpse()%>% plot()
plot(d44[,2])


# join with chnms1
# d6<-d2%>%
#   rbind(d3)%>%
#   glimpse()
# plot(d6)
# 
# # join with chnms2
# d7<-d2%>%
#   rbind(d4)%>%
#   glimpse()
# plot(d7)

# join with chnms final
d8<-d2%>%
  rbind(d44)%>%
  glimpse()
plot(d8)

# save -----------------
#all in one geopackage as layers
st_write(d1,"./gis/mpa_nms_all/mpa_nms_all.gpkg","mpa_ca",delete_layer=T)
st_write(d2,"./gis/mpa_nms_all/mpa_nms_all.gpkg","nms_ca", delete_layer=T)
# st_write(d3,"./gis/mpa_nms_all/mpa_nms_all.gpkg","chnms_1", delete_layer=T)
# st_write(d4,"./gis/mpa_nms_all/mpa_nms_all.gpkg","chnms_alt", delete_layer=T)
st_write(d44,"./gis/mpa_nms_all/mpa_nms_all.gpkg","chnms_final", delete_layer=T)


# old boundaries
# st_write(d6,"./gis/mpa_nms_all/mpa_nms_all.gpkg","nms_chnms_1", delete_layer=T) # NMS plus chumash proposed boundary
# st_write(d7,"./gis/mpa_nms_all/mpa_nms_all.gpkg","nms_chnms_alt", delete_layer=T) # NMS plus agency alternative boundary

st_write(d8,"./gis/mpa_nms_all/mpa_nms_all.gpkg","nms_chnms_final", delete_layer=T) # NMS plus chumash proposed boundary

plot(d8)
