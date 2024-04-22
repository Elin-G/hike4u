#' hike4u
#'
#' `hike4u` uses your location, given in longitude and latitude, a given buffer size in meters to find hiking routes close to you. It plots two maps, and overview and a satellite map, of the route you have defined by closeness, and saves them to your working directory.
#'
#' @param longitude the longitude of your location.
#' @param latitude the latitude of your location.
#' @param buffer the defined buffer around the POI in meters.
#' @param closeness_value the defined closeness value. Choose between 1 and the max number of routes in your area. 1 = closest route to your location.
#' @return Returns two maps in you working directory folder and text stating the amount of routes within the buffer area in console.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Define you location with long=9.93389691622025 and lat=49.79895823510417,
#' # define the buffer as 10000 meters (10 km) and the closeness value as 1.
#' hike4u(9.93389691622025, 49.79895823510417, 10000, 1)
#' }
#'
#' @export

hike4u <- function(longitude, latitude, buffer, closeness_value) {

  # Create POI dataframe
  poi <- create_poi_df(longitude = longitude, latitude = latitude)

  # Create buffer value
  buffer <- create_buffer(buffer)

  # Create closeness value
  closeness_value <- def_closeness(closeness_value)

  # Download hiking routes for given buffer
  hiking_routes <- get_hiking_routes(poi, buffer)

  # Extract individual routes
  final_routes <- individual_routes(hiking_routes)

  # Add start points to routes
  final_routes <- add_start_points(final_routes)

  # Calculate closeness
  final_routes <- calculate_closeness(final_routes, poi)

  # Print number of routes within given buffer
  get_number_routes(final_routes, buffer)

  # Calculate extent needed for map
  ext <- calculate_ext(final_routes, poi, closeness_value)

  # Plot and save overview map of chosen route
  plot_overview_map(final_routes, poi, ext, closeness_value)

  # Plot and save satellite map of chosen route
  plot_satellite_map(final_routes, poi, ext, closeness_value)
}

