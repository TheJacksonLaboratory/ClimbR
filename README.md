# ClimbR

R API wrapper for [Climb.bio](https://api.climb.bio/docs/index.html).  
Still in development; not fully tested.  
Based on the [httr](https://CRAN.R-project.org/package=httr) package.  
climbRequest.R is a generic function, enabling any request with any query parameters.   
getByAnimalName is a wrapper to get all available information from any given facet based on the user-provided animal names rather than the climb-generated IDs.  
Authentication is done by retrieving a temporary token (valid for 60 minutes) with getToken.R  
See annotations inside the scripts for details.  
