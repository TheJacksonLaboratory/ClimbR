## A function to send a general request
## output is a response object given by package httr (https://httr.r-lib.org/reference/response.html)
## Authentication is done by retrieving a temporary token with getToken.R
## PageSize indicates how many items per page to request
## PageNumber indicates how many pages to request

source("getToken.R")
climbRequest <- function(method, facet, queryString=NULL, PageSize=20, PageNumber=1, climb_username) {
  token <- getToken(climb_username)
  url <- paste0("https://api.climb.bio/api/", facet, "?PageNumber=", PageNumber, "&PageSize=", PageSize, "&", queryString)
  response <- VERB(method, url, add_headers(.headers = c("Authorization" = token)))
  response}
