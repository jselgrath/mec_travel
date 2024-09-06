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


# access points -------------------

# non-buffered ferries
d0<-(st_read("./gis/public_access_points_CA2/access_ca2.gpkg", layer = "ferries"))%>%
  glimpse()

d00<-d0%>%
  select(id_pap=id_ferry)%>%
  glimpse()


# checks layers in the gpkg
st_layers("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg")

# MPAs
d01<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "mpa_access_250m_buf"))%>%
  glimpse()

d02<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "mpa_parking_250m_buf"))%>%
  glimpse()

d03<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "mpa_jetties_250m_buf"))%>%
  glimpse()


d04<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "mpa_access_500m_buf"))%>%
  glimpse()

d05<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "mpa_parking_500m_buf"))%>%
  glimpse()

d06<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "mpa_jetties_500m_buf"))%>%
  glimpse()



# NMS --------------------------------------
d11<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "nms_access_250m_buf"))%>%
  glimpse()

d12<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "nms_parking_250m_buf"))%>%
  glimpse()

d13<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "nms_jetties_250m_buf"))%>%
  glimpse()

d14<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "nms_access_500m_buf"))%>%
  glimpse()

d15<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "nms_parking_500m_buf"))%>%
  glimpse()
d16<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "nms_jetties_500m_buf"))%>%
  glimpse()


# CHNMS ----------------------------------------------------
d21<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "ch_access_250m_buf"))%>%
  glimpse()

d22<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "ch_parking_250m_buf"))%>%
  glimpse()

d23<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "ch_jetties_250m_buf"))%>%
  glimpse()

d24<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "ch_access_500m_buf"))%>%
  glimpse()

d25<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "ch_parking_500m_buf"))%>%
  glimpse()
