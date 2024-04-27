#' Add Start Points
#'
#' `add_start_points` adds starting points of Multilinestring geometries and the lat and long of these start points to a dataframe.
#'
#' @param sf_df an sf dataframe with downloaded hiking routes from OSM with geometry *Multilinestring* and an osm_id column. Otherwise created by function "indiv_routes".
#' @return Returns the sf dataframe with the added starting points and their Latitude and Longitude in 3 new columns.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Retrieve the sample dataframe from the package
#' final_routes <- readRDS(system.file("extdata", "final_routes.rds", package = "hike4u"))
#'
#' # Define the sf dataframe "final_routes" within the function
#' final_routes <- add_start_points(final_routes)
#' }
#'
#' @export

add_start_points <- function(sf_df) {
  # Add a new column for starting points using mutate and insert them
  hiking_routes <- dplyr::mutate(sf_df, start_point = lwgeom::st_startpoint(sf_df$geometry))

  # Extract longitude and latitude from start_point
  coordinates <- sf::st_coordinates(hiking_routes$start_point)
  hiking_routes$sp_long <- coordinates[, "X"]
  hiking_routes$sp_lat <- coordinates[, "Y"]

  return(hiking_routes)
}
