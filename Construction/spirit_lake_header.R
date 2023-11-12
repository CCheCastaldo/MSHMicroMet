# create pond data frames

spirit_lake_header <-  read_excel("access_migration/SpiritLakeHeader.xlsx") %>%
  # rename key fields
  rename(interval_min = interval, survey_id_legacy = survey_ID, serial = sensor_ID, sensor = sensor_type, 
    raw = raw_data_files) %>%
  # remove depth from site_id
  mutate(site_id = ifelse(substr(location, 1, 3)=="DBW", "DUCKBW",
    ifelse(substr(location, 1, 3) == "DBE", "DUCKBE", "SUNISL"))) %>%
  # remove wrong info in serial field
  mutate(serial = replace(serial, 
    serial %in% c("duckbay_west_bottom", "spirit_bot1_summer06", "spririt_bottom_winter0506"), NA)) %>%
  # these serial numbers were pulled directly from the hobo files themselves as needed to fill in gaps
  mutate(serial = replace(serial, survey_id_legacy==81, "10212994")) %>%
  mutate(serial = replace(serial, survey_id_legacy==71, "491578")) %>%
  mutate(serial = replace(serial, survey_id_legacy==68, "10212995")) %>%
  mutate(serial = replace(serial, survey_id_legacy==67, "491581")) %>%
  mutate(serial = replace(serial, survey_id_legacy==66, "1266110")) %>%
  mutate(serial = replace(serial, survey_id_legacy==65, "491581")) %>%
  mutate(serial = replace(serial, survey_id_legacy==64, "491570")) %>%
  mutate(serial = replace(serial, survey_id_legacy==63, "491581")) %>%
  mutate(serial = replace(serial, survey_id_legacy==62, "1266111")) %>%
  mutate(serial = replace(serial, survey_id_legacy==61, "491558")) %>%
  mutate(serial = replace(serial, survey_id_legacy==60, "491569")) %>%
  mutate(serial = replace(serial, survey_id_legacy==59, "491572")) %>%
  mutate(serial = replace(serial, survey_id_legacy==58, "10172858")) %>%
  mutate(serial = replace(serial, survey_id_legacy==57, "10172860")) %>%
  mutate(serial = replace(serial, survey_id_legacy==56, "10172849")) %>%
  mutate(serial = replace(serial, survey_id_legacy==55, "491572")) %>%
  mutate(serial = replace(serial, survey_id_legacy==54, "491573")) %>%
  mutate(serial = replace(serial, survey_id_legacy==53, "491558")) %>%
  mutate(serial = replace(serial, survey_id_legacy==52, "491566")) %>%
  mutate(serial = replace(serial, survey_id_legacy==51, "491573")) %>%
  mutate(serial = replace(serial, survey_id_legacy==50, "491566")) %>%
  mutate(serial = replace(serial, survey_id_legacy==49, "1266110")) %>%
  mutate(serial = replace(serial, survey_id_legacy==48, "491561")) %>%
  mutate(serial = replace(serial, survey_id_legacy==47, "491568")) %>%
  mutate(serial = replace(serial, survey_id_legacy==46, "491585")) %>%
  mutate(serial = replace(serial, survey_id_legacy==4, "491556")) %>%
  mutate(serial = replace(serial, survey_id_legacy==5, "491573")) %>%
  mutate(serial = replace(serial, survey_id_legacy==6, "491584")) %>%
  mutate(serial = replace(serial, survey_id_legacy==7, "491571")) %>%
  mutate(serial = replace(serial, survey_id_legacy==8, "491562")) %>%
  mutate(serial = replace(serial, survey_id_legacy==9, "491569")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==10, "491578")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==11, "491582")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==12, "491575")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==13, "491583")) %>%
  mutate(serial = replace(serial, survey_id_legacy==14, "491575")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==15, "491572")) %>%    
  mutate(serial = replace(serial, survey_id_legacy==16, "1266111")) %>%      
  mutate(serial = replace(serial, survey_id_legacy==17, "491566")) %>%      
  mutate(serial = replace(serial, survey_id_legacy==18, "491569")) %>%      
  mutate(serial = replace(serial, survey_id_legacy==19, "10172850")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==25, "491560")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==26, "491575")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==27, "491579")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==28, "491559")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==29, "491568")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==30, "491578")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==31, "491572")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==32, "491574")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==33, "491583")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==34, "491585")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==35, "491563")) %>%        
  mutate(serial = replace(serial, survey_id_legacy==36, "491572")) %>%
  mutate(serial = replace(serial, survey_id_legacy==37, "491563")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==38, "491583")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==39, "491579")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==40, "491583")) %>%    
  mutate(serial = replace(serial, survey_id_legacy==41, "491567")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==42, "10172851")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==43, "10172855")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==44, "10209353")) %>%  
  mutate(serial = replace(serial, survey_id_legacy==45, "491561")) %>%  
  # split sensor into type and part number
  mutate(sensor_part = word(sensor, 2, sep = ";")) %>%
  # sensors are often labeled as H08-001-02 which are air only sensors but I confirmed with CMC that these
  # two serial numbers do not have sensor parts but are only 1 value different from a serial that does have a sensor part
  # so I am assigning them the part of the adjacent serial numbers
  mutate(sensor_part = replace(sensor_part, survey_id_legacy==41, "H08-001-02")) %>%
  mutate(sensor_part = replace(sensor_part, survey_id_legacy==81, "UA-002-64")) %>%
  # create usable date time fields
  mutate(install = word(time_install, 2, sep = " ")) %>%
  mutate(install_hour = as.numeric(word(install, 1, sep = ":"))) %>%
  mutate(install_min = as.numeric(word(install, 2, sep = ":"))) %>%
  mutate(removal = word(time_removed, 2, sep = " ")) %>%
  mutate(removal_hour = as.numeric(word(removal, 1, sep = ":"))) %>%
  mutate(removal_min = as.numeric(word(removal, 2, sep = ":"))) %>%
  mutate(year = year(date_install)) %>%
  mutate(deployment_datetime = make_datetime(year = year(date_install), month = month(date_install), 
    day = day(date_install), hour = install_hour, min = install_min, sec = 0, tz = "America/Los_Angeles")) %>%
  mutate(retrieval_datetime = make_datetime(year = year(date_removed), month = month(date_removed), 
    day = day(date_removed), hour = removal_hour, min = removal_min, sec = 0, tz = "America/Los_Angeles")) %>%
  # the deployment and retrieval data for header 68 is incorrect and must be replaced  
  mutate(deployment_datetime = replace(deployment_datetime, survey_id_legacy==68, "2012-10-09 18:00:00")) %>%
  mutate(retrieval_datetime = replace(retrieval_datetime, survey_id_legacy==68, "2013-07-20 00:00:00")) %>%
  # fill in missing retrieval data for winter 2017 to summer 2018  
  mutate(retrieval_datetime = replace(retrieval_datetime, survey_id_legacy==87, "2018-07-02 14:20:00")) %>%
  mutate(retrieval_datetime = replace(retrieval_datetime, survey_id_legacy==88, "2018-07-02 14:20:00")) %>%
  mutate(retrieval_datetime = replace(retrieval_datetime, survey_id_legacy==91, "2018-07-02 14:50:00")) %>%
  mutate(retrieval_datetime = replace(retrieval_datetime, survey_id_legacy==92, "2018-07-02 14:50:00")) %>%
  mutate(retrieval_datetime = replace(retrieval_datetime, survey_id_legacy==93, "2018-07-02 14:50:00")) %>%
  # make separate launch and retrieval years for multi-year deployments
  mutate(year_deployed = year(deployment_datetime), year_retrieved =  year(retrieval_datetime)) %>%
  # create field to identifty when data was trimmed manually after retrieval
  rename(trimmed = dates_edited) %>%
  # create field to identify if unit was exposed when removed
  mutate(compromised =  FALSE) %>%
  # identify failed data, either thru data or unit loss or failure
  # missing access deployments were manually checked and are all clean: CCC 8/6/22
  mutate(status = ifelse(comment %in% c("logger didn't collect") | downloaded==FALSE, "lost", "clean")) %>%
  mutate(status = replace(status, survey_id_legacy %in% c(87, 88, 91, 92, 93), "clean")) %>%
  # depths in access are incorrect, fix as per discussion with CMC
  rename(height_legacy = height) %>%
  mutate(height = case_when(
    location %in% c("DBWS", "DBES", "SUNISL_SUR") ~ -100,
    location %in% c("DBWB", "DBEB") ~ -500,
    location == "SUNISL_MID" ~ -1000,
    location == "SUNISL_BOT" ~ -2000)) %>%
  # make survey type variable: this field is used internally to make manual checking easier ansd then delete
  mutate(survey = "3-spiritlake") %>%
  # merge location data
  left_join(spirit_lake_locations_df, by = "site_id") %>%
  # keep only needed fields
  dplyr::select(survey_id_legacy, site_id, site_description, easting, northing, zone, terrestrial, 
    year_deployed, year_retrieved, serial, sensor_part, interval_min, height, deployment_datetime, 
    retrieval_datetime, trimmed, compromised, status, comment, raw, survey)
