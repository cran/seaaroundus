#' Get a map of the region specified
#'
#' @export
#' @template regionid
#' @return map of the region
#' @note there's a number of warnings that print, all related to \pkg{ggplot2},
#' they are most likely okay, and don't indicate a problem
#' @examples \dontrun{
#' regionmap2("eez")
#' regionmap2(region="eez", id=76)
#'
#' # a different region type
#' regionmap2("lme", 23)
#' }
regionmap2 <- function(region, id) {
  conn <- crul::HttpClient$new(url = getapibaseurl(), opts = list(verbose = TRUE))
  
  path <- paste("api/v1", region, "", sep = "/")
  args <- list(geojson = "true")
  tfile <- tempfile()
  on.exit(unlink(tfile))
  res <- conn$get(path = path, query = args, disk = tfile)
  res$raise_for_status()

  # draw all regions
  # url <- paste(getapibaseurl(), region, "?geojson=true", sep = "/")
  regions <- ggplot2::fortify(
    rgdal::readOGR(dsn = tfile, layer = rgdal::ogrListLayers(tfile),
                   verbose = FALSE))

  # draw specified region
  if (!missing(id)) { 
    # url <- paste(getapibaseurl(), region, paste(id, "?geojson=true", sep = ""),
    #              sep = "/")
    path <- file.path("api/v1", region, id)
    tfile2 <- tempfile()
    on.exit(unlink(tfile2))
    res2 <- conn$get(path = path, query = args, disk = tfile2)
    res2$raise_for_status()
    rsp <- rgdal::readOGR(dsn = tfile2, layer = rgdal::ogrListLayers(tfile2),
                          verbose = FALSE)
    regionmap <- ggplot2::fortify(rsp)

    # get bounds for map zoom
    bounds <- sp::bbox(rsp)
    dim <- round(max(diff(bounds[1,]), diff(bounds[1,])))
    center <- c(mean(bounds[1,]), mean(bounds[2,]))
    xlim <- c(center[1] - dim, center[1] + dim)
    ylim <- c(center[2] - dim, center[2] + dim)
  }

  # draw the map
  map <- ggplot() +
    geom_map(data = regions, map = regions,
             aes(map_id = id, x = long, y = lat),
             colour = "#394D66", fill = "#536D8E", size = 0.25)

  if (!missing(id)) {
    map <- map +
      geom_map(data = regionmap, map = regionmap,
               aes(map_id = id, x = long, y = lat),
               colour = "#449FD5", fill = "#CAD9EC", size = 0.25)
  }

  if (identical(region, "eez") && !missing(id)) { # use ifa for eez
    url <- paste(getapibaseurl(), region, id, "ifa", "?geojson=true", sep = "/")
    ifa <- ggplot2::fortify(
      rgdal::readOGR(dsn = url,
                     layer = rgdal::ogrListLayers(url), verbose = FALSE))
    map <- map +
      geom_map(data = ifa, map = ifa, aes(map_id = id, x = long, y = lat),
               colour = "#E96063", fill = "#E38F95", size = 0.25)
  }

  map <- map +
    borders("world", colour = "#333333", fill = "#EDE49A", size = 0.25) +
    theme_map()

  if (!missing(id)) {
    map <- map + coord_equal(xlim = xlim, ylim = ylim)
  } else {
    map <- map + coord_equal()
  }

  return(map)
}
