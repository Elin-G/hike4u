#' Create POI Dataframe
#'
#' `create_poi_df` Creates an sf dataframe with your location as a point.
#'
#' @param longitude the longitude of your location.
#' @param latitude the latitude of your location.
#' @return Returns an sf dataframe "poi" with your location as a point in "WGS 84" "EPSG:4326" projection.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' poi <- create_poi_df(longitude = 9.93389691622025, latitude = 49.79895823510417)
#' }
#'
#' @export

create_poi_df <- function(longitude, latitude) {
  # Create a data frame with the coordinates
  poi_df <- data.frame(longitude = longitude, latitude = latitude)

  # Convert data frame to sf object
  poi <- sf::st_as_sf(poi_df, coords = c("longitude", "latitude"), crs = 4326)

  return(poi)
}
