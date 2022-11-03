# combine all data files

MSHMicrometData <- rbind(PLVAHOBO_data_df, access_migration_data_df, post_access_data_df) %>%
  arrange(survey_id, datetime) %>%
  # keep only rows when hobos were in-situ, with 1 hour buffer
  left_join(micromet_header %>% dplyr::select(survey_id, site_id, year_deployed, deployment_datetime, retrieval_datetime), by = "survey_id") %>%
  dplyr::filter(datetime > (deployment_datetime + hours(1)) & datetime < (retrieval_datetime - hours(1))) %>%
  # perform manual trimming as needed after inspection of the hobo files or shiny app
  dplyr::filter(!(site_id=="CLRCRK_C1" & year_deployed==2012 & datetime >= "2013-03-01 00:00:00")) %>%
  dplyr::filter(!(site_id=="FORCRK_T" & year_deployed==2012 & datetime >= "2013-05-01 00:00:00")) %>%
  dplyr::filter(!(site_id=="RDRCRK_H" & year_deployed==2012 & datetime >= "2013-05-08 12:00:00")) %>%
  dplyr::filter(!(site_id=="GEOCRKE_H" & year_deployed==2012 & datetime >= "2013-04-27 08:30:00")) %>%
  dplyr::filter(!(site_id=="GSECRK" & year_deployed==2012 & datetime >= "2013-03-21 15:00:00")) %>%
  dplyr::filter(!(site_id=="GEOCRK_C" & year_deployed==2012 & datetime >= "2013-03-22 12:00:00")) %>%
  dplyr::filter(!(site_id=="DNYBRK" & year_deployed==2012 & datetime >= "2013-04-04 07:00:00")) %>%
  dplyr::filter(!(site_id=="RDRCRK_U" & year_deployed==2019 & datetime >= "2019-07-31 08:30:00")) %>%
  dplyr::filter(!(site_id=="RDRCRK_U" & year_deployed==2018 & datetime >= "2018-08-26 04:00:00")) %>%
  dplyr::filter(!(site_id=="H02A" & year_deployed==2020 & datetime >= "2020-08-21 00:00:00")) %>%
  dplyr::filter(!(site_id=="H10" & year_deployed==2020 & datetime >= "2020-08-21 00:00:00")) %>%
  dplyr::filter(!(site_id=="H12" & year_deployed==2020 & datetime >= "2020-07-24 00:00:00")) %>%
  dplyr::filter(!(site_id=="H16" & year_deployed==2020 & datetime >= "2020-08-27 00:00:00")) %>%
  dplyr::filter(!(site_id=="RDRCRK_U" & year_deployed==2022 & datetime >= "2022-10-01 00:00:00")) %>%
  dplyr::filter(!(site_id=="GEOCRK_U" & year_deployed==2022 & datetime >= "2022-10-12 23:00:00")) %>%
  dplyr::filter(!(site_id=="PMPWEB" & year_deployed==2020)) %>%
  dplyr::select(survey_id, datetime, temperature, relative_humidity) %>%
  # round all temperature and RH measurements to nearest .1
  dplyr::mutate(temperature = round(temperature, 1), relative_humidity = round(relative_humidity, 1))

# some headers are missing the recording interval so compute this from the data and merge it back with the headers
hobo_data_interval <- MSHMicrometData %>%
  group_by(survey_id) %>%
  # get interval
  mutate(diff = difftime(datetime, lag(datetime), units = "mins")) %>%
  summarise(interval_calc = Mode(diff, na.rm = TRUE)) %>%
  ungroup()

# check for surveys that have hobo file but data is missing due to 
# hobo being set incorrectly or entire time series being compromised and dropped
hobo_surveys_data <- MSHMicrometData %>%
  dplyr::select(survey_id) %>%
  mutate(hobo_data = 1) %>%
  distinct()

# drop survey_legacy_id
MSHMicrometHeader <- micromet_header %>%
  # replace missing intervals from header with intervals calculated from logger data itself
  left_join(hobo_data_interval, by = "survey_id") %>%
  mutate(interval = ifelse(is.na(interval_min), as.numeric(interval_calc), as.numeric(interval_min))) %>%
  # set surveys with missing data to lost of not already lost
  left_join(hobo_surveys_data, by = "survey_id") %>%
  mutate(status = replace(status, is.na(hobo_data) & status=="clean", "lost")) %>%
  # keep only needed fields
  dplyr::select(survey_id, site_id, site_description, zone, terrestrial, easting, northing, height, 
    year_deployed, year_retrieved, serial, sensor_type, sensor_part, interval, deployment_datetime, 
    retrieval_datetime, status, hobo) %>%
  arrange(survey_id)

# check that everyone has a header
hobo_surveys_data <- hobo_surveys_data %>%
  left_join(MSHMicrometHeader %>% 
  dplyr::filter(status != "lost") %>%
  dplyr::select(survey_id) %>%
  mutate(hobo_header = 1), by = "survey_id") %>%
  dplyr::filter(hobo_data == 1 & is.na(hobo_header))
if(nrow(hobo_surveys_data ) > 0) print(hobo_surveys_data)
  
  