## Get the name field of a record from its key
## Used for translating keys given by responses
## Authentication is done by retrieving a temporary token with getToken.R

key2name <- function(key, field, climb_username) {
  facet <- paste0("vocabulary/", field)
  qs <- paste0("key=",key)
  res <- content(climbRequest("GET", facet, qs, climb_username))
  res$data$items[[1]]$name
  }
