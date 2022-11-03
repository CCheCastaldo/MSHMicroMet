# read in post access header

post_access_header <- read.csv(file = "AddedDeployments/post_access_header.csv", stringsAsFactors = F, header = T) %>%
  # convert character datetimes to POSIXct
  mutate(deployment_datetime = mdy_hm(deployment_datetime)) %>%
  mutate(retrieval_datetime = mdy_hm(retrieval_datetime)) %>%
  # these data have not been trimmed
  mutate(trimmed = FALSE) %>%
  # add temporary survey_id and survey and comment fields
  mutate(survey_id_legacy = 1:n(), survey = "postaccess", raw = as.character(hobo)) %>%
  # keep only needed fields plus survey_id_legacy and survey for making the access_migration data frame
  dplyr::select(survey_id_legacy, site_id, site_description, easting, northing, zone, terrestrial, 
    year_deployed, year_retrieved, serial, sensor_part, interval_min, height, deployment_datetime, 
    retrieval_datetime, trimmed, compromised, status, comment, raw, survey)
  
tz(post_access_header$deployment_datetime) <- "America/Los_Angeles"
tz(post_access_header$retrieval_datetime) <- "America/Los_Angeles"
