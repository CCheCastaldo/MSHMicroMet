# read in PLVA BUFO header location and convert to WGS84 UTM 10N
# missing access deployments were manually checked and are all clean: CCC 8/6/22
# changed raw to clean in header .csv file: CCC 8/6/22

header_PLVABUFO_locations_df <- st_as_sf(read.csv(file = "AddedDeployments/PLVABUFO_header.csv", 
    stringsAsFactors = F, header = T) %>% dplyr::filter(!is.na(latitude)) %>%
    dplyr::select(site_id, year_deployed, latitude, longitude), 
  coords = c("longitude", "latitude"), crs = st_crs(4326)) %>%
  st_transform(32610) %>%
  mutate(easting = round(st_coordinates(.)[, 1]), northing = round(st_coordinates(.)[, 2])) %>%
  as.data.frame() %>%
  dplyr::select(-geometry) 
  
# read in PLVA BUFO header 

PLVABUFO_header <- read.csv(file = "AddedDeployments/PLVABUFO_header.csv", stringsAsFactors = F, header = T) %>%
  # convert character datetimes to POSIXct
  mutate(deployment_datetime = mdy_hm(deployment_datetime)) %>%
  mutate(retrieval_datetime = mdy_hm(retrieval_datetime)) %>%
  # these data have not been trimmed
  mutate(trimmed = FALSE) %>%
  # add temporary survey_id and survey and comment fields
  mutate(survey_id_legacy = 1:n(), survey = "PLVABUFO", comment = "", raw = as.character(hobo)) %>%
  # merge with header locations
  left_join(header_PLVABUFO_locations_df, by = c("site_id", "year_deployed")) %>%
  # keep only needed fields plus survey_id_legacy and survey for making the access_migration data frame
  dplyr::select(survey_id_legacy, site_id, site_description, easting, northing, zone, terrestrial, year_deployed, 
    year_retrieved, serial, sensor_part, interval_min, height, deployment_datetime, retrieval_datetime, trimmed, 
    compromised, status, comment, raw, survey)
  
tz(PLVABUFO_header$deployment_datetime) <- "America/Los_Angeles"
tz(PLVABUFO_header$retrieval_datetime) <- "America/Los_Angeles"
