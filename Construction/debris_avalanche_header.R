# create debris_avalanche_header frame

debris_avalanche_header <- read_excel("AccessMigration/PondTemperatureHeader.xlsx") %>%
  # rename key fields
  rename(survey_id_legacy = survey_ID, site_id = pond_ID, comment = notes, raw = "raw data file") %>%
  # if time missing on retrieval date then set it to 12 AM to be safe
  mutate(removal_time = replace(removal_time, !is.na(removal_date) & is.na(removal_time), "0:00:00 AM")) %>%
  # create usable date time fields
  mutate(install_adjust = ifelse(str_detect(install_time, "PM") & as.numeric(word(install_time, 1, sep = ":")!=12), 12, 0)) %>%
  mutate(install_hour = as.numeric(word(install_time, 1, sep = ":")) + install_adjust) %>%
  mutate(install_min = as.numeric(word(install_time, 2, sep = ":"))) %>%
  mutate(launch_adjust = ifelse(str_detect(launch_time, "PM") & as.numeric(word(launch_time, 1, sep = ":")!=12), 12, 0)) %>%
  mutate(launch_hour = as.numeric(word(launch_time, 1, sep = ":")) + launch_adjust) %>%
  mutate(launch_min = as.numeric(word(launch_time, 2, sep = ":"))) %>%
  mutate(removal_adjust = ifelse(str_detect(removal_time, "PM") & as.numeric(word(removal_time, 1, sep = ":")!=12), 12, 0)) %>%
  mutate(removal_hour = as.numeric(word(removal_time, 1, sep = ":")) + removal_adjust) %>%
  mutate(removal_min = as.numeric(word(removal_time, 2, sep = ":"))) %>%
  mutate(deployment_datetime = make_datetime(year = year(install_date), month = month(install_date), 
    day = day(install_date), hour = install_hour, min = install_min, sec = 0, tz = "America/Los_Angeles")) %>%
  mutate(launch_datetime = make_datetime(year = year(launch_date), month = month(launch_date), 
    day = day(launch_date), hour = launch_hour, min = launch_min, sec = 0, tz = "America/Los_Angeles")) %>%
  mutate(retrieval_datetime = make_datetime(year = year(removal_date), month = month(removal_date),
    day = day(removal_date), hour = removal_hour, min = removal_min, sec = 0, tz = "America/Los_Angeles")) %>%
  # the deployment dates are set to 1 interval earlier than the clipped excel data
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==77, "2017-05-24 18:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==101, "2017-06-27 21:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==102, "2017-06-27 21:00:00")) %>%
  # make separate launch and retrieval years for multi-year deployments
  mutate(year_deployed = ifelse(is.na(deployment_datetime), year(launch_datetime), year(deployment_datetime))) %>%
  mutate(year_retrieved = ifelse(is.na(retrieval_datetime), year(retrieval_datetime), year(retrieval_datetime))) %>%
  # identifty when data was trimmed manually after retrieval
  mutate(trimmed = ifelse(str_detect(comment, "thermograph")==TRUE, TRUE, FALSE)) %>%
  mutate(trimmed = replace(trimmed, is.na(trimmed), FALSE)) %>%
  # identifty if unit was exposed when removed
  mutate(compromised = ifelse(str_detect(comment, "dry")==TRUE, TRUE, FALSE)) %>%
  mutate(compromised = replace(compromised, comment %in% c(
    "This data is wonky. Should not be used!!!",
    "moved 3m to north side of Alder on 8-May",
    "repositioned 02 june 2015 at 15:46",
    "moved 4m to north side of alder on 7 May"), TRUE)) %>% 
  mutate(compromised = replace(compromised, is.na(compromised), FALSE)) %>%
  # make empty sensor part field so can stack with other heads
  mutate(sensor_part = NA) %>%
  # if sensor part is missing from 2002 and 2003 debris avalanche water temp deployments then the part must be H08-001-02
  mutate(sensor_part = replace(sensor_part, year_deployed %in% c(2002, 2003) & terrestrial==FALSE, "H08-001-02")) %>%
  # identify failed data, either thru data or unit loss or failure
  mutate(status = ifelse(comment %in% c(
    "Didn't log data", 
    "Hobo lost", 
    "110cm depth on willow", 
    "installed in littoral zone near BUBO breeding site. Could not find original raw file"), 
    "lost", 
    "clean")) %>%
  # stream survey id 6 supposedly has bad data 
  mutate(status = replace(status, survey_id_legacy==6, "lost")) %>%
  # make depth numeric
  mutate(depth_cm = replace(depth_cm, depth_cm == "NA", NA)) %>%
  mutate(height = as.numeric(depth_cm)) %>%
  # make survey type variable: this field is used internally to make manual checking easier and then deleted
  mutate(survey = "4-debrisavalanche") %>%
  # merge location data
  left_join(pond_locations_df, by = c("site_id", "terrestrial")) %>%
  # keep only needed fields
  dplyr::select(survey_id_legacy, site_id, site_description, easting, northing, zone, terrestrial, 
    year_deployed, year_retrieved, serial, sensor_part, interval_min, height, deployment_datetime, 
    retrieval_datetime, trimmed, compromised, status, comment, raw, survey)
