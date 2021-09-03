## GET all available content for a record by facet and climb ID.  
## Note: not all facets can be retrieved by ID; see https://api.climb.bio/docs/index.html
## multiple IDs can be provided as a character vector.
## output is a dataframe object with records as rows
## Authentication is done by retrieving a temporary token with getToken.R

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/getToken.R")
getByID <- function(ids, facet, climb_username=NULL) {
  if (!is.null(climb_username)) token <- getToken(username)
  itemsL <- list()
  for (id in ind.ids) {
    url <- paste0("https://api.climb.bio/api/", facet, "/", id)
    res <- GET(url, add_headers(.headers = c("Authorization" = token)))
    itemsL[[id]] <- content(res)$data
    }
  data.frame(do.call(rbind,itemsL))
  }

