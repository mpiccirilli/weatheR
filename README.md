weatheR
=======

This package contains a set of functions to download, transform, and plot data from NOAA ISD weather stations. 

For example, you may want to:
- Find the k-nearest stations to a city, or any other location that can be found via google maps
- Plot the stations and reference point for any location
- Download all k-nearest station data to a given location for a range of years
- Select a station with the best data to a given location and interpolate missing observations

Installing via GitHub
----- 

```{r}
require(devtools)
install_github("mpiccirilli/weatheR")
require(weatheR)
```

List of Weather Stations
-----
The list of stations will be called in under the name `station.list`.  The alternative is to use the function to call in the data. 
```{r}
data(stations)
# or
station.list <- allStations()
```

Now we can create a vector of cities we would like to download weather data.  In order to search for stations by city, we need to use the following format: "city, country" or "city, state". 

```{r}
cities <- c("Nairobi, Kenya", "Tema, Ghana", "Accra, Ghana", "Abidjan, Ivory Coast")
```

kNStations
-----
This function will find the k-nearest weather stations to a given city.  It is used all the functions to find stations. 
```{r}
k.n.stations <- kNStations(cities, station.list, 5)
```


plotStations
-----
Before we download the data, we can inspect the cities to make sure there are in fact stations close to each city. If some of the stations are too far outside the area of the plot, you might receive a warning message indicating that some points have been excluded.  As you can see, this occurs below.

The following function plots the k-nearest weather stations to a city's reference point.  The black dots are the reference points, and the red dots are the stations, ordered from 1 to *k* by closeness. I have included *k* in the function, however it is an optional parameter that will default to 5 if omitted. 


```{r, message=FALSE, warning=FALSE}
plotStations(cities, station.list, 5)
```
![cityPlot](https://github.com/mpiccirilli/weatheR/blob/master/images/cityPlot.png)


Now let's download the station data.  <p>

In addition to the list of stations and cities, we have also included several other parameters to help us select the best station between a given date range.  The parameters include: <p>

- k-nearst stations we would like to select (optional; default=5)
- beginning date (required; 4-digit year)
- end date (required; 4-digit year)
- max distance in kilometers away from a location to consider (optional; default=100) 
- minimum hourly interval of observations. ex, 1 = hourly, 3 = every three hours, etc.. (optional; default=3)
- tolerance, which ismax percent of missing data we will allow (optional; default=.05)
<p>
As you will see in the examples below, I do include the optional parameters except in `getInterpolatedDataByCity`.


getStationsByCity
-----
This function will downlaod each year of data for the k-nearest stations (default = 5) for each city, so it will take some time to run.  The output of the function is a list of two:<p>
1) dl_status:  This is the status of attempting to download each year of each station.<br>
2) station_data: This is a list of dataframes with the station data<br>

