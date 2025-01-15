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
# setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel/")

setwd("C:/Users/jselg/OneDrive/Documents/research/R_projects/mec_travel")
source("./bin/deets.R")

# ZIP CODES ##### ----------------------

# All Access ------------------------
d0<-read_csv("./results/public_access_points.csv")%>%
  mutate(pap=id_pap)%>%
  # select(pap,access_name,access_county)%>%
  glimpse()
d1<-read_csv("./results/all_access_zipcode_driving2.csv")%>%  glimpse() #cleaned version of file
d1a<-read_csv("./doc/all_access_zipcode_state_sum.csv")%>%  glimpse()
d1b<-read_csv("./results/all_access_zipcode_pap_all.csv")%>%  
  left_join(d0)%>%
  glimpse()
d1c<-read_csv("./doc/all_access_zipcode_pap_sum.csv")%>%  glimpse()

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
ggsave("./doc/state_time_km_pap.tiff",width=8,height=4)

# time given distance - pap
ggplot(d1b,aes(dist_km_u,time_min_u))+geom_point()+
  xlab("Mean Travel Distance (km)")+
  ylab("Mean Travel Time (minutes)")+
  geom_smooth(method=lm ,  se=TRUE,alpha=0.5) + #.95 CI by
  geom_text_repel(data=subset(d1b, time_min_u>60&time_min_u<150&dist_km_u<100),
                  aes(x=dist_km_u,y=time_min_u,label=access_name),max.overlaps=15)+
  deets9
ggsave("./doc/time_km_pap.tiff",width=8,height=4)

# label by pap
ggplot(d1b,aes(zip_codes_n))+geom_bar()+
  geom_text_repel(data=subset(d1b, zip_codes_n>=100),
                  aes(x=zip_codes_n,y=0,label=access_name))+
  xlab("Number of Zip Codes Closest to One Access Point")+
  ylab("Number of Access Points")+
  deets9
ggsave("./doc/zip_count_name_pap.tiff",width=8,height=4)

# label by county
ggplot(d1b,aes(zip_codes_n))+geom_bar()+
  geom_text_repel(data=subset(d1b, zip_codes_n>=100),
                  aes(x=zip_codes_n,y=0,label=access_county))+
  xlab("Number of Zip Codes Closest to One Access Point")+
  ylab("Number of Access Points")+
  deets9
ggsave("./doc/zip_count_county_pap.tiff",width=8,height=4)

# no label 

# add grouping for color
d1c<-d1b%>%
  mutate(clr=as.factor(if_else(zip_codes_n>=50&zip_codes_n<100,1,
                       if_else(zip_codes_n>=100,2,0))))%>%
  glimpse()

# colors
cols<- c("LightGray","#D41159","#5F1415")

ggplot(d1c,aes(zip_codes_n, color=clr))+geom_bar(width = 1)+
  xlab("Number of Zip Codes Served by the Access Point")+
  ylab("Number of Access Points")+
  scale_color_manual(values=cols)+
  deets11
ggsave("./doc/zip_countno_label_pap.tiff",width=8,height=4)
