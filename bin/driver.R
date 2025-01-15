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
# setwd("C:/Users/jselg/OneDrive/Documents/research/R_projects/mec_travel")


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

# using CHNMS final boundary
source("./bin/mpa_ids.R")
# input:
# ./gis/California_Marine_Protected_Areas_[ds582]/California_Marine_Protected_Areas_[ds582].shp  ## State MPAs: 
# ./gis/NMS_west_coast/National_Marine_Sanctuaries_WestCoast.shp  ## Sanctuaries: 
# ./gis/Chumash_proposed_shapefile/Chumash_proposed_shapefile.shp ## PROPOSED Chumash boundaries: 
# ./gis/ChumashHeritage_AgencySelectAlt_12012022/Chumash_AgencySelectAlternative_12012022.shp  ## CHUMASH Agency Alternative: 
# ./gis/nms_chnms_final.shp  ## CHUMASH FINAL

# 
# output:
# ./gis/mpa_nms_all/mpa_nms_all.gpkg   ## ALL output in this geopackage
#   ## Layers: mpa_ca, nms_ca_2024, chnms_final (final proposed boundary as of Sept 6, 2024)
# 
# 
# 

# update ferry dataset to match others
# note was not buffered
source("./bin/ferries.R")
# input::  ./gis/public_access_points_CA2/access_ca2.gpkg", layer = "ferries"
# output: ./gis/public_access_points_CA2_buf/access_buf_mpa_nms.gpkg","ferries2"

# buffer access points 250m and 500m -------------------------------------

source("./bin/access_buf.R")
# input: ./gis/public_access_points_CA2/access_ca2.gpkg  # loaded all layers from this geopackage (see list above)
# output: public_access_points_CA2_buf/access_ca_buf.gpkg # saved all layers to this geopackage  # end of these files has _buf_DISTANCE


# identify which access points are near MPAs and sanctuaries -------------------------

# intersect  buffered access points (which are polygons) and MPAs/NMS files
#this uses agency alt boundary for CHNMS in _ch files
# note: ferry access NOT INLCUDED HERE (see next code chunk) 
# note: running nms alone and nms with the bounary alt for chnms 
# NOTE: very slow!
source("./bin/access_buf_mpa_intersect_chnms.R")
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
# output:
# ./gis/public_access_points_CA2_buf/access_buf_mpa_nms_pt_250m.gpkg/....
    # mpa_access_250m_pt   # and ... 500  # and .... nms
    # mpa_parking_250m_pt  # and ... 500  # and .... nms
    # mpa_jetties_250m_pt  # and ... 500  # and .... nms
    # mpa_access_250m_buf_ferries  
    # nms_access_250m_buf_ferries


# USING OUTPUT FROM ARCPRO MODELS -------------------

# split Zip-MPA code from ArcPro calculation into two columns
source("./bin/mpa_zip_driving_split_Name.R")
# input:  ./gis/mpa_zip_driving/mpa_zipcode_driving.gpkg
# output: ./gis/mpa_zip_driving/mpa_zipcode_driving2.gpkg




# -------------------------------------------------
# SUMMARIZE TRAVEL TIME AND DISTANCE 
#-------------------------------------------------
# checking unmatched zip codes
source("zip_code_checking_unmatched.R")
# input:  ./data/network_analyses_20240503/zipcode/all_access_zipcode_driving.txt
#         ./data/network_analysis_20240909_FINAL/zipcode/all_access/all_access_zipcode_driving.gpkg
#         ./data/California_Zip_Codes/california_zip_codes/California_Zip_Codes.gpkg
# output: ./data/California_Zip_Codes/california_zip_codes/California_Zip_Codes_matched.shp
#         ./data/California_Zip_Codes/california_zip_codes/California_Zip_Codes_unmatched_all.csv

# Calcuate time: distance relationhip for Table 1
# Also check errors in  zip codes with MPA and NMS runs
source("./bin/travel_clean_id_missing.R")
# input:    ./data/network_analysis_20240909_FINAL/zipcode/all_access/all_access_zipcode_driving.gpkg
#           ./data/network_analysis_20240909_FINAL/zipcode/mpa_ferry/shapefile/main_zipcode_mpa_f_driving.shp
#           ./data/network_analysis_20240909_FINAL/zipcode/nms_ferry_new_ch/shapefile/main_nms_ch_ferry_zipcode_driving.shp
#           ./data/network_analyses_20240503/zipcode/piers_jetties_zip_code_driving_routes_attribute_table.csv
# output: ./results/network_analysis_mpa_nms_missing.csv
#           ./results/network_analysis_all_access_FINAL.csv
#           ./results/network_analysis_mpa_some_missing.csv
#           ./results/network_analysis_nms_some_missing.csv
#           ./results/network_analysis_piers_jetties_FINAL.csv # does not have id codes (d4d does, but missing some)