```{r}
stations <- getStationsByCity(cities, station.list, begin = 2012, end = 2013)

stations$dl_status

                   File  Status                 City rank kilo_distance
1  655780-99999-2012.gz Success Abidjan, Ivory Coast    1     13.396883
21 655780-99999-2013.gz Success Abidjan, Ivory Coast    1     13.396883
2  655850-99999-2012.gz Success Abidjan, Ivory Coast    2     81.198627
22 655850-99999-2013.gz Success Abidjan, Ivory Coast    2     81.198627
3  655620-99999-2012.gz Success Abidjan, Ivory Coast    3    165.546591
23 655620-99999-2013.gz Success Abidjan, Ivory Coast    3    165.546591
4  654650-99999-2012.gz Success Abidjan, Ivory Coast    4    205.531045
24 654650-99999-2013.gz Success Abidjan, Ivory Coast    4    205.531045
5  654450-99999-2012.gz Success Abidjan, Ivory Coast    5    212.170762
25 654450-99999-2013.gz Success Abidjan, Ivory Coast    5    212.170762
6  654720-99999-2012.gz Success         Accra, Ghana    1      7.121795
26 654720-99999-2013.gz Success         Accra, Ghana    1      7.121795
7  654730-99999-2012.gz Success         Accra, Ghana    2     23.349153
27 654730-99999-2013.gz Success         Accra, Ghana    2     23.349153
8  654490-99999-2012.gz  Failed         Accra, Ghana    3     40.986341
28 654490-99999-2013.gz  Failed         Accra, Ghana    3     40.986341
9  654590-99999-2012.gz Success         Accra, Ghana    4     59.512919
29 654590-99999-2013.gz Success         Accra, Ghana    4     59.512919
10 654710-99999-2012.gz  Failed         Accra, Ghana    5     68.850839
30 654710-99999-2013.gz  Failed         Accra, Ghana    5     68.850839
11 637420-99999-2012.gz Success       Nairobi, Kenya    1      3.416254
31 637420-99999-2013.gz Success       Nairobi, Kenya    1      3.416254
12 637390-99999-2012.gz Success       Nairobi, Kenya    2      4.756458
32 637390-99999-2013.gz Success       Nairobi, Kenya    2      4.756458
13 637410-99999-2012.gz Success       Nairobi, Kenya    3      8.044960
33 637410-99999-2013.gz Success       Nairobi, Kenya    3      8.044960
14 637403-99999-2012.gz  Failed       Nairobi, Kenya    4      8.044960
34 637403-99999-2013.gz  Failed       Nairobi, Kenya    4      8.044960
15 692014-99999-2012.gz Success       Nairobi, Kenya    5     10.601511
35 692014-99999-2013.gz Success       Nairobi, Kenya    5     10.601511
16 654730-99999-2012.gz Success          Tema, Ghana    1      5.521650
36 654730-99999-2013.gz Success          Tema, Ghana    1      5.521650
17 654720-99999-2012.gz Success          Tema, Ghana    2     19.707146
37 654720-99999-2013.gz Success          Tema, Ghana    2     19.707146
18 654490-99999-2012.gz  Failed          Tema, Ghana    3     19.907417
38 654490-99999-2013.gz  Failed          Tema, Ghana    3     19.907417
19 654710-99999-2012.gz  Failed          Tema, Ghana    4     48.059678
39 654710-99999-2013.gz  Failed          Tema, Ghana    4     48.059678
20 654600-99999-2012.gz Success          Tema, Ghana    5     49.882386
40 654600-99999-2013.gz Success          Tema, Ghana    5     49.882386

class(stations$station_data)
[1] "list"
length(stations$station_data)
[1] 15
```

getFilteredStationsByCity
-------
This function is similar to `getStationsByCity` except this goes one more step and applies some filters to each of the stations so that we can select the 'best' station for each city.  So this will return only 1 station per city, instead of the k-nearest available stations. 
<p>
The output of the function is a list of four:<p>
1) dl_status:  This is the status of attempting to download each year of each station.<br>
2) removed_rows: This shows the number of stations found, removed, and kept through the filtering process. The name comes from the filtering techniques used, which are based on the number of missing observations<br>
3) station_names_final: the names of each dataframe in `station_data`. The format is: "city_USAFID"<br>
4) station_data: This is a list of dataframes with the station data<br>

```{r}
stations <- getFilteredStationsByCity(cities, station.list, begin = 2012, end = 2013)

stations$dl_status  #same results as above

stations$removed_rows
     city stations removed kept
1 Abidjan        5       3    2
2   Accra        3       2    1
3 Nairobi        4       1    3
4    Tema        3       2    1

stations$station_names_final
[1] "Abidjan_655780" "Accra_654720"   "Nairobi_637420" "Tema_654720" 


class(stations$station_data)
[1] "list"
length(stations$station_data)
[1] 4

```

getInterpolatedDataByCity
------
This function uses the same filtering procedure as `getFilteredStationsByCity` stations, selecting the best station for each city based on the number of missing observations and proximity to each city's reference point. It will then average the hourly observations and interpolate any missing values.

The output is one large dataframe with hourly observations for each city.

```{r, eval=FALSE}
hourly.data <- getInterpolatedDataByCity(cities, station.list, 5, 2010, 2013, 100, 3, .05)

dim(hourly.data)

```



plotDailyMax
------
Now that we have hourly observations for these 4 cities, perhaps we would like to plot the maximum daily temperature for each. 

```{r}
plotDailyMax(hourly.data)
```

![cityPlot](https://github.com/mpiccirilli/weatheR/blob/master/images/dailyMax.png)

We can see that the Nairobi weather station is clearly missing data for 6 months of both 2010 and and 2011.  The straight line is due to the linear interpolation performed in the prior step. 
