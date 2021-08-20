library(httr)

# Using keyring to store password safely:
# just once for all future sessions
if (!any(grepl("climb_pwd", unlist(keyring::key_list())))) keyring::key_set("climb_pwd")

##### The simple way; currently working
## Retrieving access token

tokenreq <- GET("http://climb-admin.azurewebsites.net/api/token",
                authenticate("annat.haber", keyring::key_get("climb_pwd")))

token <- paste0("Bearer ", content(tokenreq)$access_token)

## Using access token to GET users list
# curl -X GET "https://api.climb.bio/api/workgroupusers?PageSize=100" -H "accept: */*" -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwNzJjMjI4ZC1mMWRiLTRjZDUtODM0OC00ODc5OTYyZmM3NGQiLCJ1c2VyTmFtZSI6ImFubmF0LmhhYmVyIiwiY3VycmVudFdvcmtncm91cElkIjoiNTAiLCJjdXJyZW50V29ya2dyb3VwTmFtZSI6Ik1PREVMLUFEIiwiY3VycmVudEVudmlyb25tZW50SWQiOiI1IiwibmJmIjoxNjI4Njk0NjkwLCJleHAiOjE2Mjg2OTgyOTAsImlhdCI6MTYyODY5NDY5MCwiaXNzIjoiaHR0cDovL2NsaW1iLWFkbWluLmF6dXJld2Vic2l0ZXMubmV0LyIsImF1ZCI6Imh0dHBzOi8vYXBpLmNsaW1iLmJpby8ifQ.mIYEwiCjoC2mc4CNnpR7QCIgdvDUomLpq-UCrjswY_Q"

res <- GET("https://api.climb.bio/api/workgroupusers?PageSize=100",
                      add_headers(.headers = c("Authorization" = token)))

##### The httr complex way; not working yet
## Retrieving access token
climb_oauth_endpoint <- oauth_endpoint(request = NULL, 
                                       authorize = NULL, 
                                       access = NULL, 
                                       base_url = "http://climb-admin.azurewebsites.net/api/token")

climb_oath_app <- oauth_app("climb",
                            key = NULL,
                            secret = keyring::key_get("climb_pwd"))

climb_token <- oauth2.0_token(climb_oauth_endpoint, climb_oath_app, use_basic_auth = TRUE, as_header = TRUE)

## Using access token to GET users list
res <- GET("https://api.climb.bio/api/workgroupusers?PageSize=100",
           config(token = climb_token))

###### Parsing response to yield a matrix with users info
itemsL <- content(res)$data$items 
items_df <- data.frame(do.call(rbind,itemsL))
write.csv(items_df[,-c(1:2)], file="users.csv", quote=FALSE, row.names = FALSE)
