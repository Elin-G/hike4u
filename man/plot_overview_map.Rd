% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_overview_map.R
\name{plot_overview_map}
\alias{plot_overview_map}
\title{Plot Overview Map}
\usage{
plot_overview_map(longitude, latitude, final_routes, closeness_value)
}
\arguments{
\item{longitude}{the longitude of your location. Will create POI.}

\item{latitude}{the latitude of your location. Will create POI.}

\item{final_routes}{the sf dataframe with hiking routes as Multilinestring geometries. Created by function "calculate_closeness".}

\item{closeness_value}{a defined closeness value. Choose between 1 and the max number of routes in your area. 1 is closest route to your location.}
}
\value{
Returns a PNG file with the overview map of the chosen route in the working directory. Or "No rows found with the specified closeness value."
}
\description{
\code{plot_overview_map} plots an overview map of the chosen route, by closeness value, and exports the map as a PNG file to the working directory.
}
\examples{
\dontrun{
library(hike4u)

# Retrieve the sample dataframe from the package
final_routes_cl <- readRDS(system.file("extdata", "final_routes_cl.rds", package = "hike4u"))

# Define your location with long=9.93389691622025 and lat=49.79895823510417,
# the sf dataframe "final_routes_cl" and the closeness value as 1
plot_overview_map(9.93389691622025, 49.79895823510417, final_routes_cl, 1)
}

}
