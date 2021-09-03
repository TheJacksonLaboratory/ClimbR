## Get the name field of a record from its key
## Used for translating keys given by responses
## Authentication is done by retrieving a temporary token with getToken.R

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/climbRequest.R")
key2name <- function(key, facet, field=NULL, climb_username=NULL) {
  if (facet=="vocabularies") facet <- paste0("vocabulary/", field)
  qs <- paste0(str_to_sentence(gsub("s", "", facet)),"key=", key)
  res <- content(climbRequest("GET", facet, qs, climb_username=climb_username))
  res$data$items[[1]]$name
  }
