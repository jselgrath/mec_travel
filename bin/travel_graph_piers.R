# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: graph summaries of network analysis results, starting with all coastal access points

# guide to acronyms ----
# PAP = public access point - same as coastal access point (CAP)
# PAJ - piers and jetties
#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate); library (leaflet);library(ggrepel);  


#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel/")
source("./bin/deets.R")

# ZIP CODES ##### ----------------------

# Piers and Jetties ------------------------
d0<-read_csv("./results/piers.csv")%>%
  mutate(pap=id_paj)%>% 
  select(pap,pier,pier_county)%>%  # pier_notes
  glimpse()

d1<-read_csv("./results/piers_zipcode_driving2.csv")%>%  glimpse() #cleaned version of file
d1a<-read_csv("./doc/piers_zipcode_state_sum.csv")%>%  glimpse()
d1b<-read_csv("./results/piers_zipcode_pap_all.csv")%>%  
  left_join(d0)%>%
  glimpse()
d1c<-read_csv("./doc/piers_zipcode_pap_sum.csv")%>%  glimpse()

# model -------------------
m1<-lm(Total_TravelTime~Total_Kilometers,data=d1)
m1
anova(m1)



# graph -----------------------------------
source("./bin/deets.R")

# time given distance - state
# add line and CI
ggplot(d1,aes(Total_Kilometers,Total_TravelTime))+geom_point()+
  xlab("Travel Distance (km)")+
  ylab("Travel Time (minutes)")+
  xlim(-1,500)+
  ylim(-1,400)+
  geom_smooth(se=TRUE,alpha=0.8) + #.95 CI by default method=lm, 
  deets11
ggsave("./doc/pier_state_time_km.png",width=8,height=4)

# time given distance - pap
ggplot(d1b,aes(dist_km_u,time_min_u))+geom_point()+
  xlab("Mean Travel Distance (km)")+
  ylab("Mean Travel Time (minutes)")+
  geom_smooth(se=TRUE,alpha=0.5) + #.95 CI by method=lm ,  
  geom_text_repel(data=subset(d1b, time_min_u>100&dist_km_u>100),
                  aes(x=dist_km_u,y=time_min_u,label=pier),max.overlaps=15)+
  deets11
ggsave("./doc/pier_time_km.png",width=8,height=4)

# label by pap
ggplot(d1b,aes(zip_codes_n))+geom_bar()+
  geom_text_repel(data=subset(d1b, zip_codes_n>=100),
                  aes(x=zip_codes_n,y=1,label=pier))+
  xlab("Number of Zip Codes Served by one Pier/Jetty")+
  ylab("Count")+
  deets11
ggsave("./doc/pier_zip_count_name.png",width=8,height=4)

d1b%>%
  filter(zip_codes_n>=100)%>%
  select(pier)



# label by county
ggplot(d1b,aes(zip_codes_n))+geom_bar()+
  geom_text_repel(data=subset(d1b, zip_codes_n>=100),
                  aes(x=zip_codes_n,y=2.5,label=pier_county))+
  xlab("Number of Zip Codes Served by one Pier/Jetty")+
  ylab("Count")+
  deets11
ggsave("./doc/pier_zip_count_county.png",width=8,height=4)

# no label 
ggplot(d1b,aes(zip_codes_n))+geom_bar(width = 2)+
  # geom_bar(data=subset(d1b, zip_codes_n<=100),aes(zip_codes_n))+
  geom_bar(data=subset(d1b, zip_codes_n>=100),aes(zip_codes_n,fill="#D41159"),width = 2.5)+
  xlab("Number of Zip Codes Served by one Pier/Jetty")+
  ylab("Count")+
  deets11
ggsave("./doc/piers_zip_countno_label.png",width=8,height=4)
