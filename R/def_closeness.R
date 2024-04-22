#' Define Closeness Value
#'
#' `def_closeness` Creates a number value with your defined closeness value. Choose 1 for the first run of the package to then get returned which values you could choose as max.
#'
#' @param closeness_value the defined closeness value. Choose between 1 and the max number of routes in your area. 1 = closest route to your location.
#' @return Returns a number value "buffer" with the size in meters.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Assign a closeness value of 1 to choose the closest route to your location (POI)
#' closeness_value <- def_closeness(1)
#' }
#'
#' @export

def_closeness <- function(closeness_value) {
  # Create a data frame with the coordinates
  closeness_value <- closeness_value

  return(closeness_value)
}
