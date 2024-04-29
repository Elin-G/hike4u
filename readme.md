# `hike4u`

<!-- README.md is generated from README.Rmd. Please edit that file -->

`hike4u` is an `R` package to plot the closest hiking route near you. It
uses exclusively open source data: hiking route data from
*OpenStreetMap* and basemaps from *OpenStreetMap* and *Esri*. By
defining your location through **longitude** and **latitude**, and
adding a buffer size, you can retrieve hiking routes from the local
walking network of *OSM*. By defining a closeness value, you can plot
not only the closest hiking route to your location, but also the second
closest, third closest, and so on. Your chosen route is ultimately
plotted as an overview map or a satellite map. The first can be used to
orient oneself, the second to see which kind of terrain is covered by
the route. These two maps are exported to your working directory as
`png` files. The package aims to ease the discovery of hiking routes
close-by, to encourage exploring new areas, as well as to provide a tool
for planning hiking trips.

## Installation

You can install the released version of `hike4u` from GitHub:

    devtools::install_github("Elin-G/hike4u")

## Example

This example shows how easy it is to plot the closest hiking route near
you.

Run the function `get_number_routes` to get an overview of how many
hiking routes are available in your selected buffer area.

**Example code:**

    library(hike4u)

    # Define your location with long=9.93389691622025 and lat=49.79895823510417, and define the buffer as 10000 meters (10 km)

    get_number_routes(9.93389691622025, 49.79895823510417, 10000)

**Running this example will print the following text in your console:**

![](Images/get_number_routes.png)

A simple way to get the coordinates for a location you need is to use
Google Maps. Right-click on the location and copy and paste them into
the `hike4u_ov` function to generate an overview map, or into the
`hike4u_sat` function to generate a satellite map.

A good buffer size to start with is 10000 meters. Do not choose a buffer
size that is too small, as there might not be any hiking routes in that
area. Additionally do not choose a buffer size that is too large, as the
function will take longer to run, or your device might not be able to
handle the request.

Set the closeness value to 1 for the closest hike to your location. If
you are not satisfied with the result, you can increase the closeness
value to 2, 3, \[…\]. The function will then plot the second closest
hiking route, the third closest hiking route, and so on.

**Example code:**

    library(hike4u)

    # Define your location with long=9.93389691622025 and lat=49.79895823510417, define the buffer as 10000 meters (10 km) and the closeness value as 1

    hike4u_ov(9.93389691622025, 49.79895823510417, 10000, 1)

**Running this example will print the following text in your console:**

![](Images/closest_route_nr_1_overview_map.png)

**Example code:**

    library(hike4u)

    # Define your location with long=9.93389691622025 and lat=49.79895823510417, define the buffer as 10000 meters (10 km) and the closeness value as 1

    hike4u_sat(9.93389691622025, 49.79895823510417, 10000, 1)

**Running this example will print the following text in your console:**

![](Images/closest_route_nr_1_satellite_map.png)

## Functions

The following functions are part of the `hike4u` package:

`get_number_routes(longitude, latitude, buffer)`: Returns the number of
hiking routes in the buffer area around your location.

`hike4u_ov(longitude, latitude, buffer, closeness_value)`: Plots a
hiking route near your location as an overview map.

`hike4u_sat(longitude, latitude, buffer, closeness_value)`: Plots a
hiking route near your location as a satellite map.

`get_hiking_routes(longitude, latitude, buffer)`: Downloads the OSM data
of local walking network of defined buffer around defined location.

**Run with example data:**

    # read sample dataframes of the hike4u package

    hiking_routes <- readRDS(system.file("extdata", "hiking_routes.rds", package = "hike4u"))
    final_routes <- readRDS(system.file("extdata", "final_routes.rds", package = "hike4u"))
    final_routes_cl <- readRDS(system.file("extdata", "final_routes_cl.rds", package = "hike4u"))

`merge_mls(sf_df, column)`: Merges multiple MultiLineStrings in a data
frame into one MultiLineString (use hiking\_routes).

`squ_bbox(sf_df, column, value, increase)`: Creates a bigger square
bounding box of an sf object than sf::st\_bbox (use final\_routes\_cl).

`squ_bbox_pol(sf_df, column, value, increase)`: Creates a bigger square
polygon around an af object than sf::st\_bbox (use final\_routes\_cl).

`add_start_points(sf_df)`: Returns the sf dataframe with the added
starting points of Multilinestring geometries and their Latitude and
Longitude in 3 new columns (use final\_routes).

`calculate_closeness(longitude, latitude, sf_df)`: Returns the sf
dataframe with 3 new columns: the closeness value to your location, the
distance between the route start point and your location, the length of
the route in km (use final\_routes).

`calculate_ext(sf_df, closeness_value)`: Calculates the extent the map
should have depending on which route is chosen by closeness value (use
final\_routes\_cl).

`plot_overview_map(longitude, latitude, final_routes, closeness_value)`:
Plots an overview map of the chosen route, by closeness value, and
exports the map as a PNG file to the working directory (use
final\_routes\_cl).

`plot_satellite_map(longitude, latitude, final_routes, closeness_value)`:
Plots a satellite map of the chosen route, by closeness value, and
exports the map as a PNG file to the working directory (use
final\_routes\_cl).

## Arguments

The following arguments are part of the `hike4u` package functions:

    longitude         Longitude of your location. Will create POI.

    latitude          Latitude of your location. Will create POI.

    buffer            Buffer size around your location in meters.

    closeness_value   A defined closeness value. Choose between 1 and the max number of routes in your area. 1 =                     closest route to your location.

    sf_df             An sf dataframe with specifications (see functions themselves or help page.)

    column            The column in an sf dataframe with the geometry to create the bbox around. Must be passed on                   as a character string.

    value             The value in the column of an sf dataframe to filter by. Must be unique.

    increase          The amount of meters to increase the extent of a bbox by.

    final_routes      An sf dataframe with hiking routes as Multilinestring geometries. Created by function                          "calculate_closeness".
