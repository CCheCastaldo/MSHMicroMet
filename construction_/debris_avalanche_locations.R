pond_aquatic_locations_df <-
  readRDS(file = "spatial_objects/ponds_smooth_sf.rds") %>%
  st_transform(32610) %>%
  rename(site_id = pond_id) %>%
  mutate(point = st_centroid(geometry_smooth)) %>%
  mutate(terrestrial = FALSE,
    zone = "debris avalanche",
    site_description = NA) %>%
  mutate(site_description = replace(site_description, site_id == 'H01', 'Hummocks pond H01')) %>%
  mutate(site_description = replace(site_description, site_id == 'H02A', 'Hummocks pond H02A')) %>%
  mutate(site_description = replace(site_description, site_id == 'H02B', 'Hummocks pond H02B')) %>%
  mutate(site_description = replace(site_description, site_id == 'H03A', 'Hummocks pond H03A')) %>%
  mutate(site_description = replace(site_description, site_id == 'H03B', 'Hummocks pond H03B')) %>%
  mutate(site_description = replace(site_description, site_id == 'H04', 'Hummocks pond H04')) %>%
  mutate(site_description = replace(site_description, site_id == 'H05', 'Hummocks pond H05')) %>%
  mutate(site_description = replace(site_description, site_id == 'H06', 'Hummocks pond H06')) %>%
  mutate(site_description = replace(site_description, site_id == 'H07', 'Hummocks pond H07')) %>%
  mutate(site_description = replace(site_description, site_id == 'H08', 'Hummocks pond H08')) %>%
  mutate(site_description = replace(site_description, site_id == 'H09', 'Hummocks pond H09')) %>%
  mutate(site_description = replace(site_description, site_id == 'H10', 'Hummocks pond H10')) %>%
  mutate(site_description = replace(site_description, site_id == 'H11', 'Hummocks pond H11')) %>%
  mutate(site_description = replace(site_description, site_id == 'H12', 'Hummocks pond H12')) %>%
  mutate(site_description = replace(site_description, site_id == 'H13', 'Hummocks pond H13')) %>%
  mutate(site_description = replace(site_description, site_id == 'H14', 'Hummocks pond H14')) %>%
  mutate(site_description = replace(site_description, site_id == 'H15', 'Hummocks pond H15')) %>%
  mutate(site_description = replace(site_description, site_id == 'H16', 'Hummocks pond H16')) %>%
  mutate(site_description = replace(site_description, site_id == 'H17', 'Hummocks pond H17')) %>%
  mutate(site_description = replace(site_description, site_id == 'H18', 'Hummocks pond H18')) %>%
  mutate(site_description = replace(site_description, site_id == 'H19', 'Hummocks pond H19')) %>%
  mutate(site_description = replace(site_description, site_id == 'H20', 'Hummocks pond H20')) %>%
  mutate(site_description = replace(site_description, site_id == 'H21', 'Hummocks pond H21')) %>%
  mutate(site_description = replace(site_description, site_id == 'H22', 'Hummocks pond H22')) %>%
  mutate(site_description = replace(site_description, site_id == 'H23', 'Hummocks pond H23')) %>%
  mutate(site_description = replace(site_description, site_id == 'H24', 'Hummocks pond H24')) %>%
  mutate(site_description = replace(site_description, site_id == 'H25', 'Hummocks pond H25')) %>%
  mutate(site_description = replace(site_description, site_id == 'H26', 'Hummocks pond H26')) %>%
  mutate(site_description = replace(site_description, site_id == 'H27', 'Hummocks pond H27')) %>%
  mutate(site_description = replace(site_description, site_id == 'H28', 'Hummocks pond H28')) %>%
  mutate(site_description = replace(site_description, site_id == 'H29', 'Hummocks pond H29')) %>%
  mutate(site_description = replace(site_description, site_id == 'H30', 'Hummocks pond H30')) %>%
  mutate(site_description = replace(site_description, site_id == 'H31', 'Hummocks pond H31')) %>%
  mutate(site_description = replace(site_description, site_id == 'H32', 'Hummocks pond H32')) %>%
  mutate(site_description = replace(site_description, site_id == 'H33', 'Hummocks pond H33')) %>%
  mutate(site_description = replace(site_description, site_id == 'H34', 'Hummocks pond H34')) %>%
  mutate(site_description = replace(site_description, site_id == 'H35', 'Hummocks pond H35')) %>%
  mutate(site_description = replace(site_description, site_id == 'H36', 'Hummocks pond H36')) %>%
  mutate(site_description = replace(site_description, site_id == 'H37', 'Hummocks pond H37')) %>%
  mutate(site_description = replace(site_description, site_id == 'H38', 'Hummocks pond H38')) %>%
  mutate(site_description = replace(site_description, site_id == 'H39', 'Hummocks pond H39')) %>%
  mutate(site_description = replace(site_description, site_id == 'H40', 'Hummocks pond H40')) %>%
  mutate(site_description = replace(site_description, site_id == 'H41', 'Hummocks pond H41')) %>%
  mutate(site_description = replace(site_description, site_id == 'H42', 'Hummocks pond H42')) %>%
  mutate(site_description = replace(site_description, site_id == 'H43', 'Hummocks pond H43')) %>%
  mutate(site_description = replace(site_description, site_id == 'H44', 'Hummocks pond H44')) %>%
  mutate(site_description = replace(site_description, site_id == 'H45', 'Hummocks pond H45')) %>%
  mutate(site_description = replace(site_description, site_id == 'H46', 'Hummocks pond H46')) %>%
  mutate(site_description = replace(site_description, site_id == 'H47', 'Hummocks pond H47')) %>%
  mutate(site_description = replace(site_description, site_id == 'H48', 'Hummocks pond H48')) %>%
  mutate(site_description = replace(site_description, site_id == 'H49', 'Hummocks pond H49')) %>%
  mutate(site_description = replace(site_description, site_id == 'H50', 'Hummocks pond H50')) %>%
  mutate(site_description = replace(site_description, site_id == 'H51', 'Hummocks pond H51')) %>%
  mutate(site_description = replace(site_description, site_id == 'H52', 'Hummocks pond H52')) %>%
  mutate(site_description = replace(site_description, site_id == 'H53', 'Hummocks pond H53')) %>%
  mutate(site_description = replace(site_description, site_id == 'H55', 'Hummocks pond H55')) %>%
  mutate(site_description = replace(site_description, site_id == 'H56', 'Hummocks pond H56')) %>%
  mutate(site_description = replace(site_description, site_id == 'M01', 'Maratta pond M01')) %>%
  mutate(site_description = replace(site_description, site_id == 'M02', 'Maratta pond M02')) %>%
  mutate(site_description = replace(site_description, site_id == 'M03', 'Maratta pond M03')) %>%
  mutate(site_description = replace(site_description, site_id == 'M04', 'Maratta pond M04')) %>%
  mutate(site_description = replace(site_description, site_id == 'M05', 'Maratta pond M05')) %>%
  mutate(site_description = replace(site_description, site_id == 'M06', 'Maratta pond M06')) %>%
  mutate(site_description = replace(site_description, site_id == 'M07', 'Maratta pond M07')) %>%
  mutate(site_description = replace(site_description, site_id == 'M08', 'Maratta pond M08')) %>%
  mutate(site_description = replace(site_description, site_id == 'M09', 'Maratta pond M09')) %>%
  mutate(site_description = replace(site_description, site_id == 'M10', 'Maratta pond M10')) %>%
  mutate(site_description = replace(site_description, site_id == 'M11', 'Maratta pond M11')) %>%
  mutate(site_description = replace(site_description, site_id == 'M13', 'Maratta pond M13')) %>%
  mutate(site_description = replace(site_description, site_id == 'M15', 'Maratta pond M15')) %>%
  mutate(site_description = replace(site_description, site_id == 'M17', 'Maratta pond M17')) %>%
  mutate(site_description = replace(site_description, site_id == 'M20', 'Maratta pond M20')) %>%
  mutate(site_description = replace(site_description, site_id == 'M21', 'Maratta pond M21')) %>%
  mutate(site_description = replace(site_description, site_id == 'M22', 'Maratta pond M22')) %>%
  mutate(site_description = replace(site_description, site_id == 'M23', 'Maratta pond M23')) %>%
  mutate(site_description = replace(site_description, site_id == 'M24', 'Maratta pond M24')) %>%
  mutate(site_description = replace(site_description, site_id == 'M25', 'Maratta pond M25')) %>%
  mutate(site_description = replace(site_description, site_id == 'M26', 'Maratta pond M26')) %>%
  mutate(site_description = replace(site_description, site_id == 'M27', 'Maratta pond M27')) %>%
  mutate(site_description = replace(site_description, site_id == 'M28', 'Maratta pond M28')) %>%
  mutate(site_description = replace(site_description, site_id == 'M29', 'Maratta pond M29')) %>%
  mutate(site_description = replace(site_description, site_id == 'M30', 'Maratta pond M30')) %>%
  mutate(site_description = replace(site_description, site_id == 'M31', 'Maratta pond M31')) %>%
  mutate(site_description = replace(site_description, site_id == 'M32', 'Maratta pond M32')) %>%
  mutate(site_description = replace(site_description, site_id == 'M34', 'Maratta pond M34')) %>%
  mutate(site_description = replace(site_description, site_id == 'M35', 'Maratta pond M35')) %>%
  mutate(site_description = replace(site_description, site_id == 'M36', 'Maratta pond M36')) %>%
  mutate(site_description = replace(site_description, site_id == 'M40', 'Maratta pond M40')) %>%
  mutate(site_description = replace(site_description, site_id == 'M41', 'Maratta pond M41')) %>%
  mutate(site_description = replace(site_description, site_id == 'M42', 'Maratta pond M42')) %>%
  mutate(site_description = replace(site_description, site_id == 'M43', 'Maratta pond M43')) %>%
  mutate(site_description = replace(site_description, site_id == 'M44', 'Maratta pond M44')) %>%
  mutate(site_description = replace(site_description, site_id == 'M45', 'Maratta pond M45')) %>%
  mutate(site_description = replace(site_description, site_id == 'M46', 'Maratta pond M46')) %>%
  mutate(site_description = replace(site_description, site_id == 'M47A', 'Maratta pond M47A')) %>%
  mutate(site_description = replace(site_description, site_id == 'M47B', 'Maratta pond M47B')) %>%
  mutate(site_description = replace(site_description, site_id == 'M47C', 'Maratta pond M47C')) %>%
  mutate(site_description = replace(site_description, site_id == 'M48', 'Maratta pond M48')) %>%
  mutate(site_description = replace(site_description, site_id == 'M49', 'Maratta pond M49')) %>%
  mutate(site_description = replace(site_description, site_id == 'M50', 'Maratta pond M50')) %>%
  mutate(site_description = replace(site_description, site_id == 'M51', 'Maratta pond M51')) %>%
  mutate(site_description = replace(site_description, site_id == 'M52', 'Maratta pond M52')) %>%
  mutate(site_description = replace(site_description, site_id == 'M53', 'Maratta pond M53')) %>%
  mutate(site_description = replace(site_description, site_id == 'M54', 'Maratta pond M54')) %>%
  mutate(site_description = replace(site_description, site_id == 'M55', 'Maratta pond M55')) %>%
  mutate(site_description = replace(site_description, site_id == 'MARALK', 'Maratta Lake')) %>%
  mutate(easting = round(st_coordinates(point)[, 1]),
    northing = round(st_coordinates(point)[, 2])) %>%
  as.data.frame() %>%
  dplyr::select(site_id, terrestrial, site_description, zone, easting, northing)

pond_terrestrial_locations_df  <-
  readRDS(file = "spatial_objects/ponds_rebar_sf.rds") %>%
  st_transform(32610) %>%
  rename(site_id = pond_id) %>%
  dplyr::filter(site_id %in% c("H25", "M10", "H10", "M54")) %>%
  mutate(terrestrial = TRUE,
    zone = "debris avalanche",
    site_description = NA) %>%
  mutate(site_description = replace(site_description, site_id == 'H10', 'Hummocks pond H10 rebar')) %>%
  mutate(site_description = replace(site_description, site_id == 'H25', 'Hummocks pond H25 rebar')) %>%
  mutate(site_description = replace(site_description, site_id == 'M10', 'Maratta pond M10 rebar')) %>%
  mutate(site_description = replace(site_description, site_id == 'M54', 'Maratta pond M54 rebar')) %>%
  mutate(easting = round(st_coordinates(rebar)[, 1]),
    northing = round(st_coordinates(rebar)[, 2])) %>%
  as.data.frame() %>%
  dplyr::select(site_id, terrestrial, site_description, zone, easting, northing)

pond_locations_df <-
  rbind(pond_aquatic_locations_df, pond_terrestrial_locations_df)