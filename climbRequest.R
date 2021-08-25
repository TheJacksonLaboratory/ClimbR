getToken <- function(username) {
  library(httr)
  if (!any(grepl("climb_pwd", unlist(keyring::key_list())))) keyring::key_set("climb_pwd")
  tokenreq <- GET("http://climb-admin.azurewebsites.net/api/token",
                  authenticate(username, keyring::key_get("climb_pwd")))
  token <- paste0("Bearer ", content(tokenreq)$access_token)
  token
}

climbRequest <- function(method, facet, queryString=None, username) {
  token <- getToken(username)
  url <- paste0("https://api.climb.bio/api/", facet, "?", queryString)
  response <- VERB(method, url, add_headers(.headers = c("Authorization" = token)))
  response}
