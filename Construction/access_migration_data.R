# combine access migration data

#------------------------------------------------------------------------------------------
# three functions (each for differing formats) to read in missing or replace incorrect hobo data exports

import_hobo_1 <- function(source_file, survey_num, survey_type) {
  df <- read.csv(file = source_file, stringsAsFactors = F, skip = 1, header = T) %>%
    dplyr::select(c(2,3,4))
  names(df) <- c("datetime_temp", "temperature", "relative_humidity")
  df <- df %>%
    mutate(survey_id_legacy = survey_num, survey = survey_type) %>%
    mutate(datetime = mdy_hms(datetime_temp)) %>%
    mutate(relative_humidity = replace(relative_humidity, survey!="1-terrestrial", NA)) %>%
    dplyr::select(survey_id_legacy, datetime, temperature, relative_humidity, survey) 
  return(df)
}

import_hobo_2 <- function(source_file, survey_num, survey_type) {
  df <- read.csv(file = source_file, stringsAsFactors = F, header = T) %>%
    dplyr::select(c(1,2))
  names(df) <- c("datetime_temp", "temperature")
  df <- df %>%
    mutate(survey_id_legacy = survey_num, survey = survey_type, relative_humidity = NA) %>%
    mutate(datetime = mdy_hm(datetime_temp)) %>%
    dplyr::select(survey_id_legacy, datetime, temperature, relative_humidity, survey) 
  return(df)
}

import_hobo_3 <- function(source_file, survey_num, survey_type) {
  df <- read.csv(file = source_file, stringsAsFactors = F, skip = 1, header = T) %>%
    dplyr::select(c(2,3))
  names(df) <- c("datetime_temp", "temperature")
  df <- df %>%
    mutate(survey_id_legacy = survey_num, survey = survey_type, relative_humidity = NA) %>%
    mutate(datetime = mdy_hms(datetime_temp)) %>%
    dplyr::select(survey_id_legacy, datetime, temperature, relative_humidity, survey) 
  return(df)
}

