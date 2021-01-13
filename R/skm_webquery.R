#' Query SKM Syspower API.
#'
#' This function creates a web query url and reads financial and
#' other data from SKM syspower into a data.frame.
#'
#' @param token character value. Token provided by SKM syspower on new platform SYSPOWER5.
#' @param series_name character value. Ex: "NPENOYR15", "SPOT", "EEX", "EURSEKCAL15", "EURDKKQ414" or another value from the webquery on syspower.skm.no
#' @param interval Character value. "hour", "day" or "week". Weekly interval will be parsed as ISO week (see package ISOweek for parsing this data_format).
#' @param start_time Character value with format YYYY-mm-dd, dd-mm-YYYY, dd.mm.YYYY or mm/dd/YYYY.
#' @param end_time  Character value with format YYYY-mm-dd, dd-mm-YYYY, dd.mm.YYYY or mm/dd/YYYY. "0" (wich is the default) will return today's date or the latest non-empty date.
#' @param empty_data "yes" or "no" (later: "remove" and "replace" will be added.)
#' @param currency NULL, "EUR", "DKK", "GPL", "SEK", "USD" or "NOK".
#' @export
skm_webquery <- function(token, series_name, interval, start_time, end_time = "0", empty_data = "no" , currency=NULL){
  
  headers <- "yes"
  time_stamp <- "no"
  data_format <- "no2"
  
  ## Test input
  stopifnot(is.character(token), !is.null(token))
  stopifnot(is.character(series_name), !is.null(series_name))
  stopifnot(is.character(interval), !is.null(interval))
  stopifnot(is.character(start_time), !is.null(start_time))
  stopifnot(is.character(end_time), !is.null(end_time))
  stopifnot(is.character(headers), !is.null(headers))
  stopifnot(is.character(empty_data), !is.null(empty_data))
  
  # Make the input lowercase as some variables needs to be
  # or the API call will fail.
  headers <- tolower(headers)
  interval <- tolower(interval)
  currency <- toupper(currency)
  data_format <- tolower(data_format)
  empty_data <- tolower(empty_data)
  series_name <- toupper(series_name)
  
  # Test if variables are correctly specified
  stopifnot(headers == "yes" | headers == "no")
  stopifnot(interval == "hour" | interval == "day" | interval == "week")
  stopifnot(is.null(currency) | currency == "EUR" | currency == "NOK" | currency == "SEK" | currency == "DKK" | currency == "GBP" | currency == "USD")
  stopifnot(data_format == "dk" | data_format == "se" | data_format == "no" | data_format == "no2" | data_format == "us")
  stopifnot(empty_data == "yes" | empty_data == "no" | empty_data == "remove" | empty_data == "replace")
  stopifnot(length(series_name) <= 40)
  
  # Create the query
  query <- list(token = token,
                interval = interval,
                start = start_time,
                end = end_time,
                series = series_name,
                format = data_format,
                headers = headers,
                emptydata = empty_data,
                currency = currency,
                updates = time_stamp,
                fileformat = "html")
  
  
  ## build url
  skm_url <- "https://syspower5.skm.no/api/webquery/execute"
  
  skm_url <- httr::parse_url(skm_url)
  skm_url$query <- query
  skm_url$query <- lapply(X = skm_url$query, FUN = paste, collapse = ',')
  
  skm_url <- httr::build_url(skm_url)
  
  ## Get data
  skm_data <- httr::content(x = httr::GET(skm_url), as = "text", encoding = "UTF-8")

  if(headers == "yes"){
    skm_data <- XML::readHTMLTable(skm_data, 
                                   header = TRUE, 
                                   colClasses = c("character", rep("numeric", length(series_name))), 
                                   stringsAsFactors = FALSE)
  } else if (headers == "no"){
    skm_data <- XML::readHTMLTable(skm_data, header = FALSE, 
                                   stringsAsFactors = FALSE)
  } else {
    stop("Headers should be either yes or no")
  }
  
  # The first table should be were the data is
  skm_data <- skm_data[[1]]
  
  ## parse dates
  if (data_format == "no2"){
    if (interval == "hour"){
      skm_data[, 1] <- lubridate::dmy_hm(skm_data[, 1], tz = "UTC")
    } else if (interval == "day"){
      skm_data[, 1] <- lubridate::dmy(skm_data[, 1], tz = "UTC")
    } else if (interval == "week"){
      skm_data[, 1] <- paste0(stringr::str_sub(skm_data[, 1], start = 1, end = 4), 
                              "-W", 
                              stringr::str_sub(skm_data[, 1], start = 5, end = 6), 
                              "-7")
    } else {
      stop("Interval can only be hour, day or week.")
    }
  } else {
    stop("Only the no2 data format is working right now.")
  }

  return(skm_data)
}

  
