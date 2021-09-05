getByName <- function(names, facet, climb_username=NULL, return_response=TRUE) {
  
  if (!is.null(climb_username)) token <- getToken(username)
  
  respL <- list()
  itemsL <- list()
  for (nm in names) {
    qs <- paste0(str_to_sentence(gsub("s", "", facet)),"Name=", nm)
    url <- paste0("https://api.climb.bio/api/", facet, "?", qs)
    res <- GET(url, add_headers(.headers = c("Authorization" = token)))
    cres <- content(res)$data$items
    if(length(cres)==0) itemsL[[nm]] <- NA else itemsL[[nm]] <- cres[[1]]
    if (return_response) respL[[nm]] <- res
    }
  
  df <- data.frame(do.call(rbind,itemsL))
  
  return(list(data=df, response=respL))
  }
