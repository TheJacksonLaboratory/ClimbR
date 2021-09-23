## A generic API request following https://api.climb.bio/docs/index.html
## output is a response object given by package httr (https://httr.r-lib.org/reference/response.html)
## Authentication is done by retrieving a temporary token with getToken.R
## queries are provided as a list of key-value pairs,e.g, list(AnimalName="50101", AnimalNameSearchOptions="StartsWith")

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/getToken.R")
climbRequest <- function(method, endpointPath, queryList=NULL) {
  
  # check if there is a token in the environment
  if (class(try(token, silent=TRUE))=='try-error') {
    # if there is none, get one
    token <- getToken()
    } else {
    # if there is one already, check if it is valid 
    test <- GET("https://api.climb.bio/api/Diagnostics", add_headers(Authorization = token))
    # if existing one is not valid, get new one
    if (test$status_code==401) token <- getToken()
    }
  
  # build url including endpoint path and queries
  url <- modify_url("https://api.climb.bio/", path=endpointPath, query=queryList)
  
  # send request
  response <- VERB(method, url, add_headers(.headers = c(Authorization = token)))
  
  response
  }
