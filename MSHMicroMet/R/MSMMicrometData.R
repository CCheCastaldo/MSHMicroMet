#' Mount St. Helens microscale meteorology data
#'
#' A data frame containing microscale temperature and relative humidity measurements on Mount St. Helens
#' collected by the US Forest Service Pacific Northwest Research Station from 1997-2022
#'
#' @format A data frame with 4220521 rows and 4 variables:
#' \describe{
#'   \item{survey_id}{unique identifer for each  HOBO sensor deployment}
#'   \item{datetime}{date and time of HOBO sensor reading (UTC-7/Pacific Daylight Time)}
#'   \item{temperature}{sensor temperature reading, C}
#'   \item{relative_humidity}{sensor relative humidity reading, if applicable}
#' }
#'
"MSHMicrometData"
