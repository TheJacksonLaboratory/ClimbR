## A generic API request following https://api.climb.bio/docs/index.html
## endpointPath is as listed in the API docs for each facet and sub-facet, without the "/api/" prefix
## Authentication is done by retrieving a temporary token with getToken.R
## queries are provided as a list of key-value pairs,
## e.g, list(AnimalName="50101", AnimalNameSearchOptions="StartsWith")
## output is a list including the full response as returned by package 
## httr (https://httr.r-lib.org/reference/response.html) along with the following objects:
## parsed data is returned as dataframe with records in rows and fields in columns
## Page number, total item count, and total page count returned as integers.

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/getToken.R")
climbRequest <- function(method, endpointPath, queryList=NULL) {
  
  # check if there is a token in the environment
  istoken <- class(try(token, silent=TRUE))
  # if there is one already, check that it is valid 
  test <- 0
  if (istoken=='character') {
    test <- GET("https://api.climb.bio/api/Diagnostics", 
                add_headers(Authorization = token))$status_code}
  # if there isn't any token, or it isn't valid, get a new one
  if (istoken=='try-error' | test==401) getToken()
  
  # build url including endpoint path and queries
  url <- modify_url("https://api.climb.bio/", path=paste0("/api/", endpointPath), query=queryList)
  
  # send request
  resp <- VERB(method, url, add_headers(.headers = c(Authorization = token)))

  # parse response content 
  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)
  df <- as.data.frame(do.call(rbind, parsed$data$items))
  
  list(
      errors = parsed$errors,
      totalItemCount = parsed$data$totalItemCount,
      pageCount = parsed$data$pageCount,
      pageNumber = parsed$data$pageNumber,
      data = df,
      response = resp
  )
  }