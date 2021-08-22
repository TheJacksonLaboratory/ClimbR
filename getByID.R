getToken <- function(username) {
  library(httr)
  if (!any(grepl("climb_pwd", unlist(keyring::key_list())))) keyring::key_set("climb_pwd")
  tokenreq <- GET("http://climb-admin.azurewebsites.net/api/token",
                  authenticate(username, keyring::key_get("climb_pwd")))
  paste0("Bearer ", content(tokenreq)$access_token)
}

getByID <- function(ids, facet, username) {
  token <- getToken(username)
  itemsL <- list()
  for (id in ind.ids) {
    url <- paste0("https://api.climb.bio/api/", facet, "/", id)
    res <- GET(url, add_headers(.headers = c("Authorization" = token)))
    itemsL[[id]] <- content(res)$data
    }
  data.frame(do.call(rbind,itemsL))
  }

