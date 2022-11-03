spirit_lake_locations_df <- read_excel("AccessMigration/SpiritLakeLocations.xlsx") %>%
  mutate(terrestrial = FALSE, zone = "Spirit Lake", site_description = NA) %>%
  mutate(site_description = replace(site_description, site_id == 'SUNISL', 'Sunken Island')) %>%
  mutate(site_description = replace(site_description, site_id == 'DUCKBE', 'Duck Bay East')) %>%
  mutate(site_description = replace(site_description, site_id == 'DUCKBW', 'Duck Bay West')) %>%
  dplyr::select(site_id, site_description, terrestrial, zone, easting, northing)
  

