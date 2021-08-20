getToken <- function(username) {
  if (!any(grepl("climb_pwd", unlist(keyring::key_list())))) keyring::key_set("climb_pwd")
  tokenreq <- httr::GET("http://climb-admin.azurewebsites.net/api/token",
                  authenticate(username, keyring::key_get("climb_pwd")))
  paste0("Bearer ", httr::content(tokenreq)$access_token)
}