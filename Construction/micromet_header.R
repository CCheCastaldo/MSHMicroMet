# combine access migration headers

serial_sensor_part_onset <-  read_excel("access_migration/SerialSensorPart.xlsx", col_types = c("text", "text")) %>%
  mutate(sensor_part = str_trim(sensor_part, side = "both")) %>%
  # this serial number was incorrectly identified by onset as H01-001-01 when it actually is H08-032-08
  mutate(sensor_part = replace(sensor_part, serial=="499973", "H08-032-08"))

micromet_header <- rbind(debris_avalanche_header, spirit_lake_header, stream_tributary_header, 
  terrestrial_header, PLVABUFO_header, post_access_header) %>%
  # standardize sensor_types across headers to remove leading and trailing zeros
  mutate(sensor_part = str_trim(sensor_part, side = "both")) %>%
  # remove incorrect serial numbers
  mutate(serial = replace(serial, serial %in% c("X", "X1", "X2", "X3", "X4", "X5"), NA)) %>%
  # add back missing zero for H08-32-08 sensor part
  mutate(sensor_part = replace(sensor_part, sensor_part=="H08-32-08", "H08-032-08")) %>%
  # pull in onset sensor_part data based on serial numbers
  left_join(serial_sensor_part_onset, by = "serial") %>%
  # if sensor part is not already defined in the header then use the sensor part # assigned by onset to the serial code
  mutate(sensor_part = ifelse(is.na(sensor_part.y), sensor_part.x, sensor_part.y)) %>%
  dplyr::select(survey_id_legacy, site_id, site_description, easting, northing, zone, terrestrial, 
    year_deployed, year_retrieved, serial, sensor_part, interval_min, height, deployment_datetime, 
    retrieval_datetime, trimmed, compromised, status, raw, survey, comment)
  
# make complete list of all unique serial and sensor part combination
serial_sensor_part_all <- micromet_header %>%
  dplyr::select(serial, sensor_part) %>%
  dplyr::filter(!is.na(serial) & !is.na(sensor_part)) %>%
  distinct()

# check whether the same serial number has been assigned multiple sensor parts  
serial_sensor_part_check <- serial_sensor_part_all %>%
  mutate(id = 1) %>%
  group_by(serial) %>%
  summarise(count = sum(id)) %>%
  ungroup() %>%
  dplyr::filter(count > 1)

print(paste0("serials with multiple sensor parts: ", dim(serial_sensor_part_check)[1]))

micromet_header <- micromet_header %>%
  left_join(serial_sensor_part_all, by = "serial") %>%
  # if sensor part is not already defined in the header then use the sensor part # assigned from other headers
  mutate(sensor_part = ifelse(is.na(sensor_part.y), sensor_part.x, sensor_part.y)) %>%
  # add sensor type field based on sensor part
  mutate(sensor_type = NA) %>%
  mutate(sensor_type = replace(sensor_type, sensor_part=="U22-001", "pro-v2")) %>%
  mutate(sensor_type = replace(sensor_type, sensor_part=="UA-002-64", "pendant")) %>%
  mutate(sensor_type = replace(sensor_type, sensor_part=="H08-001-02", "pro series")) %>%
  mutate(sensor_type = replace(sensor_type, sensor_part=="H08-032-08", "pro series")) %>%
  mutate(sensor_type = replace(sensor_type, sensor_part=="UA-002-08", "pendant")) %>%
  mutate(sensor_type = replace(sensor_type, sensor_part=="UTBI-001", "tidbit")) %>%
  mutate(sensor_type = replace(sensor_type, sensor_part=="U23-001", "pro-v2")) %>%
  mutate(sensor_type = replace(sensor_type, sensor_part=="H01-001-01", "temp")) %>%
  # define new survey id to replace survey id legacy from old access database
  arrange(deployment_datetime, site_id) %>%
  mutate(survey_id = 1:n()) %>%
  arrange(survey, survey_id_legacy) %>%
  # replace hobo intervals with values of 0 with values of NA
  mutate(interval_min = replace(interval_min, interval_min==0, NA)) %>%
  # determine whether .hobo or .dtf exists
  mutate(hobo = ifelse((str_detect(raw, ".hobo")==FALSE & str_detect(raw, ".dtf")==FALSE & 
      str_detect(raw, ".txt")==FALSE & raw=="FALSE") | is.na(raw), FALSE, TRUE)) %>%
  # keep only needed fields plus survey_id_legacy and survey for making the data table
  dplyr::select(survey_id, survey_id_legacy, site_id, site_description, easting, northing, zone, terrestrial, 
    year_deployed, year_retrieved, serial, sensor_type, sensor_part, interval_min, height, deployment_datetime, 
    retrieval_datetime, status, compromised, hobo, survey, comment)


