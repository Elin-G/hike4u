#' Get Number of Routes
#'
#' `get_number_routes` Prints the number of hiking routes within the buffer area.
#'
#' @param final_routes the sf dataframe with hiking routes. Created by function "calculate_closeness".
#' @param buffer the defined buffer around the POI in meters as a Value. Created by function "create_buffer".
#' @return Returns a text stating the amount of routes within the buffer area in console.
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' get_number_routes(final_routes, buffer)
#' }
#'
#' @export

get_number_routes <- function(final_routes, buffer) {
  num_routes <- nrow(final_routes)
  message <- paste("###########################################################
                   \nThere are", num_routes, "hiking routes within", buffer, "m of your location.
                   \n###########################################################")
  cat(message, "\n")  # Print the message directly
  return(num_routes)  # Return the number of routes
}
