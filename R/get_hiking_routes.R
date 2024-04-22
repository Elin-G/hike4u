#' Get Hiking Routes
#'
#' `get_hiking_routes` Downloads the OSM data of local walking network of defined buffer around defined POI.
#'
#' @param poi the POI as an sf dataframe with your location as a point. Created by function "create_poi_df".
#' @param buffer the defined buffer around the POI in meters as a Value. Created by function "create_buffer".
#' @return Returns an sf dataframe "hiking_routes" with the relevant hiking routes. If no hiking routes are found "No hiking routes found within your buffer area." is printed.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Buffer of 10000 meters (10 km) around the POI
#' hiking_routes <- get_hiking_routes(poi, buffer)
#' }
#'
#' @export

get_hiking_routes <- function(poi, buffer) {
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
    message("No hiking routes found within your buffer area.")
    return(NULL)
  }

  # Extract multiline data frame from hiking_data
  route_id <- rownames(hiking_data$osm_lines)
  hiking_routes <- osmdata::osm_multilines(hiking_data, route_id)

  return(hiking_routes)
}
