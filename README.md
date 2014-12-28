weatheR
=======

This package contains a set of functions to download, transform, and plot data from NOAA ISD weather stations. 

For example, you may want to:
- Find the k-nearest stations to a city, or any other location that can be found via google maps
- Plot the stations and reference point for any location
- Download all k-nearest station data to a given location for a range of years
- Select a station with the best data to a given location and interpolate missing observations

Examples
----- 

```{r}
require(devtools)
install_github("mpiccirilli/weatheR")
require(weatheR)
```


First let's call in the full list of NOAA ISD weather stations.
```{r}
data(stations) # dataset is called 'station.list'
```

Now we can create a vector of cities we would like to download weather data.

```{r}
cities <- c("Nairobi, Kenya", "Tema, Ghana", "Accra, Ghana", "Abidjan, Ivory Coast")
```

Before we download the data, we can inspect the cities to make sure there are in fact stations close to each city. If some of the stations are too far outside the area of the plot, you might receive a warning message indicating that some points have been excluded.  As you can see, this occurs below.


```{r, message=FALSE, warning=FALSE}
plotStations(cities, station.list)
```
![cityPlot](https://github.com/mpiccirilli/weatheR/blob/master/cityPlot.png)

Now let's download the station data.  

The following example uses the function that will filter though the k-nearest weather stations, selecting the best one based on the number of missing observations and proximity to each city's reference point. It will then average the hourly observations, and interpolate any missing values. 

```{r, eval=FALSE}
hourly.data <- getInterpolatedDataByCity(cities, station.list, 5, 2010, 2013, 100, 3, .05)
```

In addition to the list of stations and cities, we have also included several other parameters to help us select the best station between a given date range.  The parameters include: 

- k-nearst stations we would like to select (optional; default=5)
- beginning date (required; 4-digit year)
- end date (required; 4-digit year)
- max distance in kilometers away from a location to consider (optional; default=100) 
- minimum hourly interval of observations. ex, 1 = hourly, 3 = every three hours, etc.. (optional; default=3)
- tolerance, which max percent of missing data we will allow (optional; default=.05)


