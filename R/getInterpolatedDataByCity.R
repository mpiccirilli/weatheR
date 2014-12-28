#' Get k-nearest station data, Filtered, Interpolated
#'
#'
#' This function utilizes the kNStation() function to find the k-nearest stations,
#' and downloads all the data for those stations in between a given date range (in years). It then applies
#' four filters:
#'
#' 1) Remove stations with little to no data
#' 2) Remove stations that exceed a maximum distance from each city's reference point
#' 3) Remove stations that exceed a threshold of missing data, including NA values
#' 4) Select closest station remaining for each city, as all remaining stations are deemed adequate
#'
#' The analysis this package was created for requires hourly weather observations,
#' so this function performs the following two steps:
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
#' @export


getInterpolatedDataByCity <- function(city.list, station.list, k=NULL, begin, end, distance=NULL, hourly_interval=NULL, tolerance=NULL)
{
  if(is.null(k)) k <- 5   # Defaults to 5 stations
  if(is.null(distance)) distance <- 100   # Default: stations to be w/in 100 Kilometers
  if(is.null(hourly_interval)) hourly_interval <- 3   # Default min observations set to every 3 hours
  if(is.null(tolerance)) tolerance <- .05  # Default tolerance set to allow 5% missing values

  kns <- kNStations(city.list, station.list, k)
  weatherDFs <- dlStationData(kns, begin, end)
  combined.list <- combineWeatherDFs(weatherDFs)
  filteredData <- filterStationData(combined.list, distance, hourly_interval, tolerance, begin, end)
  interpolation <- interpolateData(filteredData$station_data)
  return(interpolation)
}
