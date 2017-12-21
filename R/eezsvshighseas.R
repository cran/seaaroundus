#' Get data for percent of High Seas vs. EEZ catches as a data frame or chart
#'
#' @export
#' @param chart (boolean) return a chart (`TRUE`) versus a data frame (`FALSE`)
#' Default: `FALSE`
#' @param ... curl options passed on to [crul::HttpClient()]
#' @return data frame (or chart) with High Seas vs. EEZ data for the requested
#' region over time
#'
#' @examples
#' eezsvshighseas()
#' \dontrun{
#' eezsvshighseas(chart=TRUE)
#' }

eezsvshighseas <- function(chart = FALSE, ...) {
  assert(chart, "logical")

  # call API
  data <- callapi(paste("api/v1/global", "eez-vs-high-seas", "", sep="/"),
    ...)

  # create dataframe
  values <- data$values
  years <- as.numeric(values[[1]][,1])
  df <- data.frame(years, as.double(values[[1]][,2]),
    as.double(values[[2]][,2]), stringsAsFactors = FALSE)
  colnames(df) <- c("year", "eez_percent_catch", "high_seas_percent_catch")

  # return dataframe
  if (!chart) {
    return(df)

  # return chart
  } else {
    df <- Reduce(function(...) rbind(...), lapply(colnames(df), function(name) {
      data.frame(year=years, data=df[,name], dim=rep(name, nrow(df)))
    }))

    plot <- ggplot(df, aes(year, data)) +
      geom_area(aes(fill=dim), position="stack") +
      theme(legend.position="top", legend.key.size=unit(8, "native")) +
      scale_x_continuous(breaks=seq(min(years), max(years), 10), expand=c(0, 0)) +
      scale_y_continuous(breaks=seq(0, 100, 20), limits=c(0, 100), expand=c(0, 0)) +
      guides(fill=guide_legend(title=NULL, direction="horizontal", byrow=TRUE, ncol=5)) +
      scale_fill_manual(values=c("#ADC6E9", "#1776B6")) +
      labs(y = "Percent of global catch", x = "Year") +
      ggtitle("Percent of landings in EEZs vs. High Seas")
    return(plot)
  }
}
