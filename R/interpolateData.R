#' Interpolate Weather Station Data
#'
#' This function takes in a list object of one or more data frames and will return
#' a data frame with hourly observations, with missing observations linearly interpolated
#'
#' @param station_data List object of weather data
#' @return This will return a list object with two elements: 1) The percentage number and percentage of interpolated values for each weather station; 2) A list of dataframes for each station.
#' @examples
#' \dontrun{
#' data(stations)
#' }
#' @export



interpolateData <- function(wx.list)
{
  clean.list <- lapply(wx.list, function(x) {
    aggregate(cbind(LAT, LONG, ELEV, TEMP, DEW.POINT) ~
                city + USAFID + distance + rank + YR + M + D + HR, data=x, mean)
  })

  # Create a column with the full posix date for each hour
  for (i in 1:length(clean.list))
  {
    clean.list[[i]]$dates <- as.POSIXct(paste(paste(clean.list[[i]]$YR,"-",clean.list[[i]]$M,
                              "-",clean.list[[i]]$D, " ",clean.list[[i]]$HR,sep=""),
                              ":",0,":",0,sep=""),"%Y-%m-%d %H:%M:%S", tz="UTC")
  }

  # Create a list of dataframes of each hour
  hourly.list <- list()
  for (i in 1:length(clean.list))
  {
    hourly.list[[i]] <- data.frame(hours=seq(
      from=as.POSIXct(paste(min(clean.list[[i]]$YR),"-1-1 0:00", sep=""), tz="UTC"),
      to=as.POSIXct(paste(max(clean.list[[i]]$YR),"-12-31 23:00", sep=""), tz="UTC"),
      by="hour"))
  }

  out.list <- list()
  for (i in 1:length(clean.list))
  {
    temp.df <- merge(hourly.list[[i]], clean.list[[i]], by.x="hours", by.y="dates", all.x=TRUE)
    temp.df$city <- unique(na.omit(temp.df$city))[1]
    temp.df$USAFID <- unique(na.omit(temp.df$USAFID))[1]
    temp.df$distance <- unique(na.omit(temp.df$distance))[1]
    temp.df$rank <- unique(na.omit(temp.df$rank))[1]
    temp.df$LAT <- unique(na.omit(temp.df$LAT))[1]
    temp.df$LONG <- unique(na.omit(temp.df$LONG))[1]
    temp.df$ELEV <- unique(na.omit(temp.df$ELEV))[1]
    temp.df$YR <- as.numeric(format(temp.df$hours,"%Y"))
    temp.df$M <- as.numeric(format(temp.df$hours,"%m"))
    temp.df$D <- as.numeric(format(temp.df$hours,"%d"))
    temp.df$HR <- as.numeric(format(temp.df$hours,"%H"))

    # Interpolation
    temp.int <- approx(x=temp.df$hours, y=temp.df$TEMP, xout=temp.df$hours)
    temp.df$TEMP <- temp.int$y

    dew.int <- approx(x = temp.df$hours, y = temp.df$DEW.POINT, xout = temp.df$hours)
    temp.df$DEW.POINT <- dew.int$y

    df.name <- unique(paste0(temp.df$city,"_",temp.df$USAFID))
    temp.list <- list(temp.df)
    names(temp.list) <- df.name

    # Merge the dataframes together
    out.list <- c(out.list, temp.list)
  }
  return(out.list)
}
