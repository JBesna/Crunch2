# Part 1 - Tweets and Max Tweet Counts

install.packages("twitteR") 
install.package("dplyr")
install.packages("stringr")
library (twitteR)
library(dplyr)
library(stringr)

api_key <- "bjNHw9ZB2W7TL5GZpAXBiEYGA" #in the quotes, put your API key 
api_secret <- "rkzmLcl4l75tQjQcuNiqFUNDWfw9R4mgqemvXTu7LAADcYR4Lg" #in the quotes, put your API secret token 
token <- "479111182-J5KSqQKb2OISYdIBWI1XM3hOFeentxLiThA1IfL1" #in the quotes, put your token 
token_secret <- "5Y5TRhFfrLWjNDCWv3b4XeWhiQixzvqT79LnvvWGVHUyL" #in the quotes, put your token secret

setup_twitter_oauth(api_key, api_secret, token, token_secret)

# tweets
tweets <- searchTwitter('Goldman Sachs', n = 6500, lang = "en")
#strip retweets
strip_retweets(tweets)

#convert to data frame using the twListtoDF function
df <- twListToDF(tweets) #extract the data frame save it locally
saveRDS(df, file="tweets.rds")
df1 <- readRDS("tweets.rds")
df1 <- df1[df1$isRetweet==FALSE,]

#remove duplicate tweets from the data frame using #dplyr::distinct
df1 <- dplyr::distinct(df1)

# convert to lower case
df1$text <- str_to_lower(df1$text, locale = "en")
# clean data
unclean_tweet <- df1$text

clean_tweet = gsub("&amp", "", unclean_tweet)
clean_tweet = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet)
clean_tweet = gsub("@\\w+", "", clean_tweet)
clean_tweet = gsub("[[:punct:]]", "", clean_tweet)
clean_tweet = gsub("[[:digit:]]", "", clean_tweet)
clean_tweet = gsub("http\\w+", "", clean_tweet)
clean_tweet = gsub("[ \t]{2,}", "", clean_tweet)
clean_tweet = gsub("^\\s+|\\s+$", "", clean_tweet) 

# additional cleaning
#get rid of unnecessary spaces
clean_tweet <- str_replace_all(clean_tweet," "," ")
# Get rid of URLs
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
clean_tweet <- removeURL(clean_tweet)
#clean_tweet <- str_replace_all(clean_tweet, "http://t.co/[a-z,A-Z,0-9]*{8}","")
# Take out retweet header, there is only one
clean_tweet <- str_replace(clean_tweet,"RT @[a-z,A-Z]*: ","")
# Get rid of hashtags
hashtags <- str_replace_all(clean_tweet,"#[a-z,A-Z]*","")
clean_tweet <- str_replace_all(clean_tweet,"#[a-z,A-Z]*","")
# Get rid of references to other screennames
clean_tweet <- str_replace_all(clean_tweet,"@[a-z,A-Z]*","")  

firm_name <- "goldman"
# replace "soldman sachs" with "goldman"
clean_tweet <- gsub("goldman sachs", firm_name, clean_tweet)



df1$clean_text <- clean_tweet
df1$firm <- firm_name
# reorder column

# filter for rows that contain "JPMorgan" to remove instances of "Morgan" only
df1 <- dplyr::filter(df1, grepl('goldman', clean_text))

refcols <- c("firm","text","clean_text")
df1 <- df1[, c(refcols, setdiff(names(df1), refcols))]
names(df1)


cleaned <- df1[!duplicated(df1$clean_text), ]

# write output
#write.csv(df1, "/Users/johnmara/tweets.csv")
write.csv(cleaned, "/Users/johnmara/tweets_gs.csv")

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
