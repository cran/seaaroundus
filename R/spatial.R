#' Get list of cells in a given shape
#'
#' @export
#' @param shape (character) WKT representation of SRID 4326
#' polygon/multipolygon
#' @param check_wkt (logical) validate WKT or not. Default: `FALSE`
#' @param ... curl options passed on to [crul::HttpClient]
#' @return list of cell ids
#' @examples
#' getcells("POLYGON ((-48.177685950413291 15.842380165289299,
#' -48.177685950413291 15.842380165289299,
#' -54.964876033057919 28.964280991735578,
#' -35.960743801652967 27.606842975206646,
#' -48.177685950413291 15.842380165289299))")
#'
#' wkt <- "POLYGON((2.37 43.56,13.18 43.56,13.18 35.66,2.37 35.66,2.37 43.56))"
#' getcells(wkt)
#'
#' wkt <-
#' "MULTIPOLYGON(((15 5,5 10,10 20,40 10,15 5)),((30 20,10 40,45 40,30 20)))"
#' getcells(wkt)
getcells <- function(shape, check_wkt = FALSE, ...) {
  shape <- gsub("\n", "", shape)
  if (check_wkt) {
    chk <- wicket::validate_wkt(shape)
    if (!chk$is_valid) {
      cmt <- ""
      if (grepl("different orientation", chk$comments))
        cmt <- cmt_diff_or
      if (grepl("interior rings sitting outside", chk$comments))
        cmt <- cmt_int_out
      stop(paste(chk$comments, cmt))
    }
  }
  postapi("api/v1/spatial/r/shape", list(shape = shape), ...)
}

#' Get a dataframe with catch data for a given list of cells and year
#'
#' @export
#' @param year (integer/numeric) year of data. Default: 2010
#' @param cells (vector/list) list of cell IDs
#' @param ... curl options passed on to [crul::HttpClient]
#' @return data frame with catch data for the requested cells and year
#' @examples
#' getcelldata(2004, cells = 89568)
#' getcelldata(2008, cells = c(89568, 89569))
#' getcelldata(2011, cells = c(89568, 90288, 89569))
getcelldata <- function(year = 2010, cells, ...) {
  assert(year, c('numeric', 'integer'))
  assert(cells, c('numeric', 'integer'))
  body <- list(year = year)
  body <- c(body, as.list(stats::setNames(cells, rep("cells", length(cells)))))
  data <- postapi("api/v1/spatial/r/cells", body, ...)
  return(data.frame(data, stringsAsFactors = FALSE))
}

cmt_diff_or <- "\n  use wicket::wkt_correct() to correct it"
cmt_int_out <- paste(
  "\n  use MULTIPOLYGON instead, or make sure you're interior",
  "ring is inside exterior if using POLYGON"
)
