getStationByID <- function(station_id, begin_year, end_year)
{
  
}

dlStationData <- function(kns, beg, end)
{
  base.url <- "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/"
  nstations <- nrow(kns)
  yrs <- seq(beg,end,1)
  nyrs <- end-beg+1
  usaf <- as.numeric(kns$USAF)
  wban <- as.numeric(kns$WBAN)
  # The following dataframe will be printed to show 
  # which files were successfully downloaded
  status <- data.frame()
  temp <- as.data.frame(matrix(NA,nstations,5)) 
  names(temp) <- c("File","Status", "City", "rank", "kilo_distance")
  temp$City <- kns$city
  temp$rank <- kns$rank
  temp$kilo_distance <- kns$kilo_distance
  # Setup for the list of data
  temp.list <- df.list <- list()
  city.names <- unlist(lapply(strsplit(kns$city,", "), function(x) x[1])) # City Name
  df.names <- paste(city.names, kns$USAF, sep="_") # City Name_USAF#
  
  # Download the desired stations into a list (does not save to disk)
  for (i in 1:nyrs)
  {
    for (j in 1:nstations)
    {
      # Create file name
      temp[j,1] <- paste(usaf[j],"-",wban[j],"-", yrs[i], ".gz", sep = "")
      tryCatch({
        # Create connect to the .gz file
        gz.url <- paste(base.url, yrs[i], "/", temp[j, 1], sep="")
        con <- gzcon(url(gz.url))
        raw <- textConnection(readLines(con))
        # Read the .gz file directly into R without saving to disk
        temp.list[[j]] <- read.fwf(raw, col.width)
        close(con)
        # Some housekeeping:
        names(temp.list)[j] <- df.names[j]
        names(temp.list[[j]]) <- col.names
        temp.list[[j]]$LAT <- temp.list[[j]]$LAT/1000
        temp.list[[j]]$LONG <- temp.list[[j]]$LONG/1000
        temp.list[[j]]$WIND.SPD <- temp.list[[j]]$WIND.SPD/10
        temp.list[[j]]$TEMP <- temp.list[[j]]$TEMP/10
        temp.list[[j]]$DEW.POINT <- temp.list[[j]]$DEW.POINT/10
        temp.list[[j]]$ATM.PRES <- temp.list[[j]]$ATM.PRES/10
        temp.list[[j]]$city <- city.names[j]
        temp.list[[j]]$distance <- kns$kilo_distance[j]
        temp.list[[j]]$rank <- kns$rank[j]
        temp[j,2] <- "Success" 
      },
      error=function(cond)
      {
        return(NA)
        next
      },
      finally={ # if any of the files didn't download successfully, label as such
        if(is.na(temp[j,2])=="TRUE") temp[j,2] <- "Failed"
      })
    }
    # Combine each year's status and list
    status <- rbind(status, temp)
    status <- status[order(status[,3], status[,4], status[,1]),]
    df.list <- append(df.list, temp.list)
  }
  output.list <- list(status, df.list)
  return(output.list)
}



test <- list(1, 2, 3);
names(test) <- c('a', 'b', 'c')
test$