#' Get full list of NOAA ISD stations
#'
#' This function is included in case the list of stations is updated.  The full list of stations
#' is included in the package under the name 'station.list'.
#'
#' @return This function will download the full list of NOAA ISD stations to a variable.
#' @examples
#' \dontrun{
#' list.of.stations <- allStations()
#' }
#' @export


allStations <- function()
{
  isd <- "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv"
  response <- suppressWarnings(GET(isd))
  all <- read.csv(text=content(response, "text"), header = TRUE)
  colnames(all)[c(3, 9)] <- c("NAME", "ELEV")
  all <- all[!is.na(all$LAT) & !is.na(all$LON),]
  return(all)
}
