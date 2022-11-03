# create stream_tributary_header frame

stream_tributary_header <- read_excel("AccessMigration/StreamTributaryHeader.xlsx") %>%
  # rename key fields
  rename(survey_id_legacy = survey_ID, comment = Notes, raw = "raw files", interval_min = interval) %>%
  # if time missing on retrieval date then set it to 12 AM to be safe
  # note that this field will be meaningless for lost hobos and data 
  mutate(removal_time = replace(removal_time, !is.na(removal_date) & is.na(removal_time), "1899-12-31 00:00:00")) %>%
  # create usable date time fields
  mutate(install = word(install_time, 2, sep = " ")) %>%
  mutate(install_hour = as.numeric(word(install, 1, sep = ":"))) %>%
  mutate(install_min = as.numeric(word(install, 2, sep = ":"))) %>%
  mutate(removal = word(removal_time, 2, sep = " ")) %>%
  mutate(removal_hour = as.numeric(word(removal, 1, sep = ":"))) %>%
  mutate(removal_min = as.numeric(word(removal, 2, sep = ":"))) %>%
  mutate(year = year(install_date)) %>%
  mutate(deployment_datetime = make_datetime(year = year(install_date), month = month(install_date), 
    day = day(install_date), hour = install_hour, min = install_min, sec = 0, tz = "America/Los_Angeles")) %>%
  mutate(retrieval_datetime = make_datetime(year = year(removal_date), month = month(removal_date), 
    day = day(removal_date), hour = removal_hour, min = removal_min, sec = 0, tz = "America/Los_Angeles")) %>%
  # the following headers are missing the deployment time which I mannualy set to 20:00 hours to be conservative
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==65, "2012-06-12 20:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==64, "2012-06-11 20:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==63, "2012-06-11 20:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==101, "2012-09-12 20:00:00")) %>%
  # make separate launch and retrieval years for multi-year deployments
  mutate(year_deployed = year(deployment_datetime), year_retrieved =  year(retrieval_datetime)) %>%
  # identifty if unit was exposed when removed
  mutate(compromised = ifelse(comment %in% c(
    "compramised when found (floating)",
    "compramised, dry",
    "Compramised, was blown out during flooding and found in sand",
    "Data trimmed based on thermograph since streambed was dry at time of removal",
    "Dry on removal (estimated dry as of 8/23/2015). Spatially intermittent between Camp-West Up and Camp Mid.", 
    "High and dry when found",
    "Moved from Redrock (dry) on 7/20/2015.",
    "Not completely submerged",
    "Stream dry upon removal; data trimmed based on thermograph",
    "Stream dry upon removal; THIS WAS ORIGINALLY LABELLED FOR VENUS, data trimmed based on thermograph",
    "Stream Dry; data trimmed from thermograph",
    "Stream flowing, but hobo in side channel that was dry :-(; data was trimmed based on thermograph",
    "submerged, but not in flowing water; main channel moved ~40 m",
    "was exposed on surface (not submerged) but still attached to rebar.",
    "Was found in a tree"), TRUE, FALSE)) %>%
  # identify when data was trimmed manually after retrieval
  mutate(trimmed = ifelse(str_detect(comment, "thermograph")==TRUE, TRUE, FALSE)) %>%
  mutate(trimmed = replace(trimmed, is.na(trimmed), FALSE)) %>%
  # identify lost data, either thru electronic data loss or unit loss or failure
  # missing access deployments were manually checked and are all clean and trimmed if necessary: CCC 8/6/22
  mutate(status = ifelse(comment %in% c(
    "missing",
    "missing after storm",
    "missing, coordinate not good",
    "never found",
    "NOT FOUND",
    "Submerged; no data on logger"), "lost", "clean")) %>%
  # make empty sensor part field so can stack with other heads
  mutate(sensor_part = NA) %>%
  # these serial and part numbers were pulled directly from the hobo files themselves as needed to fill in gaps
  mutate(serial = replace(serial, survey_id_legacy==34, "1266110")) %>%
  mutate(serial = replace(serial, survey_id_legacy==52, "491758")) %>%
  # the only possible water temp sensors in the 491*** and 947** serial range are H08-001-02
  mutate(sensor_part = replace(sensor_part, substr(serial, 1, 3)=="491", "H08-001-02")) %>%
  mutate(sensor_part = replace(sensor_part, substr(serial, 1, 3)=="947", "H08-001-02")) %>%
  # add empty vertical_position field since no depths were ever recorded
  mutate(height = NA) %>%
  # make survey type variable: this field is used internally to make manual checking easier ansd then deleted
  mutate(survey = "2-stream") %>%
  # merge location data
  left_join(stream_locations_df, by = "survey_id_legacy") %>%
  # drop deployments with missing GPS data
  filter(!is.na(easting)) %>%
  # keep only needed fields
  dplyr::select(survey_id_legacy, site_id, site_description, easting, northing, zone, terrestrial, 
    year_deployed, year_retrieved, serial, sensor_part, interval_min, height, deployment_datetime, 
    retrieval_datetime, trimmed, compromised, status, comment, raw, survey)
  
