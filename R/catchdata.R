#' Get catch data for a region as a dataframe or stacked area chart
#'
#' @export
#' @template regionid
#' @param measure (character) the data measurement. one of "tonnage" or "value"
#' (for "landed value"). Default: "tonnage"
#' @param dimension (character) dimension data is bucketed on. one of "taxon",
#' "commercialgroup", "functionalgroup", "country", "sector", "catchtype",
#' "reporting-status", "layer" (for "data layer"). Default: "taxon"
#' @param limit (numeric/integer) number of buckets of data plus one for
#' "others". Default: 10
#' @param chart (boolean) to return a chart versus a data frame
#' Default: `FALSE`
#' @param ... curl options passed on to [crul::HttpClient()]
#' @return data frame (or ggplot2 chart) with catch data for the requested
#' region over time
#' @examples
#' catchdata("eez", 76)
#' head(catchdata("eez", 76, measure="value", dimension="reporting-status"))
#' catchdata("eez", 76, measure="value", dimension="sector")
#' catchdata("eez", 76, measure="value", dimension="taxon")
#' \dontrun{
#' catchdata(region = "eez", id = 76, chart = TRUE)
#' }
catchdata <- function(region, id, measure="tonnage", dimension="taxon",
  limit=10, chart=FALSE, ...) {

  # create url path and query parameters
  path <- paste("api/v1", region, measure, dimension, "", sep="/")
  args <- list(region_id = id, limit = limit)

  # call API
  data <- callapi(path, args, ...)

  if (is.null(data)) return(data.frame(NULL))

  # extract data from response
  values <- data$values
  years <- values[[1]][,1]
  cols <- lapply(values, function(v) { v[,2] })

  # create dataframe
  df <- data.frame(years, cols, stringsAsFactors = FALSE)
  df[is.na(df)] <- 0
  colnames(df) <- tolower(c("years", data$key))

  # return dataframe
  if (!chart) {
    return(df)

  # return chart
  } else {
    ylabel <- ifelse(measure == "tonnage", "Catch (t x 1000)",
      "Real 2005 value (million US$)")
    charttitle <- toupper(paste(region, id, measure, "by",
      dimension, sep=" "))

    df <- Reduce(function(...) rbind(...), lapply(colnames(df), function(name) {
      coldata <- df[,name] / ifelse(measure=="tonnage", 10^3, 10^6)
      data.frame(year=years, data=coldata, dim=rep(name, nrow(df)))
    }))

    spectral <- c("#9e0142", "#d53e4f", "#f46d43", "#fdae61", "#fee08b",
      "#ffffbf", "#e6f598", "#abdda4", "#66c2a5",
      "#3288bd", "#5e4fa2", '#666', '#f88', '#88f', '#8f8', '#800', '#080',
      '#008', '#888', '#333')
    chartcolors <- rep(spectral, 10)

    ggplot(df, aes(year, data)) +
      geom_area(aes(fill=dim), position="stack") +
      theme(legend.position="top", legend.key.size=ggplot2::unit(0.5, "cm")) +
      scale_x_continuous(breaks=seq(min(years), max(years), 10),
        expand=c(0, 0)) +
      scale_y_continuous(breaks=pretty_breaks(n=10), expand=c(0, 0)) +
      guides(fill=guide_legend(title=NULL, direction="horizontal",
        byrow=TRUE, ncol=5)) +
      scale_fill_manual(values = chartcolors) +
      labs(y = ylabel, x = "Year") +
      ggtitle(charttitle)
  }
}