# in the last code, some sip codes were missing from MPA and NMS analyses. this makes a file to ID them. 
source("./bin/missing_from_final_analysis.R")
# input:    ./results/network_analysis_mpa_nms_missing.csv
#           ./data/California_Zip_Codes/california_zip_codes/california_zip_codes.gpkg",layer="California_Zip_Codes"
# output:   ./gis/California_Zip_Codes_missing.shp


# merge missing IDs with data from older run
source("./bin/missing_from_final_analysis_merge_with_data.R")
# input:  ./results/California_Zip_Codes_matched.csv
#         ./gis/California_Zip_Codes_missing_edited.shp
#         ./data/network_analyses_20240503/zipcode/all_access_zipcode_driving.txt
#         ./data/network_analyses_20240503/zipcode/ferry_zipcode_driving.txt
#         ./data/network_analyses_20240503/zipcode/mpa_zipcode_driving.txt
#         ./data/network_analyses_20240503/zipcode/nms_zipcode_driving.txt
#           ./results/network_analysis_mpa_some_missing.csv
#           ./results/network_analysis_nms_some_missing.csv
# output:   ./results/network_analysis_mpa_FINAL.csv
#         ./results/network_analysis_mpa_almost_FINAL.csv  # some ferries go to catalina island express so need to reclac those.

# summarize final data
source("./bin/travel_stats_time_dist.R")



# summarize travel time/distances for state and public access points (paps)
source("./bin/travel_summarize.R")
# input:  ./data/network_analysis_20240909_FINAL/zipcode/all_access/all_access_zipcode_driving.gpkg
# output: ./results/all_access_zipcode_driving2.csv #cleaned version of file
#         ./doc/all_access_zipcode_state_sum.csv
#         ./results/all_access_zipcode_pap_all.csv
#         ./doc/all_access_zipcode_pap_sum.csv

# summarize travel time/distances for mpas
source("./bin/travel_summarize_mpas.R")
# input:  ./data/network_analysis_20240909_FINAL/zipcode/mpa_ferry/shapefile/main_zipcode_mpa_f_driving.shp
# output: ./results/nms_zipcode_driving2.csv #cleaned version of file
#         ./doc/nms_zipcode_state_sum.csv
#         ./results/nms_zipcode_pap_all.csv
#         ./doc/nms_zipcode_pap_sum.csv

# summarize travel time/distances for nms
source("./bin/travel_summarize_nms.R")
# input:  ./data/network_analysis_20240909_FINAL/zipcode/nms_ferry_new_ch/shapefile/main_nms_ch_ferry_zipcode_driving.shp
# output: ./results/mpas_zipcode_driving2.csv #cleaned version of file
#         ./doc/mpas_zipcode_state_sum.csv
#         ./results/mpas_zipcode_pap_all.csv
#         ./doc/mpas_zipcode_pap_sum.csv

# summarize travel time/distances for piers and jetties
source("./bin/travel_summarize_piers.R")
# input:  ./data/network_analyses_20240503/zipcode/piers_jetties_zip_code_driving_routes_attribute_table.csv
# output: ./results/piers_zipcode_driving2.csv #cleaned version of file
#         ./doc/piers_zipcode_state_sum.csv
#         ./results/piers_zipcode_pap_all.csv
#         ./doc/piers_zipcode_pap_sum.csv


# join all summary stats
source("./bin/travel_summarize_join.R")  # in process
# input:     ./doc/all_access_zipcode_state_sum.csv
#            ./doc/all_access_zipcode_pap_sum.csv
#            ./doc/mpa_zipcode_state_sum.csv
#            ./doc/mpa_zipcode_pap_sum.csv
#            ./doc/nms_zipcode_state_sum.csv
#            ./doc/nms_zipcode_pap_sum.csv
#            ./doc/piers_zipcode_state_sum.csv
#            ./doc/piers_zipcode_pap_sum.csv
# output:    ./doc/summaries_state.csv
#            ./doc/summaries_access_point.csv






# graphs of travel time
source("./bin/travel_graph.R")
# input:  
# output:

# graphs of travel time to MPAs
source("./bin/travel_graph.R")
# input:  
# output:

# graphs of travel time to NMS
source("./bin/travel_graph.R")
# input:  
# output:


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


# exlpore cal enviroscreen data
source("./bin/calenviroscreen.R")
#         
#         
#         
#         
#         
#         