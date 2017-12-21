#' @section Catch reconstruction documentation:
#' <http://www.seaaroundus.org/catch-reconstruction-and-allocation-methods/>
#' <https://s3-us-west-2.amazonaws.com/sau-methods-docs/reconstruction-allocation/Methods-Catch-tab-Apr-29-2016.pdf>
#'
#' @name seaaroundus-package
#' @docType package
#' @title R library for Sea Around Us
#' @description: Access Sea Around Us catch data and view it as data frames
#' or stacked area charts.
#' @author Scott Chamberlain \email{myrmecocystus+r@@gmail.com}
#' @author Robert Scott Reis \email{reis.robert.s@@gmail.com}
#' @keywords package
#' @importFrom crul HttpClient
#' @importFrom jsonlite fromJSON
#' @import ggplot2
#' @import grid
#' @import scales
#' @import maps
#' @import sp

globalVariables(c("year", "level_1950", "level_1962", "level_1968", "level", "long", "lat"))
