pins::board_register_github(repo = "TheJacksonLaboratory/ClimbR", token = "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")
pins::pin_get("getToken.R", board = "github")

getByID <- function(ids, facet, username) {
  token <- getToken(username)
  itemsL <- list()
  for (id in ind.ids) {
    url <- paste0("https://api.climb.bio/api/", facet, "/", id)
    res <- GET(url, add_headers(.headers = c("Authorization" = token)))
    itemsL[[id]] <- content(res)$data
  }
  items_df <- data.frame(do.call(rbind,itemsL))
  items_df
}

