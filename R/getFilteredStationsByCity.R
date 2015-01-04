#' Get k-nearest station data, Filtered
#'
#' This function returns 1 station for each city, after applying four filters:
#' 1) Remove stations with little to no data
#' 2) Remove stations that exceed a maximum distance from each city's reference point
#' 3) Remove stations that exceed a threshold of missing data, including NA values
#' 4) Select closest station remaining for each city, as all remaining stations are deemed adequate
#'
#' @param city.list City of list of Cities. The format should be as follows: "City, State", or "City, Country"
#' @param station.list Full list of ISD stations included in the package
#' @param k The number of stations to return
#' @param begin Start year (4 digits)
#' @param end End year (4 digits)
#' @param distance Maximum distance allowable from each city's reference point
#' @param hourly_interval Minimum hourly interval allowable (1=hourly; 3 = every 3 hours; 6 = every 6 hours, etc..)
#' @param tolerance This is the percent, in decimals, of missing data you will allow. (.05 = 5\% of total data)
#' @return Returns a list of four items.
#'     1) Download status.
#'     2) Number of downlaoded, removed, and kept stations
#'     3) Names of final stations
#'     2) A list of dataframes for each station.
#' @examples
#' \dontrun{
#' data(stations)
#' cities <- c("Nairobi, Kenya", "Tema, Ghana", "Accra, Ghana", "Abidjan, Ivory Coast")
#' get.stations <- getFilteredStationsByCity(cities, station.list, begin = 2012, end = 2013)
#' get.stations$dl_status
#' get.stations$removed_rows
#' get.stations$station_names_final
#'
#' class(get.stations$station_data)
#' length(get.stations$station_data)
#' }
#' @export


getFilteredStationsByCity <- function(city.list, station.list, k=NULL, begin, end, distance=100, hourly_interval=3, tolerance=.05)
{
  kns <- kNStations(city.list, station.list, k)
  weatherDFs <- dlStationData(kns, begin, end)
  combined.list <- combineWeatherDFs(weatherDFs)
  filteredData <- filterStationData(combined.list, distance, hourly_interval, tolerance, begin, end)
  return(filteredData)
}
