getAllStationsDataByCity <- function(city.list, station.list, k, begin, end)
{  
  kns <- kNStations(city.list, station.list, k)
  weatherDFs <- dlStationData(kns, begin, end)
  combined.list <- combineWeatherDFs(weatherDFs)
  # Return a list of length two
  # 1) The result of downloading each year of each station
  # 2) A list of combined station data
  return(combined.list) 
}
