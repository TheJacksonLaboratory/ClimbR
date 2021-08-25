## A function to send a general request
## output is a response object given by package httr (https://httr.r-lib.org/reference/response.html)
## Authentication is done by retrieving a temporary token with getToken.R

source("getToken.R")
climbRequest <- function(method, facet, queryString=None, climb_username) {
  token <- getToken(climb_username)
  url <- paste0("https://api.climb.bio/api/", facet, "?", queryString)
  response <- VERB(method, url, add_headers(.headers = c("Authorization" = token)))
  response}
