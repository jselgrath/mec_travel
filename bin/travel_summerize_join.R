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

d1<-read_csv("./doc/all_access_zipcode_state_sum.csv")%>%glimpse()
d2<-read_csv("./doc/all_access_zipcode_pap_sum.csv")%>%glimpse()

d3<-read_csv("./doc/mpa_zipcode_state_sum.csv")%>%glimpse()
d4<-read_csv("./doc/mpa_zipcode_pap_sum.csv")%>%glimpse()

d5<-read_csv("./doc/nms_zipcode_state_sum.csv")%>%glimpse()
d6<-read_csv("./doc/nms_zipcode_pap_sum.csv")%>%glimpse()

d7<-read_csv("./doc/piers_zipcode_state_sum.csv")%>%glimpse()
d8<-read_csv("./doc/piers_zipcode_pap_sum.csv")%>%glimpse()

# join all state summaries ---------------
d11<-rbind(d1,d3,d5,d7) %>% 
  select(type,n:dist_km_max)%>%
  glimpse()

# join all pap summaries ---------------
d12<-rbind(d2,d4,d6,d8) %>% 
  select(type,access_point_n:dist_km_pap_max)%>%
  glimpse()

# names(d2)
# names(d4)
# names(d6)
# names(d8)

# save -----------------
write_csv(d11,"./doc/summaries_state.csv")
write_csv(d12,"./doc/summaries_access_point.csv")
