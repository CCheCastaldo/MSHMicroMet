# geolocate all stream hobo installations

stream_locations_df <-
  read_excel("access_migration/StreamTributaryLocations.xlsx") %>%
  mutate(easting = round(easting), northing = round(northing)) %>%
  mutate(terrestrial = FALSE) %>%
  dplyr::select(survey_id_legacy,
    site_id,
    site_description,
    terrestrial,
    zone,
    easting,
    northing)
