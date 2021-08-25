# ClimbR

R API wrapper for [Climb.bio](https://api.climb.bio/docs/index.html).  
Still in development; not fully tested.  
Based on the [httr](https://CRAN.R-project.org/package=httr) package.  
See annotations inside the scripts for details.  
Authentication is done by retrieving a temporary token (valid for 60 minutes) with getToken.R  
All functions take climb username as an argument. First time running any function, it prompts for climb password, which gets saved in OS keychain. Every time a function runs it retrieves a new token if the previous one has expired, using the saved password.
