#' Merge Multilinestring Geometries
#'
#' `merge_mls` merges Multilinestring geometries in an sf dataframe according to the value of a given column, to create a single geometry and row.
#'
#' @param sf_df an sf dataframe with geometries *Multilinestring* and an additional column to merge by.
#' @param column the column name by which values to merge the Multilinestring geometries by. Must be passed on as a character string. See example.
#' @return Returns the sf dataframe with one row/geometry per value in defined column.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Retrieve the sample dataframe from the package
#' hiking_routes <- readRDS(system.file("extdata", "hiking_routes.rds", package = "hike4u"))
#'
#' # Define the sf dataframe "hiking_routes" and the column osm_id within the function
#' final_routes <- merge_mls(hiking_routes, "osm_id")
#' }
#'
#' @export

merge_mls <- function(sf_df, column) {
  unique_ids <- unique(sf_df[[column]]) # Get unique osm_id values

  merged_df <- data.frame()  # Create an empty dataframe to store the final merged routes

  for (id in unique_ids) { # Loop over unique ids
    subset_df <- sf_df[sf_df[[column]] == id, ]   # Subset dataframe for the current osm_id

    if (nrow(subset_df) > 1) { # Check if there are multiple rows
      # Merge geometries if there are multiple rows
      merged_geometry <- sf::st_union(subset_df$geometry)
      subset_df <- subset_df[1, ]  # Keep only the first row
      subset_df$geometry <- merged_geometry  # Assign the merged geometry
    }

    merged_df <- rbind(merged_df, subset_df)  # Combine subset dataframe with final_routes
  }

  return(merged_df)
}
