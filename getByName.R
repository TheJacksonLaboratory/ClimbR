source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/climbRequest.R")

getByName <- function(names, facet, return_response=FALSE, climb_username=NULL, PageSize=100, PageNumber=10) {
  
  respL <- list()
  itemsL <- list()
  for (nm in names) {
    qs <- paste0(str_to_sentence(gsub("s$", "", facet)),"Name=", nm)
    url <- paste0("https://api.climb.bio/api/", facet, "?", qs)
    res <- climbRequest("GET", facet, qs, climb_username, PageSize, PageNumber)
    cres <- content(res)$data$items
    if(length(cres)==0) itemsL[[nm]] <- NA else itemsL[[nm]] <- cres[[1]]
    if (return_response) respL[[nm]] <- res
    }
  
  df <- data.frame(do.call(rbind,itemsL))
  
  return(list(data=df, response=respL))
  }
