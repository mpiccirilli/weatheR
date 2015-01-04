#' Get k-nearest station data
#'
#' This function utilizes the kNStation() function to find the k-nearest stations,
#' and downloads all the data for those stations in between a given date range (in years).
#'
#' @param city.list City of list of Cities. The format should be as follows: "City, State", or "City, Country"
#' @param station.list Full list of ISD stations included in the package
#' @param k The number of stations to return
#' @param begin Start year (4 digits)
#' @param end End year (4 digits)
#' @return Returns a list of two items.
#'
#'     1) Status of downloading each year's data for each station
#'     2) A list of dataframes.  Each dataframe is all years data of a particular station.
#'
#' @examples
#' \dontrun{
#' data(stations)
#' cities <- c("Nairobi, Kenya", "Tema, Ghana", "Accra, Ghana", "Abidjan, Ivory Coast")
#' get.stations <- getStationsByCity(cities, station.list, begin = 2012, end = 2013)
#' get.stations$dl_status
#' class(get.stations$station_data)
#' length(get.stations$station_data)
#' }
#' @export


getStationsByCity <- function(city.list, station.list, k = 5, begin, end)
{
  kns <- kNStations(city.list, station.list, k)
  weatherDFs <- dlStationData(kns, begin, end)
  combined.list <- combineWeatherDFs(weatherDFs)
  # Return a list of length two
  # 1) The result of downloading each year of each station
  # 2) A list of combined station data
  return(combined.list)
}
