# read in post access data

pathName <- "hobo_csv/post_access_deployments/"
files <- list.files(path = pathName)
lst <- list()

for (i in 1:length(files)) {
  lst[[i]] <- read.csv(file = paste0(pathName, files[i]), stringsAsFactors = F, skip = 1, header = T)[,1:4]
  colnames(lst[[i]]) <- c("id", "datetime_temp", "temperature", "relative_humidity")
  # save serial number to determine whether it matches serial reported in header file
  headrows <- paste(readLines(paste0(pathName, files[i]))[1:2], collapse = " ")
  # confirm that header exists for deployment in question and assign these data the survey_id
  serial_check <- str_trim(str_match(headrows, "S/N: (.*?),")[2], "both")
  if (str_count(files[i], '_') == 1) {
    site_id_match <- word(files[i], 1, sep = "_")
    year_deployed_match <- substr(word(files[i], 2, sep = "_"), 1, 4)
  }
  if (str_count(files[i], '_') == 3) {
    site_id_match <- word(files[i], 1, sep = "_")
    year_deployed_match <- word(files[i], 3, sep = "_") 
  }
  if (str_count(files[i], '_') == 2) {
    if (is.na(suppressWarnings(as.numeric(word(files[i], 2, sep = "_")))) ==  TRUE) {
      site_id_match <- paste(word(files[i], 1, sep = "_"), word(files[i], 2, sep = "_"), sep = "_")
      year_deployed_match <- substr(word(files[i], 3, sep = "_"), 1, 4)
    } else {
      site_id_match <- word(files[i], 1, sep = "_")
      year_deployed_match <- substr(word(files[i], 2, sep = "_"), 1, 4)
    }
  }      
  # if (substr(files[i], 1, 4) %in% c("DUCK", "SUNI")) {
  #   site_id_match <- word(files[i], 1, sep = "_")
  #   year_deployed_match <- word(files[i], 3, sep = "_") 
  # } else {
  #   site_id_match <- substr(files[i], 1, str_length(files[i]) - 9)
  #   year_deployed_match <- as.numeric(substr(files[i], str_length(files[i]) - 7, str_length(files[i]) - 4))
  # }
  work <- micromet_header %>% 
      dplyr::filter(survey=="postaccess" & site_id==site_id_match & year_deployed==year_deployed_match & serial_check==serial)
  check1 <- (dim(work)[1]==1)
  if (check1==TRUE) lst[[i]]$survey_id <- work$survey_id
  if (check1==FALSE) print(paste(i, files[i], serial_check, check1, sep = ", "))
  rm(serial_check)
  lst[[i]] <- lst[[i]] %>%
    mutate(datetime = mdy_hms(datetime_temp)) %>%
    dplyr::select(survey_id, datetime, temperature, relative_humidity)  
}

post_access_data_df <- do.call(what = rbind, args = lst) %>%
  dplyr::select(survey_id, datetime, temperature, relative_humidity) %>%
  arrange(survey_id, datetime) %>%
  # remove any data from lost surveys - this should be zero rows
  left_join(micromet_header %>% dplyr::select(survey_id, status), by = "survey_id") %>%
  dplyr::filter(status == "clean") %>%
  mutate(relative_humidity = replace(relative_humidity, relative_humidity=="Logged", "")) %>%
  mutate(relative_humidity = as.numeric(relative_humidity)) %>%
  dplyr::select(survey_id, datetime, temperature, relative_humidity) 
  
# make sure time zone is GMT-7
tz(post_access_data_df$datetime) <- "America/Los_Angeles"


