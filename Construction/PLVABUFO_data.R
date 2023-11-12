pathName <- "hobo_csv/plva_bufo_deployments/"
files <- list.files(path = pathName)
lst <- list()

for (i in 1:length(files)) {
  lst[[i]] <- read.csv(file = paste0(pathName, files[i]), stringsAsFactors = F, skip = 1, header = T)
  # assign column names depending on whether hobo csv file has an id and / or relative humidity columns
   if (str_detect(colnames(lst[[i]])[1], "Date")==TRUE & length(colnames(lst[[i]]))==3) {
    colnames(lst[[i]]) <- c("datetime_temp", "temperature", "relative_humidity")
  }
  if (length(colnames(lst[[i]]))==2) {
    colnames(lst[[i]]) <- c("datetime_temp", "temperature")
    lst[[i]]$relative_humidity <- NA
  } 
  if (str_detect(colnames(lst[[i]])[1], "Date")==FALSE & str_detect(colnames(lst[[i]])[1], "date")==FALSE & 
      length(colnames(lst[[i]]))==3) {
    colnames(lst[[i]]) <- c("id", "datetime_temp", "temperature")
    lst[[i]]$relative_humidity <- NA
  }
  if (length(colnames(lst[[i]]))==4) colnames(lst[[i]]) <- c("id", "datetime_temp", "temperature", "relative_humidity")
  # save serial number to determine whether it matches serial reported in header file
  headrows <- paste(readLines(paste0(pathName, files[i]))[1:2], collapse = " ")
  serial_check <- str_trim(str_match(headrows, ": (.*?) --")[2], "both")
  if (is.na(serial_check)) serial_check <- str_trim(str_match(headrows, "S/N: (.*?) c")[2], "both")
  # assign site_id and year based on csv file name
  site_id_match <- substr(files[i], 1, str_length(files[i]) - 9)
  year_deployed_match <- as.numeric(substr(files[i], str_length(files[i]) - 7, str_length(files[i]) - 4))
  # add survey_id 
  work <- micromet_header %>% 
    dplyr::filter(survey=="PLVABUFO" & site_id==site_id_match & year_deployed==year_deployed_match)
  check1 <- (dim(work)[1]==1)
  if (check1==TRUE) lst[[i]]$survey_id <- work$survey_id
  # check that serial in header matches serial in header of hobo export
  check2 <- work$serial==serial_check
  if (check1 == FALSE | check2 == FALSE) print(paste(files[i], check1, work$serial, serial_check, check2, sep = ", "))
  lst[[i]] <- lst[[i]] %>%
    mutate(datetime = mdy_hms(datetime_temp)) %>%
    dplyr::select(survey_id, datetime, temperature, relative_humidity)
}

PLVAHOBO_data_df <- do.call(what = rbind, args = lst) %>%
  dplyr::select(survey_id, datetime, temperature, relative_humidity) %>%
  arrange(survey_id, datetime) %>%
  mutate(relative_humidity = as.numeric(relative_humidity))

# make sure time zone is GMT-7
tz(PLVAHOBO_data_df$datetime) <- "America/Los_Angeles"
