# Part 1 - Tweets and Max Tweet Counts

install.packages("twitteR") 
install.package("dplyr")
library (twitteR)
library(dplyr)

api_key <- "bjNHw9ZB2W7TL5GZpAXBiEYGA" #in the quotes, put your API key 
api_secret <- "rkzmLcl4l75tQjQcuNiqFUNDWfw9R4mgqemvXTu7LAADcYR4Lg" #in the quotes, put your API secret token 
token <- "479111182-J5KSqQKb2OISYdIBWI1XM3hOFeentxLiThA1IfL1" #in the quotes, put your token 
token_secret <- "5Y5TRhFfrLWjNDCWv3b4XeWhiQixzvqT79LnvvWGVHUyL" #in the quotes, put your token secret

setup_twitter_oauth(api_key, api_secret, token, token_secret)

# tweets
tweets <- searchTwitter("JP Morgan OR #JPMorgan OR @JPMorgan", n = 200, lang = "en")
#strip retweets
strip_retweets(tweets)

#convert to data frame using the twListtoDF function
df <- twListToDF(tweets) #extract the data frame save it locally
saveRDS(df, file="tweets.rds")
df1 <- readRDS("tweets.rds")


#clean up any duplicate tweets from the data frame using #dplyr::distinct
dplyr::distinct(df1)

winner <-df1 %>% select(text,retweetCount,screenName,id )%>% filter(retweetCount == max(retweetCount))
View(winner)

# Part 2 - Geolocations
                            
# mapping code  
# source code: https://opensource.com/article/17/6/collecting-and-mapping-twitter-data-using-r
install.packages("leaflet") 
install.packages("maps") 
library(leaflet) 
library(maps)

tweets <- searchTwitter("Fed", n = 200, lang = "en")

tweets.df <-twListToDF(tweets)

write.csv(tweets.df, "/Users/johnmara/tweets.csv")



mymap <- read.csv("tweets.csv", stringsAsFactors = FALSE)

m <- leaflet(mymap) %>% addTiles()

m %>% addCircles(lng = ~longitude, lat = ~latitude, popup = mymap$type, weight = 8, radius = 40, color = "#fb3004", stroke = TRUE, fillOpacity = 0.8)
