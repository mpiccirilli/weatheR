#' Get the k-nearest weather stations to a city
#'
#' Using either an individual city or a list of cities, this will find a reference point for each location
#' and return the k-nearest weather stations to that reference point.
#'
#' @param city.list City of list of Cities. The format should be as follows: "City, State", or "City, Country"
#' @param station.list Full list of ISD stations included in the package
#' @param k The number of stations to return
#' @return Returns the k-nearest weather stations in the full ISD station.list
#' @examples
#' \dontrun{
#' 
#' data(stations) #called in as 'station.list'
#' cities <- c("Nairobi, Kenya", "Tema, Ghana", "Accra, Ghana", "Abidjan, Ivory Coast")
#' k.n.stations <- kNStations(cities, station.list, 5)
#' }
#' @export

kNStations <- function(city.list, station.list, k = 5)
{
  coords <- suppressMessages(geocode(city.list))
  # Find k-nearest weather stations to the reference point
  kns <- get.knnx(as.matrix(station.list[,c(8,7)]),as.matrix(coords), k)
  st <- station.list[kns$nn.index[,],]
  # Add additional fields to the dataset
  st$city <- rep(city.list,nrow(st)/nrow(coords)) # Reference City
  st$Ref_Lat <- rep(coords$lat,nrow(st)/nrow(coords)) # Reference Latitude
  st$Ref_Lon <- rep(coords$lon, nrow(st)/nrow(coords)) # Reference Longitude
  kilos.per.mile <- 1.60934
  st$kilo_distance <- geodistance(st$Ref_Lon,st$Ref_Lat,st$LON,st$LAT,
                                  dcoor = FALSE)$dist*kilos.per.mile # Convert miles to kilos
  st <- st[with(st,order(city, kilo_distance)),]
  st$rank <- rep(1:k,length(city.list)) # Rank is list from 1-k, closest to farthest
  st$BEGIN_Year <- as.numeric(substr(st$BEGIN,1,4))
  st$END_Year <- as.numeric(substr(st$END, 1, 4))
  # st <- st[st$BEGIN_Date <= beg & st$END_Date >= end, ] # remove stations without complete data
  return(st)
}
