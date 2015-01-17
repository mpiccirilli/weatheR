#' Get the k-nearest weather stations to a city
#'
#' Using either an individual city or a list of cities, this will find a reference point for each location
#' and return the k-nearest weather stations to that reference point.
#'
#' @param city.list List of cities. Format should be: "City, State", or "City, Country"
#' @param station.list Full list of ISD stations included in the package
#' @param k The number of stations to return
#' @return Returns the k-nearest weather stations in the full ISD station.list
#' @examples
#' \dontrun{
#' data(stations)
#' cities <- c("Nairobi, Kenya", "Tema, Ghana", "Accra, Ghana", "Abidjan, Ivory Coast")
#' k.n.stations <- kNStations(cities, station.list, 5)
#' }
#' @export

kNStations <- function(city.list, station.list, k = 5)
{
  coords <- suppressMessages(geocode(city.list))
  kns.ix <- NULL
  kns.dist <- NULL
  for(i in 1:length(city.list))
  {
    dist <- gcd.slc(coords$lon[i], coords$lat[i], station.list$LON, station.list$LAT)
    distSort <- sort(dist, ind=TRUE)
    tmp.ix <- distSort$ix[1:k]
    tmp.dist <- distSort$x[1:k]
    kns.ix <- c(kns.ix, tmp.ix)
    kns.dist <- c(kns.dist, tmp.dist)
  }
  st <- station.list[kns.ix,]
  st$city <- rep(city.list, each=k) # Reference City
  st$Ref_Lat <- rep(coords$lat,each=k) # Reference Latitude
  st$Ref_Lon <- rep(coords$lon, each=k) # Reference Longitude

  st$kilo_distance <- kns.dist
  st <- st[with(st,order(city, kilo_distance)),]
  st$rank <- rep(1:k,length(city.list)) # Rank is list from 1-k, closest to farthest
  st$BEGIN_Year <- as.numeric(substr(st$BEGIN,1,4))
  st$END_Year <- as.numeric(substr(st$END, 1, 4))
  return(st)
}
