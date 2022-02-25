## This function retrieves all information from one facet through a query field that links it to another facet.
## queryValues is a character vector of (one or more) query values to query facet1.
## facet1 and queryField1 are a single character object specifying the facet and field that match queryValues.
## facet2 is a single character object specifying the facet from which to retrieve the information based on queryField2
## queryField2 links facet1 and facet2.
## This function first retrieves values for queryField2 from facet1 based on queryValues,
## then uses the retrieved values to query facet2 based on queryField2. 
## Output is a data frame with each row corresponds to information from facet2 for one element in queryValues.
## Query values that yield no data in the response are returned as an empty row 
## with only the query value in the query field

source("https://raw.github.com/TheJacksonLaboratory/ClimbR/master/climbGET.R")

climbGET2 <- function(queryValues, facet1, queryField1, facet2=NULL, queryField2=NULL) {
  df1 <- climbGET(queryValues, facet1, queryField1)
  if (is.null(queryField2)) {return(df1)
  } else {
    if (! queryField2 %in% colnames(df1)) {
      cat("queryField2 is not in facet1 response, please select from the following:", sort(colnames(df1)), sep="\n")
    }
    qv2 <- df1[[queryField2]]
    df2 <- climbGET(qv2, facet2, queryField2)
    df2[[queryField1]] <- queryValues
    return(df2)
  }
}