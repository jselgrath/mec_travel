# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: graph summaries of network analysis results, starting with all coastal access points

# guide to acronyms ----

## *** SHOULD I SUMMARIZE BY MPA NOT ACCESS POINT??? ****
#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate); library (leaflet);library(ggrepel);  library(colorspace) 


#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel/")
# setwd("C:/Users/jselg/OneDrive/Documents/research/R_projects/mec_travel")


# ZIP CODES ##### ----------------------

# MPAs  ------------------------
# d0<-st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg", layer ="mpa_access_250m_pt")%>%

d0<-st_read("./gis/public_access_points_CA2_buf/access_buf_mpa_nms_ferry.gpkg", layer="mpa_access_250m_buf_ferries")%>%#mpa_access_250m_buf_ferries
  mutate(pap=id_pap)%>%
  # select(pap,mpa_name,access_county,id_mpa,mpa_name,mpa_name_short,mpa_name_full,mpa_ha)%>%
  glimpse()

d1<-read_csv("./results/mpa_zipcode_driving2.csv")%>%  glimpse() #cleaned version of file
d1a<-read_csv("./doc/mpa_zipcode_state_sum.csv")%>%  glimpse()
d1b<-read_csv("./results/mpa_zipcode_pap_all.csv")%>%  
  # left_join(d0)%>%
  glimpse()
d1c<-read_csv("./doc/mpa_zipcode_pap_sum.csv")%>%  glimpse()

# model -------------------
m1<-lm(Total_TravelTime~Total_Kilometers,data=d1)
m1
anova(m1)


# graph -----------------------------------
source("./bin/deets.R")

# colors
cols<- c("LightGray","#879FDB","#002F70")

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
ggsave("./doc/state_time_km_mpa.tiff",width=8,height=4)

# time given distance - pap
ggplot(d1b,aes(dist_km_u,time_min_u))+geom_point()+
  xlab("Mean Travel Distance (km)")+
  ylab("Mean Travel Time (minutes)")+
  geom_smooth(method=lm ,  se=TRUE,alpha=0.5) + #.95 CI by
  geom_text_repel(data=subset(d1b, time_min_u>60&time_min_u<150&dist_km_u<100),
                  aes(x=dist_km_u,y=time_min_u,label=mpa_name),max.overlaps=15)+
  deets9
ggsave("./doc/time_km_mpa.tiff",width=8,height=4)

# label by pap
ggplot(d1c,aes(zip_codes_n, fill=clr))+geom_bar(width = 1)+
  geom_text_repel(data=subset(d1c, clr==2),
                  aes(x=zip_codes_n,y=2,label=mpa_name),max.overlaps=15)+
  xlab("Number of Zip Codes Closest to One MPA")+
  ylab("Number of Access Points")+
  scale_fill_manual(values=cols)+
  deets9
ggsave("./doc/zip_count_name_mpa.tiff",width=8,height=4)

d1b%>%filter(zip_codes_n>100) # no label for Ferry 1, Laguna and Montara

# label by county
ggplot(d1c,aes(zip_codes_n, fill=clr))+geom_bar(width = 1)+
  geom_text_repel(data=subset(d1c, clr==2),
                  aes(x=zip_codes_n,y=2,label=access_county),max.overlaps=15)+
  xlab("Number of Zip Codes Closest to One MPA")+
  ylab("Number of Access Points")+
  scale_fill_manual(values=cols)+
  deets9
ggsave("./doc/zip_count_county_mpa.tiff",width=8,height=4)

# no label  -------------------
ggplot(d1c,aes(zip_codes_n, fill=clr))+geom_bar(width = 1)+
  xlab("Number of Zip Codes Served by MPA Access Points")+
  ylab("Number of Access Points")+
  scale_fill_manual(values=cols)+
  deets11
ggsave("./doc/zip_countno_label_mpa.tiff",width=8,height=4)
