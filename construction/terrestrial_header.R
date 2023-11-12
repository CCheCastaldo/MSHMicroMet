# create terrestrial_header frame

terrestrial_header <- read_excel("access_migration/TerrestrialHeader.xlsx") %>%
  # rename key fields
  rename(survey_id_legacy = survey_ID, site_id = site, comment = notes, sensor = sensor_type, 
    height = height_cm, serial = serial_no, raw = raw_data) %>%
  # if install time missing then set it to 8 PM to be safe
  mutate(install_time = replace(install_time, !is.na(install_date) & is.na(install_time), "1899-12-31 20:00:00")) %>%
  # create usable date time fields
  mutate(install = word(install_time, 2, sep = " ")) %>%
  mutate(install_hour = as.numeric(word(install, 1, sep = ":"))) %>%
  mutate(install_min = as.numeric(word(install, 2, sep = ":"))) %>%
  mutate(begin = word(begin_time, 2, sep = " ")) %>%
  mutate(begin_hour = as.numeric(word(begin, 1, sep = ":"))) %>%
  mutate(begin_min = as.numeric(word(begin, 2, sep = ":"))) %>%
  mutate(removal = word(end_time, 2, sep = " ")) %>%
  mutate(removal_hour = as.numeric(word(removal, 1, sep = ":"))) %>%
  mutate(removal_min = as.numeric(word(removal, 2, sep = ":"))) %>%
  mutate(year = year(begin_date)) %>%
  mutate(launch_datetime = make_datetime(year = year(begin_date), month = month(begin_date), 
    day = day(begin_date), hour = begin_hour, min = begin_min, sec = 0, tz = "America/Los_Angeles")) %>%
  mutate(deployment_datetime = make_datetime(year = year(install_date), month = month(install_date), 
    day = day(install_date), hour = install_hour, min = install_min, sec = 0, tz = "America/Los_Angeles")) %>%
  mutate(retrieval_datetime = make_datetime(year = year(end_date), month = month(end_date), day = day(end_date), 
    hour = removal_hour, min = removal_min, sec = 0, tz = "America/Los_Angeles")) %>%
  # the following headers are missing the deployment data which I retrieved directly from old field notes, 
  # forms, random scraps of paper, etc.
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==174, "2016-10-14 14:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==25, "2006-07-01 12:05:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==26, "2006-07-01 14:45:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==27, "2006-07-01 16:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==28, "2006-07-01 12:10:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==29, "2006-07-01 15:10:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==8, "2006-07-04 11:03:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==30, "2006-07-01 12:25:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==31, "2006-07-01 11:50:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==32, "2006-07-01 16:20:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==33, "2006-07-01 11:25:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==34, "2006-07-01 11:50:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==35, "2006-07-01 12:40:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==36, "2006-07-01 17:20:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==10, "2008-06-23 20:05:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==50, "2008-06-23 18:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==51, "2008-06-23 18:25:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==52, "2008-06-23 18:55:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==53, "2008-06-23 19:05:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==54, "2008-06-23 19:18:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==55, "2008-06-23 19:30:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==56, "2008-06-23 19:45:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==57, "2008-06-24 13:45:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==58, "2008-06-24 14:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==59, "2008-06-24 18:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==60, "2008-06-24 18:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==61, "2008-06-24 18:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==62, "2008-06-24 18:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==11, "2009-06-30 15:28:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==63, "2009-06-30 12:03:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==64, "2009-06-30 14:13:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==65, "2009-06-30 14:20:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==66, "2009-06-30 14:45:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==67, "2009-06-30 14:33:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==68, "2009-06-30 15:16:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==69, "2009-06-30 14:56:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==70, "2009-06-30 12:49:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==71, "2009-06-30 13:17:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==72, "2009-06-30 15:45:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==73, "2009-06-30 16:02:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==74, "2009-07-01 11:45:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==75, "2009-07-01 11:30:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==9, "2007-06-21 11:00:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==37, "2007-06-21 16:30:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==38, "2007-06-21 13:40:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==39, "2007-06-21 13:55:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==40, "2007-06-21 12:15:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==41, "2007-06-21 12:40:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==42, "2007-06-19 13:15:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==43, "2007-06-21 10:35:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==44, "2007-06-19 12:50:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==45, "2007-06-21 12:45:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==46, "2007-06-21 17:10:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==47, "2007-06-21 10:05:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==48, "2007-06-19 14:38:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==49, "2007-06-19 14:25:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==12, "2010-06-28 17:20:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==13, "2010-06-28 18:18:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==14, "2010-06-29 13:55:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==15, "2010-06-29 12:48:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==16, "2010-06-29 16:51:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==17, "2010-06-29 17:55:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==18, "2010-06-30 11:40:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==76, "2010-06-30 12:20:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==77, "2010-06-30 12:45:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==78, "2010-06-30 13:46:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==79, "2010-06-30 14:14:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==80, "2010-06-30 15:41:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==81, "2010-06-30 15:52:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==82, "2010-06-30 16:47:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==19, "2003-05-20 14:30:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==20, "2003-05-20 13:15:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==21, "2003-05-20 13:25:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==22, "2003-05-20 13:55:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==23, "2003-05-20 14:20:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==24, "2003-05-20 14:30:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==1, "2005-05-31 15:45:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==2, "2005-05-31 17:05:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==3, "2005-06-01 19:45:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==4, "2005-05-31 19:50:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==5, "2005-06-01 12:35:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==6, "2005-06-01 13:40:00")) %>%
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==7, "2005-06-01 16:20:00")) %>%
  # make separate launch and retrieval years for multi-year deployments
  mutate(year_deployed = ifelse(is.na(deployment_datetime), year(launch_datetime), year(deployment_datetime))) %>%
  mutate(year_retrieved = ifelse(is.na(retrieval_datetime), year(retrieval_datetime), year(retrieval_datetime))) %>%
  # these serial numbers were pulled directly from the hobo files themselves as needed to fill in gaps
  mutate(serial = replace(serial, survey_id_legacy==1, "492645")) %>%
  mutate(serial = replace(serial, survey_id_legacy==2, "492644")) %>%
  mutate(serial = replace(serial, survey_id_legacy==3, "492639")) %>%
  mutate(serial = replace(serial, survey_id_legacy==4, "399739")) %>%
  mutate(serial = replace(serial, survey_id_legacy==5, "492643")) %>%
  mutate(serial = replace(serial, survey_id_legacy==6, "492646")) %>%
  mutate(serial = replace(serial, survey_id_legacy==7, "492641")) %>%
  mutate(serial = replace(serial, survey_id_legacy==8, "492647")) %>%
  mutate(serial = replace(serial, survey_id_legacy==9, "492637")) %>%
  mutate(serial = replace(serial, survey_id_legacy==10, "492637")) %>%
  mutate(serial = replace(serial, survey_id_legacy==11, "492637")) %>%
  mutate(serial = replace(serial, survey_id_legacy==12, "492637")) %>%
  mutate(serial = replace(serial, survey_id_legacy==13, "1032864")) %>%
  mutate(serial = replace(serial, survey_id_legacy==14, "399740")) %>%
  mutate(serial = replace(serial, survey_id_legacy==15, "1277064")) %>%
  mutate(serial = replace(serial, survey_id_legacy==16, "1277066")) %>%
  mutate(serial = replace(serial, survey_id_legacy==17, "492639")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==18, "399743")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==54, "492643")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==61, "492645")) %>%   
  # fix site id typo
  mutate(site_id = replace(site_id, site_id=="BDLCUT", "BLDCUT")) %>%   
  # fix height deployed for 2003
  mutate(height = replace(height, year_deployed==2003, 50)) %>%
  # identifty if unit was exposed when removed
  mutate(compromised = ifelse(comment %in% c(
    "Was found off shield lying on the ground"), TRUE, FALSE)) %>%
  # identify when data was trimmed manually after retrieval
  mutate(trimmed = FALSE) %>%
  # identify lost data, either thru electronic data loss or unit loss or failure
  # missing access deployments were manually checked and are all clean: CCC 8/6/22
  mutate(status = ifelse(comment %in% c(
    "Failed to download",
    "Failed to log",
    "HOBO did not log data"), "lost", "clean")) %>%
  # split sensor into type and part number
  mutate(sensor_type = word(sensor, 1, sep = ";")) %>%
  mutate(sensor_part = word(sensor, 2, sep = ";")) %>%
  # these sensor types and parts were pulled directly from the hobo files themselves as needed to fill in gaps
  mutate(sensor_part = replace(sensor_part, survey_id_legacy==178, "U23-001")) %>%
  # replace `NA` with true NA
  mutate(serial = replace(serial, serial=="NA", NA)) %>%
  # make survey type variable: this field is used internally to make manual checking easier ansd then deleted
  mutate(survey = "1-terrestrial") %>%
  # arrange by year and site_id
  arrange(year_retrieved, site_id) %>%
  # merge location data
  left_join(terrestrial_locations_df, by = "site_id") %>%
  # keep only needed fields
  dplyr::select(survey_id_legacy, site_id, site_description, easting, northing, zone, terrestrial, year_deployed, 
    year_retrieved, serial, sensor_part, interval_min, height, deployment_datetime, retrieval_datetime, trimmed, 
    compromised, status, comment, raw, survey)
