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

The following function plots the k-nearest weather stations to a city's reference point.  The black dots are the reference points, and the red dots are the stations, ordered from 1 to *k* by closeness. I have included *k* in the function, however it is an optional parameter that will default to 5. 


```{r, message=FALSE, warning=FALSE}
plotStations(cities, station.list, 5)
```
![cityPlot](https://github.com/mpiccirilli/weatheR/blob/master/cityPlot.png)

Now let's download the station data.  

The following example uses the function that will filter though the k-nearest weather stations, selecting the best one based on the number of missing observations and proximity to each city's reference point (black dots in plot above). It will then average the hourly observations and interpolate any missing values. 

```{r, eval=FALSE}
hourly.data <- getInterpolatedDataByCity(cities, station.list, 5, 2010, 2013, 100, 3, .05)
```

In addition to the list of stations and cities, we have also included several other parameters to help us select the best station between a given date range.  The parameters include: 

- k-nearst stations we would like to select (optional; default=5)
- beginning date (required; 4-digit year)
- end date (required; 4-digit year)
- max distance in kilometers away from a location to consider (optional; default=100) 
- minimum hourly interval of observations. ex, 1 = hourly, 3 = every three hours, etc.. (optional; default=3)
- tolerance, which ismax percent of missing data we will allow (optional; default=.05)

Now that we have hourly observations for these 4 cities, perhaps we would like to plot the maximum daily temperature for each. 

```{r}
plotDailyMax(hourly.data)
```

![cityPlot](https://github.com/mpiccirilli/weatheR/blob/master/dailyMax.png)

We can see that the Nairobi weather station is clearly missing data for 6 months of both 2010 and and 2011.  The straight line is due to the linear interpolation performed in the prior step. 
