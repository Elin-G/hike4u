#' hike4u
#'
#' `hike4u_overview` uses your location, given in longitude and latitude, a given buffer size in meters to find hiking routes close to you. It plots an overview map of the route you have defined by closeness, and saves it to your working directory.
#'
#' @param longitude the longitude of your location. Will create POI.
#' @param latitude the latitude of your location. Will create POI.
#' @param buffer a defined buffer around the POI in meters.
#' @param closeness_value a defined closeness value. Choose between 1 and the max number of routes in your area. 1 = closest route to your location.
#' @return Returns an overview map in you working directory folder with name: "closest_route_nr_*closeness_value*_overview_map.png.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Define your location with long=9.93389691622025 and lat=49.79895823510417,
#' # define the buffer as 10000 meters (10 km) and the closeness value as 1
#' hike4u_overview(9.93389691622025, 49.79895823510417, 10000, 1)
#' }
#'
#' @export

hike4u_overview <- function(longitude, latitude, buffer, closeness_value) {

  # Create POI dataframe
  poi <- sf::st_as_sf(data.frame(longitude = longitude, latitude = latitude), coords = c("longitude", "latitude"), crs = 4326)

  # Create buffer value
  buffer <- buffer

  # Create closeness value
  closeness_value <- closeness_value

  # Download hiking routes for given buffer
  hiking_routes <- get_hiking_routes(longitude, latitude, buffer)

  # Extract individual routes
  final_routes <- merge_mls(hiking_routes, "osm_id")

  # Add start points to routes
  final_routes <- add_start_points(final_routes)

  # Calculate closeness
  final_routes <- calculate_closeness(longitude, latitude, final_routes)

  # Calculate extent needed for map
  ext <- calculate_ext(final_routes, closeness_value)

  # Plot and save overview map of chosen route
  plot_overview_map(longitude, latitude, final_routes, closeness_value)
}
