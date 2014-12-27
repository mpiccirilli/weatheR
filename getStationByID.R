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
