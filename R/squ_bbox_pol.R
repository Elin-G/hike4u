#' Square BBox Polygon
#'
#' `squ_bbox_pol` creates a square bbox around any geometry in a chosen column of an sf dataframe and increases the extent by a chosen amount of meters.
#'
#' @param sf_df an sf dataframe.
#' @param column the column in the sf dataframe with the geometry to create the bbox around. Must be passed on as a character string. See example.
#' @param value the value in the column to filter the sf dataframe by. Must be unique.
#' @param increase the amount of meters to increase the extent of the bbox by.
#' @return Returns an sf dataframe containing a square polygon.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Retrieve the sample dataframe from the package
#' final_routes_cl <- system.file("extdata", "final_routes_cl.rds", package = "hike4u")
#'
#' # Define the sf dataframe "final_routes_cl" within the function, the column
#' # name "closeness" as a character string, the closeness value as 1,
#' # and 1000 meters as the increase value
#' bbox <- squ_bbox_pol(final_routes_cl, "closeness", 1, 1000)
#' }
#'
#' @export

squ_bbox_pol <- function(sf_df, column, value, increase) {
  # Transform sf_df to crs=4326 to make sure calculations work
  sf_df <- sf::st_transform(sf_df, crs = 4326)

  # Filter sf_df to include only the row with specified closeness value
  chosen_route <- sf_df[sf_df[[column]] == value, ]
  if (nrow(chosen_route) == 0) {
    message("########################################
    \nNo row found with the specified value.
    \n########################################")
    return(NULL)
  }

  # Get the centroid of the geometry
  centroid <- sf::st_centroid(chosen_route$geometry)

  # Extract the coordinates
  centroid_coords <- sf::st_coordinates(centroid)

  # Create a dataframe with longitude and latitude columns
  centroid_df <- data.frame(
    longitude = centroid_coords[, "X"],
    latitude = centroid_coords[, "Y"]
  )

  # Convert centroid to sf object so that buffer in metres can be calculated
  centroid = sf::st_as_sf(centroid_df,coords=c("longitude","latitude"), crs = 4326)

  # Create bbox around the geometry of the chosen route
  bbox_route <- sf::st_bbox(chosen_route$geometry)

  # Transform bbox to sf using pgirmess package
  bbox_sf <- pgirmess::bbox2sf(bbox = bbox_route, crs = 4326)

  # Create sf dataframe
  bbox_sf <- sf::st_as_sf(bbox_sf, crs = 4326)

  # Extract the coordinates of the corners of the bounding box
  bbox_coords <- sf::st_coordinates(bbox_sf)[, 1:2]

  # Extract the coordinates of each corner
  top_left <- bbox_coords[1, ]
  top_right <- bbox_coords[2, ]
  bottom_right <- bbox_coords[3, ]
  bottom_left <- bbox_coords[4, ]

  # Create sf data frames for each corner with CRS 4326
  df_top_left <- sf::st_as_sf(data.frame(x = top_left[1], y = top_left[2]), coords = c("x", "y"), crs = 4326)
  df_top_right <- sf::st_as_sf(data.frame(x = top_right[1], y = top_right[2]), coords = c("x", "y"), crs = 4326)
  df_bottom_right <- sf::st_as_sf(data.frame(x = bottom_right[1], y = bottom_right[2]), coords = c("x", "y"), crs = 4326)
  df_bottom_left <- sf::st_as_sf(data.frame(x = bottom_left[1], y = bottom_left[2]), coords = c("x", "y"), crs = 4326)

  # Distance between df_tep_left and df_bottom_left
  distance_vertical <- sf::st_distance(df_top_left, df_bottom_left)

  # Distance between df_bottom_right and df_bottom_left
  distance_horizontal <- sf::st_distance(df_bottom_right, df_bottom_left)

  # Find the maximum length
  max_length <- max(distance_vertical, distance_horizontal)

  # Set units object for max_length
  max_length <- units::set_units(max_length, "m")

  # Divide max_length by two to get the radius of the buffer
  radius <- max_length / 2

  # Create a units object for 1000 meters
  meters <- units::set_units(increase, "m")

  # Add a margin of 1km to the maximum length
  radius <- radius + meters

  # Create buffer. Distance is measured in metres (in this case 10km)
  buffer_map <- sf::st_buffer(centroid, dist = radius)

  # Create bounding box around buffer
  bbox <- sf::st_bbox(buffer_map)

  # Transform bbox to sf using pgirmess package
  bbox_sf <- pgirmess::bbox2sf(bbox = bbox, crs = 4326)

  # Convert the bbox_sf to an sf dataframe
  bbox_sf <- sf::st_as_sf(bbox_sf, crs = 4326)

  return(bbox_sf)
}
