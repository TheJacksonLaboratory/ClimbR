## GET a temporary token (valid for 60 minutes)
## Input is climb username
## First time running this function it prompts for climb password, which gets saved in OS keychain. 
## Every time it runs it retrieves a new token if the previous one has expired, using the saved password.

library(httr)

getToken <- function(climb_username) {
  if (!any(grepl("climb_pwd", unlist(keyring::key_list())))) keyring::key_set("climb_pwd")
  tokenreq <- GET("http://climb-admin.azurewebsites.net/api/token",
                  authenticate(climb_username, keyring::key_get("climb_pwd")))
  paste0("Bearer ", content(tokenreq)$access_token)
}