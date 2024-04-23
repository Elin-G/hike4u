#' Get Number of Routes
#'
#' `get_number_routes` prints the number of hiking routes within the buffer area.
#'
#' @param longitude the longitude of your location. Will create POI.
#' @param latitude the latitude of your location. Will create POI.
#' @param buffer a defined buffer around the POI in meters.
#' @return Returns a message in console stating the amount of routes within the buffer area.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Define your location with long=9.93389691622025 and lat=49.79895823510417,
#' # and define the buffer as 10000 meters (10 km)
#' get_number_routes(9.93389691622025, 49.79895823510417, 10000)
#' }
#'
#' @export

get_number_routes <- function(longitude, latitude, buffer) {

  # Create POI sf dataframe
  poi <- sf::st_as_sf(data.frame(longitude = longitude, latitude = latitude), coords = c("longitude", "latitude"), crs = 4326)

  # Create buffer value
  buffer <- buffer

  # Download hiking routes for given buffer
  hiking_routes <- get_hiking_routes(longitude, latitude, buffer)

  # Extract individual routes
  final_routes <- merge_mls(hiking_routes, "osm_id")

  # Count the number of rows in final_routes data frame
  num_routes <- nrow(final_routes)

  # Create message printing the amount of routes within final_routes
  message <- paste("###########################################################
                   \nThere are", num_routes, "hiking routes within", buffer, "m of your location.
                   \n###########################################################")
  cat(message, "\n")  # Print the message directly
}
