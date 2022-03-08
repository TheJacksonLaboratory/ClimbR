## GET a temporary token (valid for 60 minutes)
## Input is climb username; if it isn't provided as an argument the function will 
## either look for it in .Renviron or prompt for it.  
## The function first looks for password in .Renviron, then in OS keychain. 
## If it can't find it on either, it prompts for climb password, and saves it in OS keychain. 
## See https://cran.r-project.org/web/packages/httr/vignettes/secrets.html 
## for how to set up credential in either .Renviron or keychain.
## Every time it runs it retrieves a new token, using the saved password.
## If authorization fails, it prompts for password and tries again.
## If request fails again it returns the full request with a message. 
## If request succeeds it returns token only. 
## Token is return into the global environment.

library(httr)

getToken <- function(climb_username=NULL, climb_workgroup=NULL) {
  
  # prompt for username if not provided 
  if (is.null(climb_username)) {
    climb_username <- Sys.getenv("climb_username")
    if (climb_username=="") {
      climb_username <- readline(prompt = "Enter climb username: ")
    }
  }
  
  # get or set password
  if (!Sys.getenv("climb_pwd")=="") { climb_pwd <- Sys.getenv("climb_pwd")
  } else if (any(grepl("climb_pwd", unlist(keyring::key_list())))) {
    climb_pwd <- keyring::key_get("climb_pwd")
  } else keyring::key_set("climb_pwd")

  # GET token
  tokenreq <- GET("http://climb-admin.azurewebsites.net/api/token",
                  authenticate(climb_username, climb_pwd))
  
  # check error, reset password if needed and retry
  if (tokenreq$status_code==401) {
    keyring::key_set("climb_pwd")
    tokenreq <- GET("http://climb-admin.azurewebsites.net/api/token",
                    authenticate(climb_username, climb_pwd))
  }
  
  # TODO set up workgroup
  # getWorkgroup()
  # setWorkgroup()
  
  # return token if request is successful; return full response otherwise
  if (tokenreq$status_code==200) {
    token <<- paste0("Bearer ", content(tokenreq)$access_token)
    } else {
      cat("Request for token failed with status code:", tokenreq$status_code, "\n",
          "Check response for details")
      token <<- tokenreq
      }
  }