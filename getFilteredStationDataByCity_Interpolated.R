getFilteredStationsDataByCity_Interpolated <- function(city.list, station.list, k, begin, end, distance, hourly_interval, tolerance)
{
  kns <- kNStations(city.list, station.list, k)
  weatherDFs <- dlStationData(kns, begin, end)
  combined.list <- combineWeatherDFs(weatherDFs)
  filteredData <- filterStationData(combined.list, distance, hourly_interval, tolerance, begin, end)
  interpolation <- interpolateData(filteredData$station_data)
  return(interpolation) 
}