lst <- list()
lst[[1]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/RDRCRK_2016.csv", 155, "1-terrestrial")
lst[[2]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/RDRUPL_2016.csv", 156, "1-terrestrial")
lst[[3]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/PPCAST_2016.csv", 160, "1-terrestrial")
lst[[4]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/WILSPU_2016.csv", 164, "1-terrestrial")
lst[[5]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/UPLSNE_2016.csv", 169, "1-terrestrial")
lst[[6]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/PMPWEB_2016_2017.csv", 174, "1-terrestrial")
lst[[7]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/UPLSNW_2017.csv", 175, "1-terrestrial")
lst[[8]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/PMPWEB_2017.csv", 176, "1-terrestrial")
lst[[9]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/PPWET1_2017.csv", 177, "1-terrestrial")
lst[[10]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/PPWET2_2017.csv", 178, "1-terrestrial")
lst[[11]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/RDRUPL_2017.csv", 179, "1-terrestrial")
lst[[12]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/FORUPL_2017.csv", 180, "1-terrestrial")
lst[[13]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/PMPGRN_2017.csv", 181, "1-terrestrial")
lst[[14]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/PPUPL1_2017.csv", 182, "1-terrestrial")
lst[[15]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/UPLSHS_2017.csv", 183, "1-terrestrial")
lst[[16]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/UPLSNE_2017.csv", 184, "1-terrestrial")
lst[[17]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/RDRCRK_2017.csv", 185, "1-terrestrial")
lst[[18]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/BSTCRK_2017.csv", 186, "1-terrestrial")
lst[[19]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/WILSPU_2017.csv", 187, "1-terrestrial")
lst[[20]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/PPUPL2_2017.csv", 188, "1-terrestrial")
lst[[21]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/FORCRK_2017.csv", 189, "1-terrestrial")
lst[[22]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/PPCAST_2017.csv", 190, "1-terrestrial")
lst[[23]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/WILSPR_2017.csv", 191, "1-terrestrial")
lst[[24]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/DUCKBE_top_2012_2013.csv", 68, "3-spiritlake")
lst[[25]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/DUCKBE_top_2017_2018.csv", 87, "3-spiritlake")
lst[[26]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/DUCKBE_bottom_2017_2018.csv", 88, "3-spiritlake")
lst[[27]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/SUNISL_top_2017_2018.csv", 91, "3-spiritlake")
lst[[28]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/SUNISL_middle_2017_2018.csv", 92, "3-spiritlake")
lst[[29]] <- import_hobo_1("HoboCSV/MissingAccessDeployments/SUNISL_bottom_2017_2018.csv", 93, "3-spiritlake")
lst[[30]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/CLRCRK_F_2012_2013.csv", 59, "2-stream")
lst[[31]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/CLRCRK_F_2012.csv", 61, "2-stream")
lst[[32]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/WILSPRE_H_2012.csv", 62, "2-stream")
lst[[33]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/GEOCRK_M_2012.csv", 63, "2-stream")
lst[[34]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/CMPCRK_M_2012.csv", 64, "2-stream")
lst[[35]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/CMPCRK_U_2012.csv", 65, "2-stream")
lst[[36]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/CMPCRKW_U_2012.csv", 66, "2-stream")
lst[[37]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/CMPCRKE_U_2012.csv", 67, "2-stream")
lst[[38]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/GEOCRKW_H_2012.csv", 68, "2-stream")
lst[[39]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/CMPCRK_C_2012.csv", 69, "2-stream")
lst[[40]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/GEOCRK_C_2012.csv", 70, "2-stream")
lst[[41]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/RDRCRK_H_2012.csv", 71, "2-stream")
lst[[42]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/FORCRK_T_2012.csv", 72, "2-stream")
lst[[43]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/WILSPR_C2_2012.csv", 73, "2-stream")
lst[[44]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/WILSPRE_C_2012.csv", 74, "2-stream")
lst[[45]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/CLRCRK_H_2012.csv", 75, "2-stream")
lst[[46]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/WILSPR_M_2012.csv", 77, "2-stream")
lst[[47]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/GEOCRKE_H_2012.csv", 78, "2-stream")
lst[[48]] <- import_hobo_3("HoboCSV/MissingAccessDeployments/DNYBRK_2012.csv", 79, "2-stream")
lst[[49]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/BEAVCRK_L_2012_2013.csv", 80, "2-stream")
lst[[50]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/RDRCRK_H_2012_2013.csv", 81, "2-stream")
lst[[52]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/BEARCRK_2012_2013.csv", 82, "2-stream")
lst[[53]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/FORCRK_T_2012_2013.csv", 83, "2-stream")
lst[[54]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/CLRCRK_C1_2012_2013.csv", 86, "2-stream")
lst[[55]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/WILSPRE_C_2012_2013.csv", 87, "2-stream")
lst[[56]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/NORCRK_O_2012_2013.csv", 88, "2-stream")
lst[[57]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/CMPCRKW_U_2012_2013.csv", 92, "2-stream")
lst[[58]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/GEOCRKW_H_2012_2013.csv", 94, "2-stream")
lst[[59]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/GEOCRK_C_2012_2013.csv", 95, "2-stream")
lst[[60]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/CLRCRK_H_2012_2013.csv", 96, "2-stream")
lst[[61]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/GEOCRKE_H_2012_2013.csv", 97, "2-stream")
lst[[62]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/DNYBRK_2012_2013.csv", 98, "2-stream")
lst[[63]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/GSECRK_2012_2013.csv", 99, "2-stream")
lst[[64]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/FISHCRK_2012_2013.csv", 100, "2-stream")
lst[[65]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/NORCRK_L_2012_2013.csv", 101, "2-stream")
lst[[66]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/ALDCRK_2012_2013.csv", 103, "2-stream")
lst[[51]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/CLRCRK_C1_2013.csv", 107, "2-stream")
lst[[67]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/CMPCRK_L_2013.csv", 108, "2-stream")
lst[[68]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/GSECRK_2013.csv", 109, "2-stream")
lst[[69]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/CMPCRK_O_2013.csv", 110, "2-stream")
lst[[70]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/GEOCRKE_H_2013.csv", 111, "2-stream")
lst[[71]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/GEOCRK_M_2013.csv", 113, "2-stream")
lst[[72]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/BEAVCRK_L_2013.csv", 114, "2-stream")
lst[[73]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/BEARCRK_2013.csv", 115, "2-stream")
lst[[74]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/FORCRK_T_2013.csv", 116, "2-stream")
lst[[75]] <- import_hobo_2("HoboCSV/MissingAccessDeployments/RDRCRK_H_2013.csv", 117, "2-stream")

#------------------------------------------------------------------------------------------
# join each data source with header 

added_hobo_df <- do.call(what = rbind, args = lst) %>%
  left_join(micromet_header %>% 
    dplyr::select(survey_id_legacy, survey_id, survey, status),
    by = c("survey_id_legacy", "survey")) %>%
  dplyr::select(survey_id_legacy, survey_id, survey, status, datetime, temperature, relative_humidity)

debris_avalanche_survey <- read_excel("AccessMigration/PondTemperatureData.xlsx") %>%
  # rename key fields
  rename(survey_id_legacy = survey_ID, datetime = date_time,  temperature = temp_C) %>%
  mutate(relative_humidity = NA) %>%
  left_join(micromet_header %>% 
    filter(survey == "4-debrisavalanche") %>%
    dplyr::select(survey_id_legacy, survey_id, survey, status),
    by = "survey_id_legacy") %>%
  dplyr::select(survey_id_legacy, survey_id, survey, status, datetime, temperature, relative_humidity)

spirit_lake_survey <- read_excel("AccessMigration/SpiritLakeData.xlsx", 
  col_types = c("numeric", "numeric", "text", "date", "date", "numeric", "numeric", "numeric", "date", "numeric")) %>%
  # rename key fields
  rename(survey_id_legacy = survey_ID, temperature = temp_C) %>%
  # delete survey 68 with incorrect data - the correct data has been added in above
  dplyr::filter(survey_id_legacy!=68) %>%
  mutate(relative_humidity = NA) %>%
  left_join(micromet_header %>% 
    filter(survey=="3-spiritlake") %>%
    dplyr::select(survey_id_legacy, survey_id, survey, status),
    by = "survey_id_legacy") %>%
  dplyr::select(survey_id_legacy, survey_id, survey, status, datetime, temperature, relative_humidity)

stream_tributary_survey <- read_excel("AccessMigration/StreamTributaryData.xlsx") %>%
  # rename key fields
  rename(survey_id_legacy = survey_ID, temperature = tempC) %>%
  mutate(relative_humidity = NA) %>%
  left_join(micromet_header %>% 
    filter(survey=="2-stream") %>%
    dplyr::select(survey_id_legacy, survey_id, survey, status),
    by = "survey_id_legacy") %>%
  dplyr::select(survey_id_legacy, survey_id, survey, status, datetime, temperature, relative_humidity)

terrestrial_survey <- rbind(read_excel("AccessMigration/TerrestrialData1.xlsx"), 
  read_excel("AccessMigration/TerrestrialData2.xlsx")) %>%
  # rename key fields
  rename(survey_id_legacy = survey_ID, datetime = date_time, temperature = temp_c, relative_humidity = rh) %>%
  dplyr::select(survey_id_legacy, datetime, temperature, relative_humidity) %>%
  left_join(micromet_header %>% 
    filter(survey=="1-terrestrial") %>%
    dplyr::select(survey_id_legacy, survey_id, survey, status),
    by = "survey_id_legacy") %>%
  dplyr::select(survey_id_legacy, survey_id, survey, status, datetime, temperature, relative_humidity)

#------------------------------------------------------------------------------------------

access_migration_data_df <- rbind(debris_avalanche_survey, spirit_lake_survey, stream_tributary_survey, 
    terrestrial_survey, added_hobo_df) %>%
  arrange(survey_id, datetime) %>%
  # remove data for 4 surveys with missing locations (these have no survey id)
  dplyr::filter(!is.na(survey_id)) %>%
  # remove any data from lost surveys - this should be zero rows
  dplyr::filter(status == "clean") %>%
  mutate(relative_humidity = as.numeric(relative_humidity)) %>%
  dplyr::select(survey_id, datetime, temperature, relative_humidity)

# make sure time zone is GMT-7
tz(access_migration_data_df$datetime) <- "America/Los_Angeles"
