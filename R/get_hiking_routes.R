#' Get Hiking Routes
#'
#' `get_hiking_routes` Downloads the OSM data of local walking network of defined buffer around defined location.
#'
#' @param longitude the longitude of your location. Will create POI.
#' @param latitude the latitude of your location. Will create POI.
#' @param buffer a defined buffer around the POI in meters.
#' @return Returns an sf dataframe "hiking_routes" with the relevant hiking routes. If no hiking routes are found "No hiking routes found within your buffer area." is printed.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Define your location with long=9.93389691622025 and lat=49.79895823510417,
#' # and define the buffer as 10000 meters (10 km)
#' hiking_routes <- get_hiking_routes(9.93389691622025, 49.79895823510417, 10000)
#' }
#'
#' @export

get_hiking_routes <- function(longitude, latitude, buffer) {

  # Create POI dataframe
  poi <- sf::st_as_sf(data.frame(longitude = longitude, latitude = latitude), coords = c("longitude", "latitude"), crs = 4326)

  # Create buffer value
  buffer <- buffer

  # Create buffer
  buffer <- sf::st_buffer(poi, dist = buffer)

  # Create bounding box around buffer
  bbox <- sf::st_bbox(buffer)

  # Download OSM data
  osm_query <- osmdata::opq(timeout = 50, bbox = bbox)
  osm_query <- osmdata::add_osm_feature(osm_query, key = "route", value = "hiking")
  osm_query <- osmdata::add_osm_feature(osm_query, key = "network", value = "lwn")
  hiking_data <- osmdata::osmdata_sf(osm_query)

  # Check if hiking routes dataframe is empty
  if (length(hiking_data$osm_lines$osm_id) == 0) {
    message("##################################################
            \nNo hiking routes found within your buffer area.
            \n##################################################")
    return(NULL)
  }

  # Extract multiline data frame from hiking_data
  route_id <- rownames(hiking_data$osm_lines)
  hiking_routes <- osmdata::osm_multilines(hiking_data, route_id)

  return(hiking_routes)
}
