source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/climbRequest.R")

climbPOST <- function(facet, endpoint, dataFrame=NULL, dataFile=NULL) {
  if(is.null(dataFrame)) {data <- read.csv(dataFile, na.strings = c("", "NA"), as.is=TRUE)
  } else data <- dataFrame
  data.js <- toJSON(data)
  resp <- climbRequest("POST", endpointPath=paste0("api/",facet, "/", endpoint), body=data.js)
  
}