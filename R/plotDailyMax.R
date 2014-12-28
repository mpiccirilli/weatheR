#' Plot Daily Max Temp for Multiple Cities
#'
#' This function will plot the daily max temperature of one or multiple cities
#' over time.
#'
#' This function requires that the dataframe fed into the funciton have columns named 'TEMP' for temperature,
#' 'city' for the city or identifier, 'YR' for the year, 'M' for month, and 'D' for the day.
#'
#' @param hourlyDF Must be a dataframe with columns for TEMP, city, YR, M, and D
#' @export

plotDailyMax <- function(hourlyDF)
{
  d.max <- aggregate(TEMP ~ city + YR + M + D, hourlyDF, max)
  d.max <- d.max[with(d.max, order(city, YR, M, D)),]
  d.max$day <- as.POSIXct(paste(d.max$YR, d.max$M, d.max$D,sep="-"),format="%Y-%m-%d")
  p1 <- ggplot(d.max, aes(x=day, y=TEMP)) + geom_point() + facet_grid(city ~.)
  plot(p1)
}

