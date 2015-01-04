#' Get k-nearest station data, Filtered, Interpolated
#'
#' This function applies four filters:
#' 1) Remove stations with little to no data
#' 2) Remove stations that exceed a maximum distance from each city's reference point
#' 3) Remove stations that exceed a threshold of missing data, including NA values
#' 4) Select closest station remaining for each city, as all remaining stations are deemed adequate
#'
#' It then performs two steps to interpolate missing values:
#' 1) Average over all data points in original dataset to find average hourly observations
#' 2) Linearly interpolate hourly data points for missing observations
#'
#' @param city.list City of list of Cities. The format should be as follows: "City, State", or "City, Country"
#' @param station.list Full list of ISD stations included in the package
#' @param k The number of stations to return
#' @param begin Start year (4 digits)
#' @param end End year (4 digits)
#' @param distance Maximum distance allowable from each city's reference point
#' @param hourly_interval Minimum hourly interval allowable (1=hourly; 3 = every 3 hours; 6 = every 6 hours, etc..)
#' @param tolerance This is the percent, in decimals, of missing data you will allow. (.05 = 5% of total data)
#' @return Returns a single dataframe with hourly observations (including interpolated) of every city.
#' @examples
#' \dontrun{
#' data(stations)
#' cities <- c("Nairobi, Kenya", "Tema, Ghana", "Accra, Ghana", "Abidjan, Ivory Coast")
#' hourly.data <- getInterpolatedDataByCity(cities, station.list, 5, 2010, 2013, 100, 3, .05)
#' dim(hourly.data)
#' }
#' @export


getInterpolatedDataByCity <- function(city.list, station.list, k=5, begin, end, distance=100, hourly_interval=3, tolerance=.05)
{
  kns <- kNStations(city.list, station.list, k)
  weatherDFs <- dlStationData(kns, begin, end)
  combined.list <- combineWeatherDFs(weatherDFs)
  filteredData <- filterStationData(combined.list, distance, hourly_interval, tolerance, begin, end)
  interpolation <- interpolateData(filteredData$station_data)
  return(interpolation)
}
