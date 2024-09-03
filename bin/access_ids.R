# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: create csuci ID for beach/ocean public access points and piers and jetties

# guide to acronyms ----
# PAP = public access point
# PAM = public amenities
# PPK = public parking
# CO  = county
# PAJ  = piers and jetties
#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate)# 
library(sp); 

#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel")


# access points -------------------

# checks layers in the file
st_layers("./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1 - Access Opportunities.gpkg")

# load
d1<-(st_read("./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1 - Access Opportunities.gpkg"))%>% 
  mutate(id_pap=paste0("pap_",row_number()))%>%
  select(id_pap,access_name=Name,access_location=Location,access_type=AccessType,access_type_detail=Type_of_Access_Point,access_county=County,access_cdfips=CDFIPS,access_congressional_dist_116=Congressional_District_116,access_district_id=DISTRICTID,OBJECTID_1)
  
d1%>%glimpse()%>% plot()
plot(d1[,11])

d1a<-d1%>%
  as_tibble()%>%
  glimpse()

# amentities -------------------
d2<-(st_read("./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1 - Beach Amenities.gpkg"))%>% 
  mutate(id_pam=paste0("pam_",row_number()))%>%
  select(id_pam,amenity_type=Feature_Type,amenity_beach=Beach,amenity_city=City,amenity_county=COUNTY_NAME,OBJECTID)%>%
  glimpse()

unique(d2$Feature_Type)

d2%>%glimpse()%>% plot()

d2a<-d2%>%
  as_tibble()%>%
  glimpse()

# parking --------------------
d3<-(st_read("./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1 - Beach Parking.gpkg"))%>% 
  mutate(id_ppk=paste0("ppk_",row_number()))%>%
  select(-Shape__Area,-Shape__Length)%>%
  select(id_ppk,parking_type=ParkingType, parking_free_or_fee=Free_or_Fee_Parking,parking_street_approx_no=Approx__No__Parking_along_Stree,parking_delinated_no=Number_of_Delineated_Parking_Sp,parking_unmarked_lot_no=Approx__unmarked_spaces_in_Lot,parking_beach=BeachName,parking_city=City,parking_spots_total=TotalSpots,parking_county=County,parking_comments=Comments)%>%
  glimpse()

d3%>%glimpse()%>% plot()


d3a<-d3%>%
  as_tibble()%>%
  glimpse()

# counties --------------------------
d4<-(st_read("./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1 - Coastal Counties.gpkg"))

d4a<-d4%>%  
  mutate(id_co=paste0("co_",row_number()))%>%
  select(county=NAME,state=STATE_NAME,fips_state=STATE_FIPS, fips_county=COUNTY_FIPS,fips=FIPS,sq_mi=SQMI,id_co,geom)%>%
  glimpse()

d4a%>%glimpse()%>% plot()

d4a<-d4%>%
  as_tibble()%>%
  glimpse()

# california ----------------------------
d5<-(st_read("./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1.gpkg"))%>% 
  select(state=STATE_NAME,fips_state=STATE_FIPS,sq_mi=SQMI,geom)

d5%>%glimpse()%>% plot()

d5a<-d5%>%
  as_tibble()%>%
  glimpse()

# piers and jetties
d6<-(st_read("./gis/public_piers_jetties/Public_Piers_and_Jetties_-_R7_-_CDFW_[ds3090].shp"))%>% 
  mutate(id_paj=paste0("paj_",row_number()))%>%
  st_transform(4326)%>%
  select(id_paj,pier,pier_county=county,pier_notes=notes)%>%
  glimpse()

d6%>%glimpse()%>% plot()

d6a<-d6%>%
  as_tibble()%>%
  glimpse()

# ferries - already has ID
d7<-(st_read("./gis/ferry_access/ferry_access.shp"))%>% 
  select(id_ferry,access_name=Name,access_location=location,access_type=AccessType,price_adult_day_trip_min=price_adul)%>%
  glimpse()
  
  
plot(d7)

d7a<-d7%>%
  as_tibble()%>%
  glimpse()

# SAVE ---------------------------------------------------
# save in separate gpkg files
st_write(d1,"./gis/public_access_points_CA2/access_ca.gpkg","access",delete_layer=T)
st_write(d2,"./gis/public_access_points_CA2/amenities_ca.gpkg","amenities_ca", delete_layer=T)
st_write(d3,"./gis/public_access_points_CA2/parking_ca.gpkg","parking_ca", delete_layer=T)
st_write(d4a,"./gis/public_access_points_CA2/counties_ca.gpkg","counties_ca", delete_layer=T)
st_write(d5,"./gis/public_access_points_CA2/state_ca.gpkg","ca",delete_layer=T)
st_write(d6,"./gis/public_access_points_CA2/piers_jetties_ca.gpkg","piers_jetties",delete_layer=T)
st_write(d7,"./gis/public_access_points_CA2/ferries.gpkg","ferries",delete_layer=T)

#all in one geopackage as layers
st_write(d1,"./gis/public_access_points_CA2/access_ca2.gpkg","beach_access_ca",delete_layer=T)
st_write(d2,"./gis/public_access_points_CA2/access_ca2.gpkg","beach_amenities_ca", delete_layer=T)
st_write(d3,"./gis/public_access_points_CA2/access_ca2.gpkg","beach_parking_ca", delete_layer=T)
st_write(d4a,"./gis/public_access_points_CA2/access_ca2.gpkg","beach_counties_ca", delete_layer=T)
st_write(d5,"./gis/public_access_points_CA2/access_ca2.gpkg","ca",delete_layer=T)
st_write(d6,"./gis/public_access_points_CA2/access_ca2.gpkg","piers_jetties",delete_layer=T)
st_write(d7,"./gis/public_access_points_CA2/access_ca2.gpkg","ferries",delete_layer=T)

# non-spatial files
write_csv(d1a,"./results/public_access_points.csv")
write_csv(d6a,"./results/ammenities.csv")
write_csv(d6a,"./results/parking.csv")
write_csv(d6a,"./results/piers.csv")