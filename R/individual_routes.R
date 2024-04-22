#' Extract Individual Routes
#'
#' `individual_routes` If one route is split into multiple rows, this function merges the geometries to create a single geometry for the route.
#'
#' @param hiking_routes the sf dataframe with all downloaded hiking routes. Created by function "get_hiking_routes".
#' @return Returns a filtered sf dataframe "final_routes" with one row/geometry per hiking route.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' final_routes <- individual_routes(hiking_routes)
#' }
#'
#' @export

individual_routes <- function(hiking_routes) {
  unique_ids <- unique(hiking_routes$osm_id) # Get unique osm_id values

  final_routes <- data.frame()  # Create an empty dataframe to store the final merged routes

  for (id in unique_ids) { # Loop over unique ids
    subset_df <- hiking_routes[hiking_routes$osm_id == id, ]   # Subset dataframe for the current osm_id

    if (nrow(subset_df) > 1) { # Check if there are multiple rows
      # Merge geometries if there are multiple rows
      merged_geometry <- sf::st_union(subset_df$geometry)
      subset_df <- subset_df[1, ]  # Keep only the first row
      subset_df$geometry <- merged_geometry  # Assign the merged geometry
    }

    final_routes <- rbind(final_routes, subset_df)  # Combine subset dataframe with final_routes
  }

  return(final_routes)
}
