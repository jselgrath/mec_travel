# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: graph summaries of network analysis results, starting with all coastal access points

# guide to acronyms ----
# PAP = public access point - same as coastal access point (CAP)

#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate); library (leaflet);library(ggrepel); library(colorspace) 


#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel/")
# setwd("C:/Users/jselg/OneDrive/Documents/research/R_projects/mec_travel")
source("./bin/deets.R")

# ZIP CODES ##### ----------------------

# NMS  ------------------------
# d0<-st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg", layer ="nms_access_250m_pt")%>%
d0<-st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms_ferry.gpkg", layer ="nms_access_250m_buf_ferries")%>%
  mutate(pap=id_pap)%>%
  # select(pap,access_name,access_county,id_nms,nms_full_name)%>%
  glimpse()

head(d0)
plot(d0)
# says Rodeo beach is in MBNMS but it is in Farallones I think - check this. I checked maps and they look correct

d1<-read_csv("./results/nms_zipcode_driving2.csv")%>%  #glimpse() #cleaned version of file
  left_join(d0)%>%
  glimpse()
d1a<-read_csv("./doc/nms_zipcode_state_sum.csv")%>%  glimpse()
d1b<-read_csv("./results/nms_zipcode_pap_all.csv")%>%  
  left_join(d0)%>%
  glimpse()
# d1d<-read_csv("./doc/nms_zipcode_pap_sum.csv")%>%  glimpse()



# spatial file for ArcPro Map
# d00<-d0%>%
#   left_join(d1)%>%
#   glimpse()
# st_write(d00,"./doc/travel_time_nms_origion.gpkg")

d01<-d0%>%
  left_join(d1b)%>%
  # st_collection_extract("POINT")%>%
  glimpse()
st_write(d00,"./doc/travel_time_nms_destination.gpkg", delete_layer = TRUE)
write_sf(d00,"./doc/travel_time_nms_destination.shp", delete_layer = TRUE)

subset(d1b, time_min_u>30)%>%
  select(pap,access_name,time_min_u)%>%
  # left_join(d0)%>%
  glimpse()%>%
  view()

subset(d1b, time_min_u>40)%>%
  select(pap,access_name)%>%
  left_join(d0)%>%
  select(pap)%>%
  glimpse()


subset(d0, time_min_u>80)%>%
  select(pap,access_name)




# model -------------------
m1<-lm(Total_TravelTime~Total_Kilometers,data=d1)
m1
anova(m1)



# graph -----------------------------------
source("./bin/deets.R")

# colors
cols<- c("LightGray","#BCE5DF","#0FCFC0")

# add grouping for color
d1c<-d1b%>%
  mutate(clr=as.factor(if_else(zip_codes_n>=50&zip_codes_n<100,1,
                               if_else(zip_codes_n>=100,2,0))))%>%
  glimpse()


# time given distance - state
# add line and CI
ggplot(d1,aes(Total_Kilometers,Total_TravelTime))+geom_point()+
  xlab("Travel Distance (km)")+
  ylab("Travel Time (minutes)")+
  geom_smooth(method=lm, se=TRUE,alpha=0.5) + #.95 CI by default
  deets9
ggsave("./doc/state_time_km_nms.tiff",width=8,height=4)

# time given distance - pap
ggplot(d1b,aes(dist_km_u,time_min_u))+geom_point()+
  xlab("Mean Travel Distance (km)")+
  ylab("Mean Travel Time (minutes)")+
  geom_smooth(method=lm ,  se=TRUE,alpha=0.5) + #.95 CI by
  geom_text_repel(data=subset(d1b, time_min_u>70&time_min_u<150&dist_km_u<110),
                  aes(x=dist_km_u,y=time_min_u,label=nms_name),max.overlaps=15, vjust = "inward")+
  deets9
ggsave("./doc/time_km_nms.tiff",width=8,height=4)

# label by nms
ggplot(d1c,aes(zip_codes_n, fill=clr))+geom_bar(width = 2)+
  scale_fill_manual(values=cols)+
  geom_text_repel(data=subset(d1c, clr==2),
                  aes(x=zip_codes_n,y=2,label=nms_name),max.overlaps=15)+
  xlab("Number of Zip Codes Closest to One Sanctuary")+
  ylab("Number of Access Points")+

  deets11
ggsave("./doc/zip_count_name_nms.tiff",width=8,height=4)

d1b%>%filter(zip_codes_n>100) # missing ones - need to fix

# label by county
ggplot(d1c,aes(zip_codes_n, fill=clr))+geom_bar(width = 2)+
  geom_text_repel(data=subset(d1c, clr==2),
                  aes(x=zip_codes_n,y=2,label=access_county),max.overlaps=15)+
  xlab("Number of Zip Codes Closest to One Sanctuary")+
  ylab("Number of Access Points")+
  scale_fill_manual(values=cols)+
  deets9
ggsave("./doc/zip_count_county_nms.tiff",width=8,height=4)

# no label ------------------
ggplot(d1c,aes(zip_codes_n, fill=clr))+geom_bar(width = 2)+
  xlab("Number of Zip Codes Served by Sanctuary Access Points")+
  ylab("Number of Access Points")+
  scale_fill_manual(values=cols)+
  deets11
ggsave("./doc/zip_countno_label_nms.tiff",width=8,height=4)
