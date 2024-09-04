# Jennifer Selgrath
# NOAA CINMS
#
# GOAL: driver file for gis processing related to calculating driving and transit times to beach access points, parking, and piers and jetties, and ferries

# guide to acronyms ----
# PAP = public access point
# PAM = public amenities
# PPK = public parking
# CO  = county
# PAJ  = piers and jetties
#======================================================
library(tidyverse); library(dplyr); library(sf); library(ggplot2); library(lubridate) 
library(sp); 

#======================================================
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/mec_travel")


# calculate IDs for access points (cleaned by CSUCI) & from piers and jetties (not cleaned) ---------------------
source("./bin/access_ids.R")
# input: 
# ./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1 - Access Opportunities.gpkg
# ./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1 - Beach Amenities.gpkg
# ./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1 - Beach Parking.gpkg
# ./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1 - Coastal Counties.gpkg
# ./gis/public_access_points_CA_csuci/gpkg/California Coastal Access Amenities and Parking WFL1.gpkg
# ./gis/public_piers_jetties/Public_Piers_and_Jetties_-_R7_-_CDFW_[ds3090].shp

# output: 
# ./gis/public_access_points_CA2/access_ca.gpkg
# ./gis/public_access_points_CA2/amenities_ca.gpkg
# ./gis/public_access_points_CA2/parking_ca.gpkg
# ./gis/public_access_points_CA2/counties_ca.gpkg
# ./gis/public_access_points_CA2/state_ca.gpkg
# ./gis/public_access_points_CA2/piers_jetties_ca.gpkg

# copies of all outputs in this .gpkg: 
# ./gis/public_access_points_CA2/access_ca2.gpkg


# asign unique IDs to MPA and NMS files -----------------------------

# using CHNMS inital boundary alternative - now prefererd alternative
source("./bin/mpa_ids.R")
# input:
# ./gis/California_Marine_Protected_Areas_[ds582]/California_Marine_Protected_Areas_[ds582].shp  ## State MPAs: 
# ./gis/NMS_west_coast/National_Marine_Sanctuaries_WestCoast.shp  ## Sanctuaries: 
# ./gis/Chumash_proposed_shapefile/Chumash_proposed_shapefile.shp ## PROPOSED Chumash boundaries: 
# ./gis/ChumashHeritage_AgencySelectAlt_12012022/Chumash_AgencySelectAlternative_12012022.shp  ## CHUMASH Agency Alternative: 
# 
# output:
# ./gis/mpa_nms_all/mpa_nms_all.gpkg   ## ALL output in this geopackage
#   ## Layers: mpa_ca, nms_ca, chnms_1 (chumash proposed only), chnms_alt (chumash agency alt only), nms_chnms_1 (all CA NMS with chumash proposed), nms_chnms_alt (all CA NMS with chumash agency alt)
# 
# 
# 

# buffer access points 250m and 500m -------------------------------------

source("./bin/access_buf.R")
# input: ./gis/public_access_points_CA2/access_ca2.gpkg  # loaded all layers from this geopackage (see list above)
# output: public_access_points_CA2_buf/access_ca_buf.gpkg # saved all layers to this geopackage  # end of these files has _buf_DISTANCE


# identify which access points are near MPAs and sanctuaries -------------------------

# intersect  buffered access points (which are polygons) and MPAs/NMS files
#this uses agency alt boundary for CHNMS in _ch files
# note: ferry access not included because not within buffer
# note: running nms alone and nms with the bounary alt for chnms 
# NOTE: very slow!
source("./bin/mpa_access_buf_interesect_chnms.R")
# input: 
# ./gis/public_access_points_CA2_buf/access_ca_buf.gpkg 
      # all buffered access layers in the geopackage
# ./gis/mpa_nms_all/mpa_nms_all.gpkg  
      # all mpa/nms layers

# output: 
# access_buf_mpa_nms.gpkg 
      # all layers in this geopackage



# join buffer MPA/NMS data info back to points -----------------------------------

# buffer files include MPA and NMS data
# all steps repeated for 250m and 500m
source("./bin/access_point_buf_join")
# input:
# ./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg  # access/ferry buffers
# ./gis/public_access_points_CA2/access_ca2.gpkg              # access/ferry points
#  
# 
# output:
# ./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg
# ./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_500m.gpkg
# 
# split Zip-MPA code from ArcPro calculation into two columns
source("./bin/mpa_zip_driving_split_Name.R")
# input:  ./gis/mpa_zip_driving/mpa_zipcode_driving.gpkg
# output: ./gis/mpa_zip_driving/mpa_zipcode_driving2.gpkg

# summarize travel time/distances for state and public access points (paps)
source("./bin/travel_summarize.R")
# input:  ./data/network_analyses_20240503/zipcode/all_access_zipcode_driving.txt
# output: ./results/all_access_zipcode_driving2.csv #cleaned version of file
#         ./doc/all_access_zipcode_state_sum.csv
#         ./results/all_access_zipcode_pap_all.csv
#         ./doc/all_access_zipcode_pap_sum.csv

# graphs of travel time
source("./bin/travel_graph.R")
# input:  
# output:

# summarize travel time/distances for piers and jetties
source("./bin/travel_summarize_piers.R")
# input:  ./data/network_analyses_20240503/zipcode/piers_jetties_zip_code_driving_routes_attribute_table.csv
# output: ./results/piers_zipcode_driving2.csv #cleaned version of file
#         ./doc/piers_zipcode_state_sum.csv
#         ./results/piers_zipcode_pap_all.csv
#         ./doc/piers_zipcode_pap_sum.csv

# graphs of travel time
source("./bin/travel_graph_piers.R")
# input:  ./results/piers.csv
#         ./results/piers_zipcode_driving2.csv
#         ./doc/piers_zipcode_state_sum.csv
#         ./results/piers_zipcode_pap_all.csv
#         ./doc/piers_zipcode_pap_sum.csv
# output: ./doc/pier_state_time_km.tiff
#         ./doc/pier_time_km.tiff
#         ./doc/pier_zip_count_name.tiff
#         ./doc/pier_zip_count_county.tiff
#         ./doc/piers_zip_countno_label.tiff

# make honeycomb / hexagon file
source("./bin/hex_polygon")

#         
#         
#         
#         
#         
#         