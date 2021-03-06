% Generated by roxygen2 (4.1.0.9000): do not edit by hand
% Please edit documentation in R/interpolateData.R
\name{interpolateData}
\alias{interpolateData}
\title{Interpolate Weather Station Data}
\usage{
interpolateData(wx.list)
}
\arguments{
\item{station_data}{List object of weather data}
}
\value{
This will return a list object with two elements: 1) The percentage number and percentage of interpolated values for each weather station; 2) A list of dataframes for each station.
}
\description{
This function takes in a list object of one or more data frames and will return
a data frame with hourly observations, with missing observations linearly interpolated
}
\examples{
\dontrun{
data(stations)
}
}

