# A function to GET information from various facets based on animalName 
# which is provided by the user rather than the climb-generated ID
# input is a vector of (one or more) animal names as characters
# output is a data frame with each row corresponds to one animal
# and columns are all the fields available from climb

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/climbRequest.R")

getByAnimalName <- function(animalnames, facet) {
  itemsL <- list()
  for (nm in animalnames) {
    resp <- climbRequest("GET", "api/animals", list(AnimalName=nm))
    if(length(resp$data)==0) resp$data <- NA_character_
    itemsL[[nm]] <- resp$data
    }
  df <- as.data.frame(do.call(rbind, itemsL))
  if (facet=="animals") {return(df)
    } else {
      itemsL <- list()
      for (nm in animalnames) {
        iid <- df[nm, "animalId"]
        if (is.na(iid)) {itemsL[[nm]] <- NA_character_}
        if (!is.na(iid)) {
          resp <- climbRequest("GET", paste0("api/",facet), list("AnimalID"=iid))
          if(length(resp$data)==0) resp$data <- NA_character_
          itemsL[[nm]] <- resp$data
        }
      }
      return(as.data.frame(do.call(rbind, itemsL)))
    }
  }