#' Plot Satellite Map
#'
#' `plot_satellite_map` plots a satellite map of the chosen route, by closeness value, and exports the map as a PNG file to the working directory.
#'
#' @param longitude the longitude of your location. Will create POI.
#' @param latitude the latitude of your location. Will create POI.
#' @param final_routes the sf dataframe with hiking routes as Multilinestring geometries. Created by function "calculate_closeness".
#' @param closeness_value a defined closeness value. Choose between 1 and the max number of routes in your area. 1 is closest route to your location.
#' @return Returns a PNG file with the satellite map of the chosen route in the working directory. Or "No rows found with the specified closeness value."
#' @examples
#' \dontrun{
#' library(hike4u)
#'
#' # Retrieve the sample dataframe from the package
#' final_routes_cl <- readRDS(system.file("extdata", "final_routes_cl.rds", package = "hike4u"))
#'
#' # Define your location with long=9.93389691622025 and lat=49.79895823510417,
#' # the sf dataframe "final_routes_cl" and the closeness value as 1
#' plot_satellite_map(9.93389691622025, 49.79895823510417, final_routes_cl, 1)
#' }
#'
#' @export

plot_satellite_map <- function(longitude, latitude, final_routes, closeness_value) {

  # Create POI dataframe
  poi <- sf::st_as_sf(data.frame(longitude = longitude, latitude = latitude), coords = c("longitude", "latitude"), crs = 4326)

  # Calculate extent needed for map
  ext <- calculate_ext(final_routes, closeness_value)

  # Change crs to Web Mercator (EPSG: 3857) to be able to plot on top of basemap
  final_routes <- sf::st_transform(final_routes, crs = 3857)
  poi <- sf::st_transform(poi, crs = 3857)

  # set defaults for the basemap = esri, world_street_map
  basemaps::set_defaults(map_service = "esri", map_type = "world_imagery")

  # Filter final_routes to get the row with specified closeness value
  closest_route <- final_routes[final_routes$closeness == closeness_value, ]
  if (nrow(closest_route) == 0) {
    message("##################################################
    \nNo row found with the specified closeness value.
    \n##################################################")
    return(NULL)
  }

  # Check if poi is within ext
  within_ext <- any(sf::st_contains(ext, poi))
  # Create dataframe
  intersect_df <- data.frame(intersect = ifelse(is.na(within_ext), 1, ifelse(within_ext, 2, NA)))

  # Plot the closest route based on within_ext
  if (intersect_df$intersect == 2) {
    # Plot the closest route with poi
    p <- ggplot2::ggplot() +
      basemaps::basemap_gglayer(ext, alpha = 0.8) + # Plot basemap as ggplot2 layer
      ggplot2::scale_fill_identity() +
      ggplot2::coord_sf() +
      ggplot2::geom_sf(data = closest_route, ggplot2::aes(color = "red"), linewidth = 1) +  # Hike in brown
      ggplot2::geom_sf(data = closest_route$start_point, ggplot2::aes(color = "yellow"), size = 4, shape = 18) +  # Starting Points in red
      ggplot2::geom_sf(data = poi, ggplot2::aes(color = "black"), size = 4, shape = 16) + # POI in black
      ggplot2::scale_color_manual(values = c("red" = "red", "yellow" = "yellow", "black" = "black"),
                         labels = c("red" = "Hiking Trail", "yellow" = "Starting Point", "black" = "Your Location")) + # Manual color mapping with custom labels
      ggplot2::labs(title = paste0("Closest Hiking Route to your Location (# ", closeness_value, ")"),
           subtitle = "Satellite Map",
           caption = "Data Source: \u00A9 Esri",
           color = "Legend",
           x = "Longitude",
           y = "Latitude") +
      ggspatial::annotation_scale(location = "br", pad_x = grid::unit(1.2, "cm"), pad_y = grid::unit(1.2, "cm"), text_cex = 0.9, text_face = "bold") + # spatial-aware automagic scale bar
      ggspatial::annotation_north_arrow(location = "tr", pad_x = grid::unit(1.2, "cm"), pad_y = grid::unit(1.2, "cm"), which_north = "true") + # spatial-aware automagic north arrow
      ggplot2::theme_minimal() +
      ggplot2::theme(legend.position = "right",
            plot.title = ggplot2::element_text(face = "bold", hjust = 0.5, size = 20),
            plot.subtitle = ggplot2::element_text(face = "bold", hjust = 0.5, size = 15),
            plot.caption.position = "panel",
            plot.caption = ggplot2::element_text(hjust = 1, vjust = 1, face = "italic", size = 8),
            axis.title = ggplot2::element_text(face = "plain", size = 10),
            axis.text = ggplot2::element_text(face = "plain", size = 8),
            axis.title.y = ggplot2::element_text(vjust = 4))
  } else {
    # Plot the closest route without poi
    p <- ggplot2::ggplot() +
      basemaps::basemap_gglayer(ext, alpha = 0.8) + # Plot basemap as ggplot2 layer
      ggplot2::scale_fill_identity() +
      ggplot2::coord_sf() +
      ggplot2::geom_sf(data = closest_route, ggplot2::aes(color = "red"), linewidth = 1) +  # Hike in brown
      ggplot2::geom_sf(data = closest_route$start_point, ggplot2::aes(color = "yellow"), size = 4, shape = 18) +  # Starting Points in red
      ggplot2::scale_color_manual(values = c("red" = "red", "yellow" = "yellow"),
                         labels = c("red" = "Hiking Trail", "yellow" = "Starting Point")) + # Manual color mapping with custom labels
      ggplot2::labs(title = paste0("Closest Hiking Route to your Location (# ", closeness_value, ")"),
           subtitle = "Satellite Map",
           caption = "Data Source: \u00A9 Esri",
           color = "Legend",
           x = "Longitude",
           y = "Latitude") +
      ggspatial::annotation_scale(location = "br", pad_x = grid::unit(1.2, "cm"), pad_y = grid::unit(1.2, "cm"), text_cex = 0.9, text_face = "bold") + # spatial-aware automagic scale bar
      ggspatial::annotation_north_arrow(location = "tr", pad_x = grid::unit(1.2, "cm"), pad_y = grid::unit(1.2, "cm"), which_north = "true") + # spatial-aware automagic north arrow
      ggplot2::theme_minimal() +
      ggplot2::theme(legend.position = "right",
            plot.title = ggplot2::element_text(face = "bold", hjust = 0.5, size = 20),
            plot.subtitle = ggplot2::element_text(face = "bold", hjust = 0.5, size = 15),
            plot.caption.position = "panel",
            plot.caption = ggplot2::element_text(hjust = 1, vjust = 1, face = "italic", size = 8),
            axis.title = ggplot2::element_text(face = "plain", size = 10),
            axis.text = ggplot2::element_text(face = "plain", size = 8),
            axis.title.y = ggplot2::element_text(vjust = 4))
  }
  # Plot additional information about route underneath ggplot map
  p <- cowplot::ggdraw(cowplot::add_sub(p, paste0("\nName of Hiking Route: ", closest_route$name,
                                "\n\nStart Point Coordinates: Longitude: ", closest_route$sp_long, ", Latitude: ", closest_route$sp_lat,
                                "\n\nDistance to Start Point: ", closest_route$dist_to_poi,
                                "\n\nLength of Route: ", closest_route$route_length), size = 12))

  # Export the plot to a PNG file
  ggplot2::ggsave(paste0("closest_route_nr_", closeness_value, "_satellite_map.png"), plot = p, width = 12.5, height = 11, dpi = 300, bg = "white")
}
