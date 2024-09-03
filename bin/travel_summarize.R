# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: summarize network analysis results, starting with all coastal access points


# guide to acronyms ----
# PAP = public access point - same as coastal access point (CAP)

#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate); library (leaflet)# 


#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel/")

# ZIP CODES ##### ----------------------

# All Access ------------------------
d1<-read_csv("./data/network_analyses_20240503/zipcode/all_access_zipcode_driving.txt")%>%
  select(XCoord,YCoord,Name,StartTime ,EndTime, Total_TravelTime,Total_Kilometers)%>%
  separate_wider_delim(Name,names=c("zip_code","pap")," - ")%>% #separate origion and destination
  glimpse()

# summariZe for whole state
d1a<-d1%>%
  summarize(
    n=n(),
    zip_codes_n=length(unique(zip_code)),
    pap_n=length(unique(pap)),
    
    #time
    time_min_u=mean(Total_TravelTime),
    time_min_sd=sd(Total_TravelTime),
    time_min_sem=time_min_sd/sqrt(n),
    time_min_low=min(Total_TravelTime),
    time_min_max=max(Total_TravelTime),
    
    #distance
    dist_km_u=mean(Total_Kilometers),
    dist_km_sd=sd(Total_Kilometers),
    dist_km_sem=dist_km_sd/sqrt(n),
    dist_km_low=min(Total_Kilometers),
    dist_km_max=max(Total_Kilometers)
  )%>%
  glimpse()

# summarize by pap   --------------------------
d1b<-d1%>%
  group_by(pap)%>%
  summarize(
    zip_codes_n=length(zip_code),

    #time
    time_min_u=mean(Total_TravelTime),
    time_min_sd=sd(Total_TravelTime),
    # time_min_sem=time_min_sd/sqrt(n),na.rm=T,
    time_min_low=min(Total_TravelTime),
    time_min_max=max(Total_TravelTime),
    
    #distance
    dist_km_u=mean(Total_Kilometers),
    dist_km_sd=sd(Total_Kilometers),
    # dist_km_sem=dist_km_sd/sqrt(n),na.rm=T,
    dist_km_low=min(Total_Kilometers),
    dist_km_max=max(Total_Kilometers)
  )%>%

  ungroup()%>%
  glimpse()

# summary statistics for all paps ---------------------------
# here, not using grand means but could for a slightly different question
d1c<-d1b%>%
  summarize(
    pap_n=n(),
    pap_zip_u=mean(zip_codes_n),
    pap_zip_sd=sd(zip_codes_n),
    pap_zip_sem=sd(zip_codes_n)/sqrt(pap_n),
    pap_zip_min=min(zip_codes_n),
    pap_zip_max=max(zip_codes_n),
    pap_zip_1_n=length(zip_codes_n[zip_codes_n==1]),
    pap_zip_1_p=pap_zip_1_n/pap_n,
    

    #time
    time_min_pap_u=mean(time_min_u),
    time_min_pap_sd=sd(time_min_u),
    time_min_pap_sem=time_min_pap_sd/sqrt(pap_n),
    time_min_pap_low=min(time_min_u),
    time_min_pap_max=max(time_min_u),
    
    #distance
    dist_km_pap_u=mean(dist_km_u),
    dist_km_pap_sd=sd(dist_km_u),
    dist_km_pap_sem=dist_km_pap_sd/sqrt(pap_n),
    dist_km_pap_low=min(dist_km_u),
    dist_km_pap_max=max(dist_km_u)
  )%>%
  glimpse()

# save -------------------
write_csv(d1,"./results/all_access_zipcode_driving2.csv") #cleaned version of file
write_csv(d1a,"./doc/all_access_zipcode_state_sum.csv")
write_csv(d1b,"./results/all_access_zipcode_pap_all.csv")
write_csv(d1c,"./doc/all_access_zipcode_pap_sum.csv")