getByName <- function(names, facet, climb_username=NULL) {
  
  if (!is.null(climb_username)) token <- getToken(username)
  
  itemsL <- list()
  for (nm in names) {
    qs <- paste0(str_to_sentence(gsub("s", "", facet)),"Name=", nm)
    url <- paste0("https://api.climb.bio/api/", facet, "?", qs)
    res <- GET(url, add_headers(.headers = c("Authorization" = token)))
    itemsL[[nm]] <- content(res)$data$items[[1]]
    }
  
  df <- data.frame(do.call(rbind,itemsL))
  df
  }
