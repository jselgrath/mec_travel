# Lucas Lowe & Jenny Selgrath
# CINMS/Bren 
# August 23, 2023

# Goal: what people are closest to MPAs? calculating driving distances and travel time to coastal access points

# ---------------------------------------------------

library(tidyverse)
library(dplyr)
# ---------------------------------------------------

remove(list = ls())
# "/Users/lucaslowe/Desktop/MEC2023/MEC_DRIVING")
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel")

# ---------------------------------------------------

d1 <- read_csv("./data/DRIVE_MPA_PAP_ZIPCODE_20230822.csv") %>%
  glimpse()

# took out " - " from zip code and ID column. 
d2<-d1%>%
  separate_wider_delim(Name," - ", names = c("zip", "mpa_pap"))%>%
  glimpse()

#confirm correct number of zip codes
unique(d2$zip)
length(unique(d2$zip))

# summarize by zip code, distance, and travel time for each closest MPA
d3<-d2%>%
  group_by(mpa_pap, zip, zipcode_longitude, zipcode_latitude)%>%
  summarize(
    n = n(), 
    time_u = mean(Total_TravelTime_min), 
    time_sd = sd(Total_TravelTime_min), 
    time_sem = time_sd/sqrt(n),
    time_min = min(Total_TravelTime_min), 
    time_max = max(Total_TravelTime_min), 
    time_u_hr = time_u/60,
  
    dist_km_u = mean(Total_Kilometers), 
    dist_km_sd = sd(Total_Kilometers), 
    dist_km_sem = dist_km_sd/sqrt(n),
    dist_km_min = min(Total_Kilometers), 
    dist_km_max = max(Total_Kilometers), 
  )%>%
  ungroup()%>%
  glimpse()

range(d3$n)
range(d3$time_min, na.rm = T)
range(d3$time_u_hr, na.rm =T)

# summarize by MPA access point
d4<-d2%>%
  group_by(mpa_pap)%>%
  summarize(
    n = n(), 
    time_u = mean(Total_TravelTime_min), 
    time_sd = sd(Total_TravelTime_min), 
    time_sem = time_sd/sqrt(n),
    time_min = min(Total_TravelTime_min), 
    time_max = max(Total_TravelTime_min), 
    time_u_hr = time_u/60,
    
    dist_km_u = mean(Total_Kilometers), 
    dist_km_sd = sd(Total_Kilometers), 
    dist_km_sem = dist_km_sd/sqrt(n),
    dist_km_min = min(Total_Kilometers), 
    dist_km_max = max(Total_Kilometers), 
  )%>%
  ungroup()%>%
  glimpse()






write_csv(d3,"./results/mpa_drive_summary_pap.csv")

write_csv(d4,"./results/pap_drive_summary_zip.csv")



ggplot(d3,aes(x = zipcode_longitude, y = zipcode_latitude))+geom_point()
ggplot(d3,aes(x = n))+geom_bar() + theme_bw()

# barplot showing range of MPAs close to zipcodes
ggplot(d3, aes(x = n)) +
  geom_bar(fill = "blue") +  
  theme_bw() +
  theme(panel.grid = element_blank())  

ggsave("./doc/mpa_drive_n.jpg")
range(d3$n)

#-----------------------------------------------

list.files()

pap_data <- read.csv("pap_mpa.csv")
summarize_data <- read.csv("mpa_drive_summary.csv")
final_data <- summarize_data %>%
  left_join(pap_data, by = "mpa_pap")
write.csv(final_data, "Final_Summarize.csv", row.names = FALSE)