d26<-(st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg", layer = "ch_jetties_500m_buf"))%>%
  glimpse()




# points --------------------------------------------------
# load
d31<-(st_read("./gis/public_access_points_CA2/access_ca2.gpkg", layer = "beach_access_ca"))%>%
  glimpse()
d31

d32<-(st_read("./gis/public_access_points_CA2/access_ca2.gpkg", layer = "beach_parking_ca"))%>%
  glimpse()

d33<-(st_read("./gis/public_access_points_CA2/access_ca2.gpkg", layer = "piers_jetties"))%>%
  glimpse()


# join ---------------------------------------
# access, parking, jetty

# access points ----------
# mpa, 250
d01a<-d31%>%
  st_join(d01)%>% #access pt
  filter(id_pap.x==id_pap.y)%>%
  mutate(id_pap =id_pap.x)%>%
  select(-id_pap.x,-id_pap.y,-OBJECTID_1)%>%
  glimpse()
d01a
plot(d01a)

#mpa, 500
d04a<-d31%>%
  st_join(d04)%>% #access pt
  filter(id_pap.x==id_pap.y)%>%
  mutate(id_pap =id_pap.x)%>%
  select(-id_pap.x,-id_pap.y,-OBJECTID_1)%>%
  glimpse()

# nms, 250
d11a<-d31%>%
  st_join(d11)%>% #access pt
  filter(id_pap.x==id_pap.y)%>%
  mutate(id_pap =id_pap.x)%>%
  select(-id_pap.x,-id_pap.y,-OBJECTID_1)%>%
  glimpse()

#nms, 500
d14a<-d31%>%
  st_join(d14)%>% #access pt
  filter(id_pap.x==id_pap.y)%>%
  mutate(id_pap =id_pap.x)%>%
  select(-id_pap.x,-id_pap.y,-OBJECTID_1)%>%
  glimpse()

# ch, 250
d21a<-d31%>%
  # d21%>%
  st_join(d21)%>% #access pt
  filter(id_pap.x==id_pap.y)%>%
  mutate(id_pap =id_pap.x)%>%
  select(-id_pap.x,-id_pap.y,-OBJECTID_1)%>%
  glimpse()

#ch, 500
d24a<-d31%>%
  # d24%>%
  st_join(d24)%>% #access pt
  filter(id_pap.x==id_pap.y)%>%
  mutate(id_pap =id_pap.x)%>%
  select(-id_pap.x,-id_pap.y,-OBJECTID_1)%>%
  glimpse()


# parking points ----------

# mpa, 250
d02a<-d32%>%
  st_join(d02)%>% #parking pt
  filter(id_ppk.x==id_ppk.y)%>%
  mutate(id_ppk =id_ppk.x,)%>%
  select(-id_ppk.x,-id_ppk.y)%>%
  glimpse()

#mpa, 500
d05a<-d32%>%
  st_join(d05)%>% #parking pt
  filter(id_ppk.x==id_ppk.y)%>%
  mutate(id_ppk =id_ppk.x,)%>%
  select(-id_ppk.x,-id_ppk.y)%>%
  glimpse()

# nms, 250
d12a<-d32%>%
  st_join(d12)%>% #parking pt
  filter(id_ppk.x==id_ppk.y)%>%
  mutate(id_ppk =id_ppk.x,)%>%
  select(-id_ppk.x,-id_ppk.y)%>%
  glimpse()

#nms, 500
d15a<-d32%>%
  st_join(d15)%>% #parking pt
  filter(id_ppk.x==id_ppk.y)%>%
  mutate(id_ppk =id_ppk.x,)%>%
  select(-id_ppk.x,-id_ppk.y)%>%
  glimpse()

# ch, 250
d22a<-d32%>%
  st_join(d22)%>% #parking pt
  filter(id_ppk.x==id_ppk.y)%>%
  mutate(id_ppk =id_ppk.x,)%>%
  select(-id_ppk.x,-id_ppk.y)%>%
  glimpse()

#ch, 500
d25a<-d32%>%
  st_join(d25)%>% #parking pt
  filter(id_ppk.x==id_ppk.y)%>%
  mutate(id_ppk =id_ppk.x,)%>%
  select(-id_ppk.x,-id_ppk.y)%>%
  glimpse()




# jetties  points --------------------------------------
# mpa, 250
d03a<-d33%>%
  st_join(d03)%>% #jetties
  filter(id_paj.x==id_paj.y)%>%
  mutate(id_paj =id_paj.x,)%>%
  select(-id_paj.x,-id_paj.y)%>%
  glimpse()

#mpa, 500
d06a<-d33%>%
  st_join(d06)%>% #jetties
  filter(id_paj.x==id_paj.y)%>%
  mutate(id_paj =id_paj.x,)%>%
  select(-id_paj.x,-id_paj.y)%>%
  glimpse()

# nms, 250
d13a<-d33%>%
  st_join(d13)%>% #jetties
  filter(id_paj.x==id_paj.y)%>%
  mutate(id_paj =id_paj.x,)%>%
  select(-id_paj.x,-id_paj.y)%>%
  glimpse()

#nms, 500
d16a<-d33%>%
  st_join(d16)%>% #jetties
  filter(id_paj.x==id_paj.y)%>%
  mutate(id_paj =id_paj.x,)%>%
  select(-id_paj.x,-id_paj.y)%>%
  glimpse()

# ch, 250
d23a<-d33%>%
  st_join(d23)%>% #jetties
  filter(id_paj.x==id_paj.y)%>%
  mutate(id_paj =id_paj.x,)%>%
  select(-id_paj.x,-id_paj.y)%>%
  glimpse()

#ch, 500
d26a<-d33%>%
  st_join(d26)%>% #jetties
  filter(id_paj.x==id_paj.y)%>%
  mutate(id_paj =id_paj.x,)%>%
  select(-id_paj.x,-id_paj.y)%>%
  glimpse()

plot(d26a)
glimpse(d26a)
d26a



# join ferries to mpas and nms ---------------------------------
glimpse(d00)

# join mpa access points and ferries
d100<-d01a%>% # mpa 
  select(id_pap)%>%
  rbind(d00)%>% #access points with all 5 ferries
  glimpse()

plot(d100)
view(d100)

# d100%>%filter(mpa_250m!=1)

# join nms access points and ferries (no chnms) -------------

# select ferries to NMS only
d000<-d00%>%
  filter(id_pap=="ferry_3" |id_pap=="ferry_4"  )%>%
  glimpse()

d101<-d11a%>% # mpa 
  select(id_pap)%>%
  rbind(d000)%>% #access points with all 5 ferries
  glimpse()

plot(d101)
view(d101)


# save all in one geopackage as layers---------------------------------
# note:I should check this output

#mpas
st_write(d01a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg","mpa_access_250m_pt",delete_layer=T)

st_write(d02a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg","mpa_parking_250m_pt",delete_layer=T)

st_write(d03a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg","mpa_jetties_250m_pt",delete_layer=T)

st_write(d04a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_500m.gpkg","mpa_access_500m_pt",delete_layer=T)

st_write(d05a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_500m.gpkg","mpa_parking_500m_pt",delete_layer=T)

st_write(d06a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_500m.gpkg","mpa_jetties_500m_pt",delete_layer=T)


#nms
st_write(d11a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg","nms_access_250m_pt",delete_layer=T)

st_write(d12a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg","nms_parking_250m_pt",delete_layer=T)

st_write(d13a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg","nms_jetties_250m_pt",delete_layer=T)

st_write(d14a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_500m.gpkg","nms_access_500m_pt",delete_layer=T)

st_write(d15a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_500m.gpkg","nms_parking_500m_pt",delete_layer=T)

st_write(d16a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_500m.gpkg","nms_jetties_500m_pt",delete_layer=T)

#chumash
st_write(d21a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg","ch_access_250m_pt",delete_layer=T)

st_write(d22a,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg","ch_parking_250m_pt",delete_layer=T)

st_write(d23,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg","ch_jetties_250m_pt",delete_layer=T)

st_write(d24,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_500m.gpkg","ch_access_500m_pt",delete_layer=T)

st_write(d25,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_500m.gpkg","ch_parking_500m_pt",delete_layer=T)

st_write(d26,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_500m.gpkg","ch_jetties_500m_pt",delete_layer=T)



# mpas and nms with ferries
st_write(d100,"./gis/public_access_points_CA2_buf/access_buf_mpa_nms_ferry.gpkg","mpa_access_250m_buf_ferries",delete_layer=T)