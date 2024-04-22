#' Calculate Closeness
#'
#' `calculate_closeness` Calculates distances between each starting point in final_routes and the POI. Ranks these distances to determine the closeness of each. Calculates length of route.
#'
#' @param poi the POI as an sf dataframe with your location as a point. Created by function "create_poi_df".
#' @param final_routes the sf dataframe with hiking routes. Created by function "add_start_points".
#' @return Returns a the sf dataframe "final_routes" with 3 new columns: the closeness value to your location, the distance between the route start point and your location, the length of the route.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' final_routes <- calculate_closeness(final_routes, poi)
#' }
#'
#' @export

calculate_closeness <- function(final_routes, poi) {
  # Calculate distances between each starting point and the POI
  distances <- sf::st_distance(final_routes$start_point, poi)

  # Rank the distances to determine closeness
  ranks <- order(order(distances))

  # Assign ranks to the "closeness" column
  final_routes$closeness <- ranks

  # Assign distance in km to poi to the "dist_to_poi" column, transform m to km, change units to km
  final_routes$dist_to_poi <- paste(round(distances / 1000, 2), "km")

  # Calculate length of routes in kilometers and assign it to the "route_length" column, transform m to km, change units to km
  final_routes$route_length <- paste(round(sf::st_length(final_routes$geometry) / 1000, 2), "km")

  return(final_routes)
}
