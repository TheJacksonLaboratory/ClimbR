## A generic API request
## output is a response object given by package httr (https://httr.r-lib.org/reference/response.html)
## Authentication is done by retrieving a temporary token with getToken.R
## PageSize indicates how many items per page to request
## PageNumber indicates how many pages to request

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/getToken.R")
climbRequest <- function(method, facet, queryString=NULL, climb_username=NULL, PageSize=100, PageNumber=10) {
  if (!is.null(climb_username)) token <- getToken(climb_username)
  url <- paste0("https://api.climb.bio/api/", facet, "?PageNumber=", PageNumber, "&PageSize=", PageSize, "&", queryString)
  response <- VERB(method, url, add_headers(.headers = c("Authorization" = token)))
  response}
