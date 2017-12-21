#' List available regions for a region type
#'
#' @export
#' @param region (character) region type
#' @param ... curl options passed on to [crul::HttpClient()]
#' @return a data frame with columns:
#'
#' - region title
#' - region ID
#'
#' @examples
#' listregions(region = "eez")
listregions <- function(region, ...) {
  data <- callapi(paste0("api/v1/", region, "/"), list(nospatial = "true"), ...)
  return(data)
}
