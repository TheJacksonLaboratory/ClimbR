## GET a temporary token (valid for 60 minutes)
## Input is climb username; if it isn't provided as an argument the function will prompt for it.  
## First time running this function it prompts for climb password, which gets saved in OS keychain. 
## Every time it runs it retrieves a new token, using the saved password.
## If authorization fails, it prompts for password and tries again.
## If request fails again it returns the full request with a message. 
## If request succeeds it returns token only.

library(httr)

getToken <- function(climb_username=NULL, climb_workgroup=NULL) {
  
  # prompt for username if not provided 
  if (is.null(climb_username)) climb_username <- readline(prompt = "Enter climb username: ")
  
  # prompt for password if not already saved in the local keychain
  if (!any(grepl("climb_pwd", unlist(keyring::key_list())))) keyring::key_set("climb_pwd")

  # GET token
  tokenreq <- GET("http://climb-admin.azurewebsites.net/api/token",
                  authenticate(climb_username, keyring::key_get("climb_pwd")))
  
  # check error, reset password if needed and retry
  if (tokenreq$status_code==401) {
    keyring::key_set("climb_pwd")
    tokenreq <- GET("http://climb-admin.azurewebsites.net/api/token",
                    authenticate(climb_username, keyring::key_get("climb_pwd")))
  }
  
  # TODO set up workgroup
  # getWorkgroup()
  # setWorkgroup()
  
  # return token if request is successful; return full response otherwise
  if (tokenreq$status_code==200) {
    return(paste0("Bearer ", content(tokenreq)$access_token))
    } else {
      cat("Request for token failed with status code:", tokenreq$status_code, "\n",
          "Check response for details")
      return(tokenreq)
      }
  }