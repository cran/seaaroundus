#' Get MTI as a data frame or chart
#'
#' @export
#' @template regionid
#' @param chart boolean to return a chart versus a data frame
#' Default: `FALSE`
#' @param type MTI data set ("mean_trophic_level", "fib_index", or "rmti")
#' Default: "mean_trophic_level"
#' @param transferefficiency float used for FiB index input
#' Default: 0.1
#' @param ... curl options passed on to [crul::HttpClient]
#' @return data frame (or chart) with MTI data
#' @examples
#' marinetrophicindex(region = "eez", id = 76)
#' marinetrophicindex("eez", 76, type="fib_index")
#' marinetrophicindex("eez", 76, type="fib_index", transferefficiency=0.25)
#' \dontrun{
#' marinetrophicindex("eez", 76, chart=TRUE)
#' }
marinetrophicindex <- function(region, id, chart=FALSE, type="mean_trophic_level", transferefficiency=0.1, ...) {

  # call API
  path <- file.path("api/v1", region, "marine-trophic-index/")
  args <- list(region_id = id, transfer_efficiency = transferefficiency)
  data <- callapi(path, args, ...)

  # get the data for the chart
  named_data <- data$values
  names(named_data) <- data$key

  # rmti has 3 data sets
  if (type == "rmti") {
    df <- data.frame(level_1950 = named_data[["RMTI_1950"]][, 2],
                     level_1962 = named_data[["RMTI_1962"]][, 2],
                     level_1968 = named_data[["RMTI_1968"]][, 2],
                     year = named_data[["RMTI_1950"]][, 1])

  } else {
    data <- named_data[[type]]
    df <- data.frame(level = data[, 2], year = data[, 1])
  }

  # return dataframe
  if (!chart) {
    return(df)

  # return chart
  } else {
    ylabel <- switch(type,
                     mean_trophic_level = "Trophic level of the catch",
                     fib_index = "Fishing-in-balance index",
                     rmti = "RMTI")

    title <- switch(type,
                    mean_trophic_level = "Marine Trophic Index",
                    fib_index = "Fishing in Balance Index",
                    rmti = "Region-based Marine Trophic Index")

    years <- as.integer(df$year)

    # rmti has 3 data sets
    if (type == "rmti") {
      graph <- ggplot(data=df, aes(x=year)) +
        geom_path(aes(y=level_1950, colour="blue")) +
        geom_path(aes(y=level_1962, colour="cyan"), na.rm=TRUE) +
        geom_path(aes(y=level_1968, colour="red"), na.rm=TRUE)

    } else {
      graph <- ggplot(data=df, aes(x=year, y=level)) +
        geom_path(colour="blue") + geom_point(colour="blue")
    }

    graph <- graph +
      scale_x_continuous(breaks=seq(min(years), max(years), 10), expand=c(0, 0)) +
      xlab("Year") + ylab(ylabel) + ggtitle(title) + theme(legend.position="none")

    return(graph)
  }
}
