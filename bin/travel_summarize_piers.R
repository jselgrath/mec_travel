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

# ZIP CODES ##### ----------------------

# All Access ------------------------
d1<-read_csv("./data/network_analyses_20240503/zipcode/piers_jetties_zip_code_driving_routes_attribute_table.csv")%>%
  select(XCoord,YCoord,Name,StartTime ,EndTime, Total_TravelTime=Total_Trav,Total_Kilometers=Total_Kilo)%>%
  separate_wider_delim(Name,names=c("zip_code","pier")," - ")%>%
  mutate(zip_code=as.numeric(zip_code))%>%#separate origion and destination
  mutate(Total_TravelTime=as.numeric(Total_TravelTime),
         StartTime=as_datetime(StartTime),
         EndTime=as_datetime(EndTime))%>%
  glimpse()

d1$zip_code
d1$Total_TravelTime

# summarize for whole state
d1a<-d1%>%
  summarize(
    n=n(),
    zip_codes_n=length(unique(zip_code)),
    pier_n=length(unique(pier)),
    
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

# summary statistics for all piers ---------------------------
# here, not using grand means but could for a slightly different question
d1c<-d1b%>%
  summarize(
    pier_n=n(),
    pier_zip_u=mean(zip_codes_n, na.rm=T),
    pier_zip_sd=sd(zip_codes_n, na.rm=T),
    pier_zip_sem=sd(zip_codes_n)/sqrt(pier_n),
    pier_zip_min=min(zip_codes_n, na.rm=T),
    pier_zip_max=max(zip_codes_n, na.rm=T),
    pier_zip_1_n=length(zip_codes_n[zip_codes_n==1]),
    pier_zip_1_p=pier_zip_1_n/pier_n,
    

    #time
    time_min_pier_u=mean(time_min_u, na.rm=T),
    time_min_pier_sd=sd(time_min_u, na.rm=T),
    time_min_pier_sem=time_min_pier_sd/sqrt(pier_n),
    time_min_pier_low=min(time_min_u, na.rm=T),
    time_min_pier_max=max(time_min_u, na.rm=T),
    
    #distance
    dist_km_pier_u=mean(dist_km_u),
    dist_km_pier_sd=sd(dist_km_u),
    dist_km_pier_sem=dist_km_pier_sd/sqrt(pier_n),
    dist_km_pier_low=min(dist_km_u),
    dist_km_pier_max=max(dist_km_u)
  )%>%
  glimpse()

# save -------------------
write_csv(d1,"./results/piers_zipcode_driving2.csv") #cleaned version of file
write_csv(d1a,"./doc/piers_zipcode_state_sum.csv")
write_csv(d1b,"./results/piers_zipcode_pap_all.csv")
write_csv(d1c,"./doc/piers_zipcode_pap_sum.csv")