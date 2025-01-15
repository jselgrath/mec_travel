# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: summarize network analysis results, starting with all coastal access points


# guide to acronyms ----
# PAP = public access point - same as coastal access point (CAP)
# PAJ - piers and jetties

# NOTE: pepper point did not calculate any data for time (other sites are ok)
#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate); library (leaflet)# 

#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel/")
# setwd("C:/Users/jselg/OneDrive/Documents/research/R_projects/mec_travel")


# Piers ---------------------------
d1<-read_csv("./results/network_analysis_piers_jetties_FINAL.csv") %>%
  glimpse()

# d1<-read_csv("./data/network_analyses_20240503/zipcode/piers_jetties_zip_code_driving_routes_attribute_table.csv")%>%  #note: this analysis not updated in sept 2024 because no change in access points
#   select(XCoord,YCoord,Name,StartTime ,EndTime, Total_TravelTime=Total_Trav,Total_Kilometers=Total_Kilo)%>%
#   separate_wider_delim(Name,names=c("zip_code","pier")," - ")%>%
#   mutate(zip_code=as.numeric(zip_code))%>%#separate origion and destination
#   mutate(Total_TravelTime=as.numeric(Total_TravelTime),
#          StartTime=as_datetime(StartTime),
#          EndTime=as_datetime(EndTime))%>%
#   glimpse()

d1$zip_code
d1$Total_TravelTime

# summarize for whole state
d1a<-d1%>%
  summarize(
    n=n(),
    zip_codes_n=length(unique(zip_code)),
    access_point_n=length(unique(pier)),
    
    #time
    time_min_u=mean(Total_TravelTime, na.rm=T),
    time_min_sd=sd(Total_TravelTime, na.rm=T),
    time_min_sem=time_min_sd/sqrt(n),
    time_min_low=min(Total_TravelTime, na.rm=T),
    time_min_max=max(Total_TravelTime, na.rm=T),
    
    #distance
    dist_km_u=mean(Total_Kilometers),
    dist_km_sd=sd(Total_Kilometers),
    dist_km_sem=dist_km_sd/sqrt(n),
    dist_km_low=min(Total_Kilometers),
    dist_km_max=max(Total_Kilometers)
  )%>%
  glimpse()

d1a$type<-"pier"
d1a

# summarize by pier   --------------------------
# pepper point did not calculate any data for time (other sites are ok)
d1b<-d1%>%
  group_by(pier)%>%
  summarize(
    zip_codes_n=length(zip_code),

    #time
    time_min_u=mean(Total_TravelTime, na.rm=T),
    time_min_sd=sd(Total_TravelTime, na.rm=T),
    # time_min_sem=time_min_sd/sqrt(n),na.rm=T,
    time_min_low=min(Total_TravelTime, na.rm=T),
    time_min_max=max(Total_TravelTime, na.rm=T),
    
    #distance
    dist_km_u=mean(Total_Kilometers),
    dist_km_sd=sd(Total_Kilometers),
    # dist_km_sem=dist_km_sd/sqrt(n),na.rm=T,
    dist_km_low=min(Total_Kilometers),
    dist_km_max=max(Total_Kilometers)
  )%>%

  ungroup()%>%
  glimpse()

d1b$type<-"pier"
d1b

# summary statistics for all piers ---------------------------
# here, not using grand means but could for a slightly different question
d1c<-d1b%>%
  summarize(
    access_point_n=n(),
    zip_codes_n2=sum(zip_codes_n),
    pap_zip_u=mean(zip_codes_n, na.rm=T),
    pap_zip_sd=sd(zip_codes_n, na.rm=T),
    pap_zip_sem=sd(zip_codes_n)/sqrt(access_point_n),
    pap_zip_min=min(zip_codes_n, na.rm=T),
    pap_zip_max=max(zip_codes_n, na.rm=T),
    pap_zip_1_n=length(zip_codes_n[zip_codes_n==1]),
    pap_zip_1_p=pap_zip_1_n/access_point_n,
    

    #time
    time_min_pap_u=mean(time_min_u, na.rm=T),
    time_min_pap_sd=sd(time_min_u, na.rm=T),
    time_min_pap_sem=time_min_pap_sd/sqrt(access_point_n),
    time_min_pap_low=min(time_min_u, na.rm=T),
    time_min_pap_max=max(time_min_u, na.rm=T),
    
    #distance
    dist_km_pap_u=mean(dist_km_u),
    dist_km_pap_sd=sd(dist_km_u),
    dist_km_pap_sem=dist_km_pap_sd/sqrt(access_point_n),
    dist_km_pap_low=min(dist_km_u),
    dist_km_pap_max=max(dist_km_u)
  )%>%
  glimpse()

d1c$type<-"pier"
d1c

# save -------------------
write_csv(d1,"./results/piers_zipcode_driving2.csv") #cleaned version of file
write_csv(d1a,"./doc/piers_zipcode_state_sum.csv")
write_csv(d1b,"./results/piers_zipcode_pap_all.csv")
write_csv(d1c,"./doc/piers_zipcode_pap_sum.csv")