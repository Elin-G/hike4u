#' Calculate Closeness
#'
#' `calculate_closeness` calculates distances between each starting point of hiking routes in an sf dataframe and your defined location. Ranks these distances to determine the closeness of each. Calculates length of each route.
#'
#' @param longitude the longitude of your location. Will create POI.
#' @param latitude the latitude of your location. Will create POI.
#' @param sf_df an sf dataframe with downloaded hiking routes from OSM with start points in the column "start_point". Created by function "add_start_points".
#' @return Returns the sf dataframe with 3 new columns: the closeness value to your location, the distance between the route start point and your location, the length of the route.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#'#' # Retrieve the sample dataframe from the package
#' final_routes <- system.file("extdata", "final_routes.rds", package = "hike4u")
#'
#' # Define your location with long=9.93389691622025 and lat=49.79895823510417,
#' # and the sf dataframe "final_routes" within the function
#' final_routes_cl <- calculate_closeness(9.93389691622025, 49.79895823510417, final_routes)
#' }
#'
#' @export

calculate_closeness <- function(longitude, latitude, sf_df) {

  # Create POI dataframe
  poi <- sf::st_as_sf(data.frame(longitude = longitude, latitude = latitude), coords = c("longitude", "latitude"), crs = 4326)

  # Calculate distances between each starting point and the POI
  distances <- sf::st_distance(sf_df$start_point, poi)

  # Rank the distances to determine closeness
  ranks <- order(order(distances))

  # Assign ranks to the "closeness" column
  sf_df$closeness <- ranks

  # Assign distance in km to poi to the "dist_to_poi" column, transform m to km, change units to km
  sf_df$dist_to_poi <- paste(round(distances / 1000, 2), "km")

  # Calculate length of routes in kilometers and assign it to the "route_length" column, transform m to km, change units to km
  sf_df$route_length <- paste(round(sf::st_length(sf_df$geometry) / 1000, 2), "km")

  return(sf_df)
}
