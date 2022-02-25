## A function to GET all information from a given facet for a number of query values 
## queryValues is a character vector of (one or more) query values.
## queryField is a single character object specifying the field in facet that matches the query values.
## Output is a data frame with each row corresponds to one query value.
## Query values that yield no data in the response are returned as an empty row 
## with only the query value in the query field

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/climbRequest.R")

climbGET <- function(queryValues, facet, queryField) {
  df <- data.frame()
  for (qi in queryValues) {
    cat("getting data from",facet,"facet for",queryField,"==",qi,"\n")
    qL <- list(qi) ; names(qL) <- queryField
    resp <- climbRequest("GET", paste0("api/",facet), queryList=qL)
    if(length(resp$data)==0) resp$data <- NA_character_
    df <- rbind(df, resp$data)
  }
  qf <- colnames(df)[match(str_to_lower(queryField), str_to_lower(colnames(df)))]
  df[[qf]] <- queryValues
  return(df)
}
