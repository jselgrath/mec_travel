# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: split access ID to zip and destination


# guide to acronyms ----

#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate); library (leaflet)# 


#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/gis/mec_access/ZipCodes")


# zip code polygons
d0<-st_read("./California_Zip_Codes.shp")%>%
  glimpse() 
  

  
# new wd 
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel") 

# driving times and routes -------------------

# checks layers in the gpkg
st_layers("./gis/mpa_zip_driving/mpa_zipcode_driving.gpkg")

# drive times/routes
d1<-st_read("./gis/mpa_zip_driving/mpa_zipcode_driving.gpkg")%>%
  separate_wider_delim(Name, delim = " - ", names = c("ZIP_CODE", "mpa"))%>% # separate code
  glimpse() 



# select > this creates a tibble not a sf FYI
d2<-d1%>%
  select(ZIP_CODE,mpa,Total_TravelTime,Total_Kilometers)%>%
  glimpse()


# check types
class(d0$ZIP_CODE) #"character"
class(d2$ZIP_CODE) #"character"


# join
d3<-d0%>%
  full_join(d2, by="ZIP_CODE")%>% #zip code polygons
  glimpse()

round(range(d3$Total_TravelTime, na.rm=T),3)


st_write(d1,"./gis/mpa_zip_driving/mpa_zipcode_driving2.gpkg","mpa_drive_time_km",delete_layer=T)

write_csv(d2,"./results/mpa_drive_time_zipcode.csv")

st_write(d3,"./gis/mpa_zip_driving/mpa_zipcode_driving2.gpkg","zipcode_mpa_drive_time_km",delete_layer=T)


# graph

plot(d3)
plot(d3[8])

# below does not work, jsut trying internet code ---------------------------
bins <- c(0, 30, 60, 120, 180, 240, 300, 380)
pal <- colorBin("RdYlGn", domain = d3$Total_TravelTime, bins = bins)

mapa <- leaflet(data = d3) %>%
  addTiles() %>%
  addPolygons(label = ~Total_TravelTime,
              popup = ~PO_NAME,
              fillColor = ~pal(Total_TravelTime),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)
  ) %>%
  # addProviderTiles(providers$OpenStreetMap) %>%
  addLegend("bottomright", pal = pal, values = ~Total_TravelTime,
            title = "Travel to MPAs [Mi2]",
            opacity = 1
  )
