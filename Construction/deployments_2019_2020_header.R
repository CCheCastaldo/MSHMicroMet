# read in post access header

deployments_2019_2020_header <- read.csv(file = "AddedDeployments/deployments_2019_2020.csv", 
  stringsAsFactors = F, header = T) %>%
  # convert character datetimes to POSIXct
  mutate(deployment_datetime = mdy_hm(deployment_datetime)) %>%
  mutate(retrieval_datetime = mdy_hm(retrieval_datetime)) %>%
  # add temporary survey_id and survey and comment fields
  mutate(survey_id_legacy = 1:n(), survey = "deployments_2019_2020", comment = "", raw = as.character(hobo)) %>%
  # these data have not been trimmed or compromised
  # these fields are placeholders to allow stacking
  mutate(trimmed = FALSE, compromised = FALSE) %>%
  # keep only needed fields plus survey_id_legacy and survey for making the access_migration data frame
  dplyr::select(survey_id_legacy, site_id, site_description, easting, northing, zone, terrestrial, 
    year_deployed, year_retrieved, serial, sensor_part, interval_min, height, deployment_datetime, 
    retrieval_datetime, trimmed, compromised, status, comment, raw, survey)
  
tz(deployments_2019_2020_header$deployment_datetime) <- "America/Los_Angeles"
tz(deployments_2019_2020_header$retrieval_datetime) <- "America/Los_Angeles"
