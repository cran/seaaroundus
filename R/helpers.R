# get the base URL of the API
getapibaseurl <- function() "http://api.seaaroundus.org"

# call API with GET and return data
callapi <- function(path, args = list(), ...) {
  conn <- crul::HttpClient$new(
    url = getapibaseurl(),
    headers = list(`X-Request-Source` = "r"),
    opts = list(followredirects = TRUE, ...)
  )
  resp <- conn$get(path = path, query = args)
  resp$raise_for_status()
  jsonlite::fromJSON(resp$parse("UTF-8"))$data
}

# call API with POST and return data
postapi <- function(path, body, ...) {
  conn <- crul::HttpClient$new(
    url = getapibaseurl(),
    headers = list(`X-Request-Source` = "r"),
    opts = list(...)
  )
  resp <- conn$post(path = path, body = body)
  resp$raise_for_status()
  jsonlite::fromJSON(resp$parse("UTF-8"))$data
}

# make maps look nicer
# from: https://gist.github.com/hrbrmstr/33baa3a79c5cfef0f6df
theme_map <- function(base_size=9, base_family="") {
  theme_bw(base_size=base_size, base_family=base_family) %+replace%
  theme(axis.line=element_blank(),
    axis.text=element_blank(),
    axis.ticks=element_blank(),
    axis.title=element_blank(),
    panel.background=element_rect(fill='#81A6D6', colour='#333333'),
    panel.border=element_blank(),
    panel.grid=element_blank(),
    panel.spacing=unit(0, "lines"),
    plot.background=element_blank(),
    legend.justification=c(0,0),
    legend.position=c(0,0)
  )
}

assert <- function(x, y) {
  if (!is.null(x)) {
    if (any(!vapply(x, class, "") %in% y)) {
      stop(deparse(substitute(x)), " must be of class ",
           paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}
