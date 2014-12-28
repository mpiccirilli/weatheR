#' Get ISD station data by USAFID for a range of years
#'
#' @param stationID USAFID station number
#' @param station.list Full list of ISD stations included in the package
#' @param begin Starting *year* to download data (4 digit)
#' @param end Ending *year* to download data (4 digit)
#' @return Returns a list of two items.
#' 1) Status of downloading each year.
#' 2) Weather data in a list
#' @export



getStationByID <- function(stationID, station.list, begin, end)
{
  st <- station.list[station.list$USAF==stationID,]
  st$BEGIN_Year <- as.numeric(substr(st$BEGIN,1,4))
  st$END_Year <- as.numeric(substr(st$END, 1, 4))
  location <- suppressMessages(revgeocode(as.numeric(geocode(paste(st$NAME, st$CTRY))), output="more"))
  st$city <- paste(location$locality, location$country, sep=", ")
  st$rank <- 1

  weatherDFs <- dlStationData(st, begin, end)
  combined.list <- combineWeatherDFs(weatherDFs)
  return(combined.list)
}
