
#' UMM Query the SKM Syspower API.
#'
#' This function creates a web query url for SKM umms.
#'
#' @param user_id character value. Login name to SKM syspower.
#' @param user_password Password to SKM syspower.
#' @param interval Character value. "hour", "day" or "week". Weekly interval will be parsed as ISO week (see package ISOweek for parsing this data_format).
#' @param start_time Character value with format YYYY-mm-dd, dd-mm-YYYY, dd.mm.YYYY or mm/dd/YYYY.
#' @param end_time  Character value with format YYYY-mm-dd, dd-mm-YYYY, dd.mm.YYYY or mm/dd/YYYY (YYYY-mm-dd hh:mm). "0" (wich is the default) will return today's date or the latest non-empty date.
#' @param type Character value. production, transmission or station.
#' @param areas Character string or vector. If type == production then Nordpool, DK1, DK2, SE1, SE2, SE3, SE4, NO1, NO2, NO3, NO4, NO5, EE, LV, LT, FI are valid. If type == transmission then Belarus, Estonia, Denmark, Finland, Germany, Latvia, Lithuania, Netherlands, Norway, Poland, Russia, Sweden are valid.
#' @param internalorfuels Character vector. If type == production then Nuclear, Wind, Coal, Gas, Hydro, Oil, Other, ReducedLoad. If type == transmission then "yes" or "no" for include internal lines.
#' @param accrow character value. "yes" or "no" for include accumulated row.
#' @param data_format "no2" (default). (Later:"no", "dk", "se", "us" might be added).
#' @param headers "yes" (default)
#' @export
skm_ummquery <- function(user_id, user_password, interval, start_time, end_time, type, areas, internalorfuels, headers = "yes", accrow = "no", data_format = "se"){
  	
  stopifnot(is.character(user_id), !is.null(user_id))
  stopifnot(is.character(user_password), !is.null(user_password))
  stopifnot(is.character(interval), !is.null(interval))
  stopifnot(is.character(start_time), !is.null(start_time))
  stopifnot(is.character(end_time), !is.null(end_time))
  stopifnot(is.character(type), !is.null(type))
  stopifnot(is.character(accrow), !is.null(accrow))
  
  interval <- tolower(interval)
  data_format <- tolower(data_format)
  areas <- toupper(areas)

  stopifnot(interval == "hour" | interval == "day" | interval == "week")
  stopifnot(data_format == "se")
  #stopifnot(empty_data == "yes" | empty_data == "no" | empty_data == "remove" | empty_data == "replace")
  stopifnot(type == "production" | type == "transmission" | type == "station")
  
  
  if(type == "production"){
  	  
      areas <- stringr::str_replace(string = areas, pattern = "NORDPOOL", replacement = "Nordpool")
  
      query <- list(user = user_id,
                    pass = user_password,
                    interval = interval,
                    start = start_time,
                    end = end_time,
                    format = data_format,
                    acc = accrow,
                    type = 0,
                    areas = areas,
                    headers = headers,
                    fuels = internalorfuels,
                    output = "html")
      
  } else if (type == "transmission") {
    query <- list(user = user_id,
                  pass = user_password,
                  interval = interval,
                  start = start_time,
                  end = end_time,
                  format = data_format,
                  type = 1,
                  headers = headers,
                  areas = areas,
                  internal = internalorfuels,
                  output = "html")
    
  } else {

  	query <- list(user = user_id,
                  pass = user_password,
                  interval = interval,
                  start = start_time,
                  end = end_time,
                  format = data_format,
                  type = 3,
                  objectid = internalorfuels,
                  headers = headers,
                  output = "html")

  }
  
  
  ## build url
  skm_url <- "http://syspower.skm.no/webquery/ummquery.aspx"
  
  skm_url <- httr::parse_url(skm_url)
  skm_url$query <- query
  skm_url$query <- lapply(X = skm_url$query, FUN = paste, collapse = ',')
  
  skm_url <- httr::build_url(skm_url)
  
  ## Get data
   skm_data <- httr::content(x = httr::GET(skm_url, as = "text", encoding = "UTF-8"))
   
   if(headers == "yes"){
     skm_data <- XML::readHTMLTable(skm_data,  header = TRUE, stringsAsFactors = FALSE, del = ",")
   } else if (headers == "no"){
     #skm_data <- readHTMLTable(skm_data, header = FALSE, stringsAsFactors = FALSE, del = ",")
     stop("Headers has to be yes.")
   } else {
     stop("Headers should be yes or no")
   }
   skm_data <- skm_data[[1]]
   
   ## parse date
   if (data_format == "se"){
     if (interval == "hour"){
       skm_data[, 1] <- lubridate::ymd_hm(skm_data[, 1], tz = "UTC")
     } else if (interval == "day"){
       skm_data[, 1] <- lubridate::ymd(skm_data[, 1], tz = "UTC")
     } else if (interval == "week"){
       if (stringr::str_length(skm_data[1,1]) >= 8 & stringr::str_length(skm_data[1,1]) <= 10){
         try(skm_data[, 1] <- lubridate::ymd(skm_data[, 1], tz = "UTC"))
       } else {
         try(skm_data[, 1] <- paste0(stringr::str_sub(skm_data[, 1], start = 1, end = 4), 
                                     "-W", 
                                     stringr::str_sub(skm_data[, 1], start = 5, end = 6), 
                                     "-7"))
       }
     } else {
       stop("Interval can only be hour, day or week.")
     }
   } else {
     stop("Only the no2 data format is working right now.")
   }
   
   skm_data[, c(2:length(colnames(skm_data)))] <- sapply(skm_data[, c(2:length(colnames(skm_data)))], as.numeric)

   ## Clean column names.
   colnames(skm_data) <- stringr::str_replace_all(string = colnames(skm_data), pattern = " --> ", replacement = "to")
   
   return(skm_data)  
}

