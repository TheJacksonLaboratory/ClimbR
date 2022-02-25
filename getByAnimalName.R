# A function to GET information from various facets based on animalName 
# that is provided by the user rather than the climb-generated ID.
# input is a character vector of (one or more) animal names.
# queryField is the field from animals facet that links the animal records 
# with those on the requested facet.
# output is a data frame with each row corresponds to one animal
# and columns are all the fields available from climb for that facet.

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/climbGET.R")

getByAnimalName <- function(animalNames, facet, queryField="animalId") {
  itemsL <- list()
  for (nm in animalNames) {
    cat("getting data from animal facet for",nm,"\n")
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
        cat("getting data from",facet,"facet for",nm,"based on",queryField,"\n")
        iid <- df[df$animalName==nm, queryField]
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