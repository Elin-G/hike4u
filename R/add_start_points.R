#' Add Start Points
#'
#' `add_start_points` Adds starting points and their lat and long to sf df final_routes.
#'
#' @param final_routes the sf dataframe with hiking routes. Created by function "individual_routes".
#' @return Returns a the sf dataframe "final_routes" with the added starting points and their lat and long in 3 new columns.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' final_routes <- add_start_points(final_routes)
#' }
#'
#' @export

add_start_points <- function(final_routes) {
  # Add a new column for starting points using mutate and insert them
  final_routes <- dplyr::mutate(final_routes, start_point = lwgeom::st_startpoint(final_routes$geometry))

  # Extract longitude and latitude from start_point
  coordinates <- sf::st_coordinates(final_routes$start_point)
  final_routes$sp_long <- coordinates[, "X"]
  final_routes$sp_lat <- coordinates[, "Y"]

  return(final_routes)
}
