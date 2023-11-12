#--------------------------------------------------------------------------------------------------------------------------------------
# Pumice Plain coordinates are in WGS84 UTM 10N

terrestrial_locations_pp_df <-
  read_excel("access_migration/TerrestrialLocations.xlsx") %>%
  dplyr::filter(!(
    site_id %in% c("REFFOR", "REFCUT", "TEPFOR", "TEPCUT", "BLDFOR", "BLDCUT")
  )) %>%
  mutate(easting = round(utm_E), northing = round(utm_N))

terrestrial_locations_pp_sf <-
  st_as_sf(
    terrestrial_locations_pp_df,
    coords = c("easting", "northing"),
    crs = st_crs(32610)
  ) %>%
  mutate(terrestrial = TRUE, zone = "pyroclastic flow") %>%
  mutate(site_description = replace(site_description, site_id == 'BSTCRK', 'Basalt Creek Riparian')) %>%
  mutate(site_description = replace(site_description, site_id == 'FORCRK', 'Forsyth Creek Riparian')) %>%
  mutate(site_description = replace(site_description, site_id == 'FORUPL', 'Forsyth Creek Upland')) %>%
  mutate(site_description = replace(site_description, site_id == 'PMPGRN', 'Pumice Plain Greenery')) %>%
  mutate(site_description = replace(site_description, site_id == 'PMPWEB', 'Pumice Plain Web')) %>%
  mutate(site_description = replace(site_description, site_id == 'PPCAST', 'Pumice Plain Castilleja')) %>%
  mutate(site_description = replace(site_description, site_id == 'PPULP1', 'Pumice Plain Upland #1')) %>%
  mutate(site_description = replace(site_description, site_id == 'PPUPL2', 'Pumice Plain Upland #2')) %>%
  mutate(site_description = replace(site_description, site_id == 'PPWET1', 'Pumice Plain Wetland #1')) %>%
  mutate(site_description = replace(site_description, site_id == 'PPWET2', 'Pumice Plain Wetland #2')) %>%
  mutate(site_description = replace(site_description, site_id == 'RDRCRK', 'Red Rock Creek Riparian')) %>%
  mutate(site_description = replace(site_description, site_id == 'RDRUPL', 'Red Rock Creek Upland')) %>%
  mutate(site_description = replace(site_description, site_id == 'UPLSHS', 'Upland Shrub South')) %>%
  mutate(site_description = replace(site_description, site_id == 'UPLSNE', 'Upland Shrub Northeast')) %>%
  mutate(site_description = replace(site_description, site_id == 'UPLSNW', 'Upland Shrub Northwest')) %>%
  mutate(site_description = replace(site_description, site_id == 'WILSPR', 'Willow Springs Riparian')) %>%
  mutate(site_description = replace(site_description, site_id == 'WILSPU', 'Willow Springs Upland')) %>%
  dplyr::select(site_id, site_description, terrestrial, zone)

#--------------------------------------------------------------------------------------------------------------------------------------
# Blowdown and reference coordinates are in NAD27 UTM10N

terrestrial_locations_bd_df <- st_as_sf(read_excel("access_migration/TerrestrialLocations.xlsx") %>%
  dplyr::filter(site_id %in% c("REFFOR", "REFCUT", "TEPFOR", "TEPCUT", "BLDFOR", "BLDCUT")),
    coords = c("utm_E", "utm_N"), crs = st_crs(26710)) %>%
  st_transform(32610) %>%
  mutate(easting = round(st_coordinates(.)[, 1]), northing = round(st_coordinates(.)[, 2])) %>%
  as.data.frame() %>%
  dplyr::select(-geometry)

terrestrial_locations_bd_sf <- st_as_sf(terrestrial_locations_bd_df, 
  coords = c("easting", "northing"), crs = st_crs(32610)) %>%
  mutate(terrestrial = TRUE, zone = "blowdown") %>%
  mutate(zone = replace(zone, site_id %in% c("REFCUT", "REFFOR"), "reference")) %>%
  mutate(zone = replace(zone, site_id %in% c("TEPCUT", "TEPFOR"), "tephra fall")) %>%
  mutate(site_description = replace(site_description, site_id == 'BLDCUT', 'Blowdown Clearcut')) %>%
  mutate(site_description = replace(site_description, site_id == 'BLDFOR', 'Blowdown Forest')) %>%
  mutate(site_description = replace(site_description, site_id == 'REFCUT', 'Reference Clearcut')) %>%
  mutate(site_description = replace(site_description, site_id == 'REFFOR', 'Reference Forest')) %>%
  mutate(site_description = replace(site_description, site_id == 'TEPCUT', 'Tephra Clearcut')) %>%
  mutate(site_description = replace(site_description, site_id == 'TEPFOR', 'Tephra Forest')) %>%
  dplyr::select(site_id, site_description, terrestrial, zone)

terrestrial_locations_df <-
  rbind(terrestrial_locations_bd_sf, terrestrial_locations_pp_sf) %>%
  mutate(easting = round(st_coordinates(geometry)[, 1]), northing = round(st_coordinates(geometry)[, 2])) %>%
  as.data.frame() %>%
  dplyr::select(site_id, site_description, terrestrial, zone, easting, northing)
