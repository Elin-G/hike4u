#' Calculate Extent
#'
#' `calculate_ext` calculates the extent the map should have depending on which route is chosen by closeness value.
#'
#' @param sf_df an sf dataframe with downloaded hiking routes from OSM with closeness values in the column "closeness". Created by function "calculate_closeness".
#' @param closeness_value a defined closeness value. Choose between 1 and the max number of routes in your area. 1 = closest route to your location.
#' @return Returns an sf dataframe "ext" with a polygon of the extent. Or "No rows found with the specified closeness value."
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Retrieve the sample dataframe from the package
#' final_routes_cl <- readRDS(system.file("extdata", "final_routes_cl.rds", package = "hike4u"))
#'
#' # Define the sf dataframe "final_routes_cl" within the function and the closeness value as 1
#' ext <- calculate_ext(final_routes_cl, 1)
#' }
#'
#' @export

calculate_ext <- function(sf_df, closeness_value) {
  # Transform sf_df to crs=4326 to make sure calculations work
  sf_df <- sf::st_transform(sf_df, crs = 4326)

  # Filter sf_df to include only the row with specified closeness value
  closest_route <- sf_df[sf_df$closeness == closeness_value, ]
  if (nrow(closest_route) == 0) {
    message("##################################################
    \nNo row found with the specified closeness value.
    \n##################################################")
    return(NULL)
  }

  # Get the centroid of the geometry
  centroid <- sf::st_centroid(closest_route$geometry)

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
  bbox_route <- sf::st_bbox(closest_route$geometry)

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
  meters <- units::set_units(1000, "m")

  # Add a margin of 1km to the maximum length
  radius <- radius + meters

  # Create buffer. Distance is measured in metres (in this case 10km)
  buffer_map <- sf::st_buffer(centroid, dist = radius)

  # Convert the square_buffer to an sf object
  ext <- sf::st_sf(buffer_map)

  #Change crs to Web Mercator (EPSG: 3857) to be able to plot on top of basemap
  ext <- sf::st_transform(ext, crs = 3857)

  return(ext)
}
