#' Get a map of the region specified
#'
#' @export
#' @template regionid
#' @param ... curl options passed on to [crul::HttpClient]
#' @return map of the region
#' @note there's a number of warnings that print, all related to \pkg{ggplot2},
#' they are most likely okay, and don't indicate a problem
#' @examples
#' regionmap(region = "eez", id = 76)
#'
#' # a different region type
#' regionmap(region = "lme", id = 23)
#'
#' \dontrun{
#' # all eez regions
#' regionmap("eez")
#' }
regionmap <- function(region, id, ...) {
  # draw all regions
  path <- paste("api/v1", region, "", sep = "/")
  args <- list(geojson = "true")
  tfile <- tempfile()
  on.exit(unlink(tfile))
  conn <- crul::HttpClient$new(url = getapibaseurl(), opts = list(...))
  res <- conn$get(path = path, query = args, disk = tfile)
  res$raise_for_status()
  dat <- sf::read_sf(readLines(tfile, warn = FALSE, encoding = "UTF-8"))

  if (!missing(id)) { # draw specified region
    path <- paste("api/v1", region, id, sep = "/")
    args <- list(geojson = "true")
    tfile2 <- tempfile()
    on.exit(unlink(tfile2))
    conn <- crul::HttpClient$new(url = getapibaseurl(), opts = list(...))
    res <- conn$get(path = path, query = args, disk = tfile2)
    res$raise_for_status()
    rsp <- sf::read_sf(readLines(tfile2, warn = FALSE, encoding = "UTF-8"))

    # get bounds for map zoom
    bounds <- sf::st_bbox(rsp)
    dim <- round(max(diff(bounds[c(1,3)]), diff(bounds[c(2,4)])))
    center <- c(mean(bounds[c(1,3)]), mean(bounds[c(2,4)]))
    xlim <- c(center[1] - dim, center[1] + dim)
    ylim <- c(center[2] - dim, center[2] + dim)
  }

  # draw the map
  map <- ggplot(dat) +
    sf::geom_sf(colour = "#394D66", fill = "#536D8E", size = 0.25)

  if (!missing(id)) {
    map <- map +
      sf::geom_sf(data = rsp, colour = "#449FD5", fill = "#CAD9EC", size = 0.25)
  }

  if (identical(region, "eez") && !missing(id)) { # use ifa for eez
    path <- paste("api/v1", region, id, "ifa", "", sep = "/")
    args <- list(geojson = "true")
    tfile3 <- tempfile()
    on.exit(unlink(tfile3))
    conn <- crul::HttpClient$new(url = getapibaseurl(), opts = list(...))
    res <- conn$get(path = path, query = args, disk = tfile3)
    res$raise_for_status()
    ifa <- sf::read_sf(readLines(tfile3, warn = FALSE, encoding = "UTF-8"))
    map <- map +
      sf::geom_sf(data = ifa, colour = "#E96063", fill = "#E38F95", size = 0.25)
  }

  map <- map +
    borders("world", colour = "#333333", fill = "#EDE49A", size = 0.25) +
    theme_map()

  if (!missing(id)) {
    map <- map + coord_sf(xlim = xlim, ylim = ylim)
  } else {
    map <- map + coord_sf()
  }

  return(map)
}
