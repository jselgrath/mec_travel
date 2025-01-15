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

plot(d0)
# says Rodeo beach is in MBNMS but it is in Farallones I think - check this. I checked maps and they look correct

d1<-read_csv("./results/all_access_zipcode_driving2.csv")%>%  glimpse() #cleaned version of file
d1a<-read_csv("./doc/all_access_zipcode_state_sum.csv")%>%  glimpse()
d1b<-read_csv("./results/all_access_zipcode_pap_all.csv")%>%  
  # left_join(d0)%>%
  glimpse()
d1c<-read_csv("./doc/all_access_zipcode_pap_sum.csv")%>%  glimpse()


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

# time given distance - state
# add line and CI
ggplot(d1,aes(Total_Kilometers,Total_TravelTime))+geom_point()+
  xlab("Travel Distance (km)")+
  ylab("Travel Time (minutes)")+
  geom_smooth(method=lm, se=TRUE,alpha=0.5) + #.95 CI by default
  deets9
ggsave("./doc/state_time_km_nms.tiff",width=8,height=4)

# time given distance - pap
subset(d1b, time_min_u>80)%>%
  select(pap,access_name)

ggplot(d1b,aes(dist_km_u,time_min_u))+geom_point()+
  xlab("Mean Travel Distance (km)")+
  ylab("Mean Travel Time (minutes)")+
  geom_text_repel(aes(x=dist_km_u,y=time_min_u,label=access_name),max.overlaps=45,, vjust = "inward")+
  geom_smooth(method=lm ,  se=TRUE,alpha=0.5) + #.95 CI by
  scale_y_continuous(limits=c(-5,255))+
  scale_x_continuous(limits=c(-20,360))+
  deets9
ggsave("./doc/time_km_nms.tiff",width=8,height=4)

# label by nms
ggplot(d1b,aes(zip_codes_n))+geom_bar(width = 1)+
  # geom_text_repel(data=subset(d1b, zip_codes_n>=100),
  #                 aes(x=zip_codes_n,y=50,label=nms_name),max.overlaps=15)+
  geom_text_repel(data=subset(d1b, zip_codes_n>=100),
                  aes(x=zip_codes_n,y=50,label=nms_name),max.overlaps=15, vjust = "inward")+
  xlab("Number of Zip Codes Closest to One NMS Access Point")+
  ylab("Number of Access Points")+
  deets9
ggsave("./doc/zip_count_name_nms.tiff",width=8,height=4)

# label by county
ggplot(d1b,aes(x=zip_codes_n))+geom_bar()+
  geom_text_repel(aes(label=access_county,y=0), vjust = "inward")+
  xlab("Number of Zip Codes Closest to One Sanctuary Access Point")+
  ylab("Number of Access Points")+
  deets9
ggsave("./doc/zip_count_county_nms.tiff",width=8,height=4)

# no label ------------------
# add grouping for color
d1c<-d1b%>%
  mutate(clr=as.factor(if_else(zip_codes_n>=50&zip_codes_n<100,1,
             if_else(zip_codes_n>=100,2,0))))%>%
  glimpse()

# colors
cols<- c("LightGray","#BCE5DF","#0FCFC0")

ggplot(d1c,aes(zip_codes_n, color=cols))+geom_bar(width = 1)+
  xlab("Number of Zip Codes Served by the Sanctuary Access Point")+
  ylab("Number of Access Points")+
  scale_color_manual(values=cols)+
  deets11
ggsave("./doc/zip_countno_label_nms.tiff",width=8,height=4)
