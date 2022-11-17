#' Mount St. Helens microscale meteorology metadata
#'
#' A data frame containing metadata for microscale meteorology HOBO deployments on Mount St. Helens between 1997-2022 by the US Forest Service Pacific Northwest Research Station
#'
#' @format A data frame with 823 rows and 17 variables:
#' \describe{
#'   \item{survey_id}{unique identifier for each  HOBO sensor deployment}
#'   \item{site_id}{unique identifier for each site}
#'   \item{site_description}{short description of the site location}
#'   \item{zone}{disturbance zone where site is located}
#'   \item{decimal_longitude}{the geographic longitude in decimal degrees of the HOBO deployment}
#'   \item{decimal_latitude}{the geographic latitude in decimal degrees of the HOBO deployment}
#'   \item{geodetic_datum}{the geodetic datum upon which the geographic coordinates are based}
#'   \item{terrestrial}{boolean indicator whether HOBO is deployed in a terrestrial (TRUE) or aquatic (FALSE) environment}
#'   \item{year_deployed}{year HOBO sensor was deployed}
#'   \item{year_retrieved}{year HOBO sensor was retrieved}
#'   \item{serial}{HOBO serial number}
#'   \item{sensor_type}{HOBO series type}
#'   \item{sensor_part}{HOBO part number}
#'   \item{interval}{interval was set to record}
#'   \item{height}{height of deployment, which can be 0 (surface), positive (above ground) or negative (depth in water)}
#'   \item{deployment_datetime}{date and time of HOBO deployment (UTC-7/Pacific Daylight Time)}
#'   \item{retrieval_datetime}{ate and time of HOBO retrieval (UTC-7/Pacific Daylight Time)}
#'   \item{status}{status of deployment, can be active (HOBO is still deployed and logging), raw (HOBO was successfully retrieved but the data have yet to be manually inspected), clean (HOBO data was successfully retrieved and the data was manually inspected for errors), or lost (HOBO data is missing either thru electronic data loss or unit loss or failure)}
#'   \item{hobo}{boolean indicator whether raw .dtf. or .hobo file exists}
#' }
#'
"MSHMicrometHeader"
