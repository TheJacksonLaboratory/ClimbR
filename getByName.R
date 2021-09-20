## A utility function wrapping a general climbRequest call 
## to get data by record name instead of key
## 

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/climbRequest.R")

getByName <- function(names, facet, return_response=FALSE) {
  # create facetPath
  facetPath <- paste0("api/", facet)
  
  # loop through the names to send GET request
  respL <- list()
  itemsL <- list()
  for (nm in names) {
    # create query e.g., AnimalName from animals facet TODO find in swagger.json instead
    fnm <- paste0(str_to_sentence(gsub("s$", "", facet)),"Name")
    qs <- list(); qs[[fnm]] <- nm # e.g., list(AnimalName=“50101”)
    
    # send request
    res <- climbRequest("GET", facetPath, qs)
    cres <- content(res)$data$items
    
    # parse content
    if(length(cres)==0) {itemsL[[nm]] <- NA
    } else {
      # unlist content while keeping fields with missing values
      itemsL[[nm]] <- sapply(cres[[1]], function(x) ifelse(is.null(x),NA,x))
      }
    # save full response if specified
    if (return_response) respL[[nm]] <- res
    }
  
  # get all content as a dataframe; each row is a record
  df <- data.frame(do.call(rbind,itemsL))
  
  # return content as well as full responses if specified
  return(list(data=df, response=respL))
  }
