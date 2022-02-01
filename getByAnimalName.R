# A function to GET information from various facets based on animalName 
# which is provided by the user rather than the climb-generated ID
# input is a vector of (one or more) animal names as characters
# output is a data frame with each row corresponds to one animal
# and columns are all the fields available from climb

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/climbRequest.R")

getByAnimalName <- function(animalNames, facet, queryField="animalId") {
  itemsL <- list()
  for (nm in animalNames) {
    resp <- climbRequest("GET", "api/animals", list(AnimalName=nm))
    if(length(resp$data)==0) resp$data <- NA_character_
    itemsL[[nm]] <- resp$data
    }
  df <- as.data.frame(do.call(rbind, itemsL))
  if (facet=="animals") {return(df)
    } else {
      if (! queryField %in% colnames(df)) {
        cat("queryField is not in animals facet response, please select from the following:\n", sort(colnames(df)))
      }
      itemsL <- list()
      for (nm in animalNames) {
        iid <- df[nm, queryField]
        if (is.na(iid)) {itemsL[[nm]] <- NA_character_}
        if (!is.na(iid)) {
          qL <- list(iid) ; names(qL) <- queryField
          resp <- climbRequest("GET", paste0("api/",facet), queryList=qL)
          if(length(resp$data)==0) {resp$data <- NA_character_
          } else {resp$data <- mutate(resp$data, animalName=nm)}
          itemsL[[nm]] <- resp$data
        }
      }
      df <- as.data.frame(do.call(rbind, itemsL))
      df$animalName[which(is.na(df$animalName))] <- rownames(df)[which(is.na(df$animalName))]
      return(df)
    }
  }