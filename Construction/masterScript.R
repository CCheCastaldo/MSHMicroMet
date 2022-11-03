library(readxl)
library(tidyverse)
library(lubridate)
library(DescTools)
library(stringr)
library(skimr)
library(readr)
library(sf)

rm(list = ls())

#------------------------------------------------------------------------------------------
# process all hobo location data
source("Construction/stream_tributary_locations.R")
source("Construction/debris_avalanche_locations.R")
source("Construction/terrestrial_locations.R")
source("Construction/spirit_lake_locations.R")

rm(list = setdiff(ls(), c("pond_locations_df", "stream_locations_df", 
  "terrestrial_locations_df", "spirit_lake_locations_df")))

#------------------------------------------------------------------------------------------
# process all hobo survey headers
source("Construction/debris_avalanche_header.R")
source("Construction/spirit_lake_header.R")
source("Construction/stream_tributary_header.R")
source("Construction/terrestrial_header.R")
source("Construction/PLVABUFO_header.R")
source("Construction/post_access_header.R")
source("Construction/micromet_header.R")

rm(list = setdiff(ls(), "micromet_header"))

#------------------------------------------------------------------------------------------
# process all hobo survey data 
source("Construction/access_migration_data.R")
rm(list = setdiff(ls(), c("micromet_header", "access_migration_data_df")))
source("Construction/PLVABUFO_data.R")
rm(list = setdiff(ls(), c("micromet_header", "access_migration_data_df", "PLVAHOBO_data_df")))
source("Construction/post_access_data.R")
rm(list = setdiff(ls(), c("micromet_header", "access_migration_data_df", "PLVAHOBO_data_df", "post_access_data_df")))

#------------------------------------------------------------------------------------------
# data and header post-processing
source("Construction/micromet_postprocessing.R")
rm(list = setdiff(ls(), c("MSHMicrometHeader", "MSHMicrometData")))

#------------------------------------------------------------------------------------------
# final processing
# convert to lat long
MSHMicrometHeader_sf <- MSHMicrometHeader %>%
  st_as_sf(coords = c("easting", "northing"), crs = st_crs(32610)) %>%
  st_transform(4326) %>%
  # keep only needed fields plus survey_id_legacy and survey for making the data table
  dplyr::select(survey_id, site_id, site_description, zone, terrestrial, year_deployed, year_retrieved, serial, sensor_type, 
    sensor_part, interval, height, deployment_datetime, retrieval_datetime, status, hobo, geometry)

MSHMicrometHeader <- MSHMicrometHeader_sf %>%
  mutate(geodetic_datum = "EPSG:4326") %>%
  mutate(decimal_longitude = st_coordinates(.)[, 1], decimal_latitude = st_coordinates(.)[, 2]) %>%
  as.data.frame() %>%
  # keep only needed fields plus survey_id_legacy and survey for making the data table
  dplyr::select(survey_id, site_id, site_description, zone, decimal_longitude, decimal_latitude, geodetic_datum, terrestrial, year_deployed, 
    year_retrieved, serial, sensor_type, sensor_part, interval, height, deployment_datetime, retrieval_datetime, status, hobo)

#------------------------------------------------------------------------------------------
# check field values
print(skim(MSHMicrometHeader))
print(as.data.frame(MSHMicrometHeader) %>% dplyr::select_if(is.character) %>% map(table)) 
print(skim(MSHMicrometData))

#------------------------------------------------------------------------------------------
save(MSHMicrometHeader, file = "MSHMicroMet/data/MSHMicrometHeader.rda")
save(MSHMicrometData, file = "MSHMicroMet/data/MSHMicrometData.rda")
write.csv(MSHMicrometHeader, file = "Library/MSHMicrometHeader.csv", row.names = FALSE, na = "")
write.csv(MSHMicrometData, file = gzfile("Library/MSHMicrometData.csv.gz"), row.names = FALSE, na = "")


