## A generic API request
## output is a response object given by package httr (https://httr.r-lib.org/reference/response.html)
## Authentication is done by retrieving a temporary token with getToken.R
## queries are provided as a list of key-value pairs added to the default of PageSize and PageNumber
## PageSize indicates how many items per page to request
## PageNumber indicates how many pages to request

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/getToken.R")
climbRequest <- function(method, facetPath, queryList=NULL) {
  
  # check if there is a valid token in the environment
  test <- GET("https://api.climb.bio/api/workgroups", add_headers(.headers = c("Authorization" = token)))
  
  # GET token if not
  if (test$status_code==401) token <- getToken()
  
  # build url including endpoint path and queries
  url <- modify_url("https://api.climb.bio/", path=facetPath, query=queryList)
  
  # send request
  response <- VERB(method, url, add_headers(.headers = c("Authorization" = token)))
  
  response
  }
