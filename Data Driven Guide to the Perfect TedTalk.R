################################################################################################################# 
# -------------------------------------- LIbraries & Packages ------------------------------------------------- 
################################################################################################################ 
# data Analysis 
install.packages('ggrepel')
install.packages('viridis')
install.packages('RColorBrewer') 
install.packages('ggthemes')
install.packages('ggthemes')
install.packages('wordcloud2')
install.packages('anytime')
install.packages('treemap') 
install.packages("wordcloud") 
install.packages("anydate") 

# Twitter Scraping 
install.packages("twitteR")
install.packages("openssl")
install.packages("httpuv")
install.packages("")
install.packages("SnowballC")
install.packages("base64enc")
install.packages("ROAuth") 
install.packages("dismo") 
install.packages("maps") 
options(httr_oauth_cache=T) 
install.packages("ggmap")

# Web Scraping 
install.packages("tidyverse") 
install.packages("rvest")
install.packages("stringr") 
install.packages("rebus")
install.packages("lubridate")
install.packages("XML") 

# data Analysis 
library(ggplot2) # Data visualisation
library(ggrepel) # data visualisation
library(dplyr) # data manipulation
library(viridis) # data visualisation
library(stringr) # String manipulation
library(RColorBrewer) # Color palette
library(ggthemes) # Themes for plot 
library(tidyverse)
library(wordcloud2)
library(zoo)
library(anytime)
library(data.table)
library(treemap)
library(wordcloud)  
library(anytime)

# Twitter Scraping 
library(twitteR)
library(httr) 
library("openssl")
library("httpuv")
library(SnowballC)
library(tm)
library(syuzhet)
library(tidyverse)
library(tm)
library(base64enc)
library(ROAuth) 
library("stringr")
library("dplyr") 

# web scrapping 
library(tidyverse)  
library(rvest)    
library(stringr)   
library(rebus)     
library(lubridate) 
library(XML) 
library(dplyr)




# ********************************************************************************************************** 
#------------------------------- 1.  Data Analysis -----------------------------------------------------------
# ********************************************************************************************************** 
# import that main dataset from Kaggle 
ted_main=read.csv("ted_main.csv",header=TRUE,stringsAsFactors = FALSE) 

## Data Cleaning 
#Changing dataes to proper format 
# dates are in UNIX- stamp and therefore are not easy to understand. Use anytime to parse dates

ted_main$date=anydate(ted_main$film_date)
ted_main$month=month(ted_main$date)
ted_main$year=year(ted_main$date)
ted_main$wkday=weekdays(ted_main$date,abbreviate = TRUE)
ted_main$pubdate=anydate(ted_main$published_date)
ted_main$pubmonth=month(ted_main$pubdate)
ted_main$pubyear=year(ted_main$pubdate)
ted_main$pubwkday=weekdays(ted_main$pubdate,abbreviate = TRUE)

#************************************************************************************************************** 
#------------------------ A Data Driven Guide to the Perfect Ted Talk ------------------------------------- 
# *********************************************************************************************************** 

#**1. What to talk about?

"""In this section of the project I will analyse the Ted_main dataset and determine what previous sucessful speakers 
have talked about. It will include: 
1. What They have talked about 
2. Their occupation aiding their talk 
3. The tag accomayning the top talks 
4. The top speakers of the dataset. 

This information will give us an underlying guide to the type of talks that are sucessfull. """ 


# 1. What have they talked about? 
#Let us visualise the most viewed talks in each event through treemap.We first sort out top 5 talks in each event and visualize them though the events separately in treemap.eg:TEDyyy,tedglobal,tedx etc...are visualized separately.

top_talks=data.table(ted_main) #Data.table
top_talks=top_talks[,head(.SD,5),by=event] # 5 top talks 
top_talks <- filter(top_talks) %>% 
  select(event, name, views) %>%group_by(event)                     
top_talks$viewsinMl=round(top_talks$views/1000000,2) #convert views to millions
pattern="TED[:digit:]" #Select only TEDYYYY events.
tedevent=top_talks[str_detect(top_talks$event,pattern)==TRUE,] #Subset the pattern to separate DF


treemap(tedevent,index=c("event","name"),vSize ="viewsinMl",vColor = "event",palette="Set3",title="TED Events",sortID ="-viewsinMl",border.col = "#FFFFFF",type="categorical",fontsize.legend = 0,fontsize.title = 17,bg.labels = "#FFFFFF") #Visualize using treemap

""" the differnt events are colour coded and include the top 5 talks per event based on number of views  
as we can see talks like: 
- Ken Robinson: Do schools kill creativity (TED2006), 
- Elizabeth Gilbert: Your elusive creative genius(TED2009),  
-Amanda Palmer: The art of Asking (TED2013), 
- Monica Lewinsky: The price of Shame(TED2015), 
- Susan Cain: The power of introverts (TED2012), 
- Jill Bolte Taylor: My stroke of insight(TED2008), 
- Malcom Gladwell: Choice, happiness and Spaghetti (TED2004), 
- Bill Gates: Innovating to zero (TED2010), 
- Chris Hadfield: What i learned from going blind (TED2014), 
- Set Godin: How to get your ideas to spread(TED2003), 
- Elon Musk: The future we're building and boring (TED2017), 
- Richard Dawkins: militant(TED2002) 
- Anthony Atala: Printing a human kidney(TED2011), 
- John Wooden: The difference between winning and succeeding(TED2001), 
These are some of the top talks from the events over the years. Many big names aswell as attention grabing 
headings like Do schools kill creativity, Printing a human kidney,  The price of Shame etc. 
""" 


# Now i'm going to determine the top occupations in the datset. This will give us an idea of the top professions 
# these speakers have and will aid us in dtermining our underlying question of what to talk about.


top_occupation <- data.frame(table(ted_main$speaker_occupation))# new data frame with just occupations 
colnames(top_occupation) <- c("occupation", "appearances") 
top_occupation <- top_occupation %>% arrange(desc(appearances))
head(top_occupation, 10)

###################################################################################################
ggplot(head(top_occupation,30), 
       aes(x=reorder(occupation, appearances), 
           y=appearances, fill=occupation)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  geom_bar(stat="identity") +  
  ggtitle("Top Occupations")+
  guides(fill=FALSE)

""" As we can see the top 10 professions are as follows: 
1        Writer          45
2        Artist          34
3      Designer          34
4    Journalist          33
5  Entrepreneur          31
6     Architect          30
7      Inventor          27
8  Psychologist          26
9  Photographer          25
10    Filmmaker          21
These are the type of professions that have had the most apperances over the years. As we can see no data-scientists 
or statisticians YET. """ 


# now i will try and determine the types of these most liked by the audience 

tags <- as.data.frame(ted_main)
tags$tags = as.character(tags$tags)
ls = list()
for (i in 1:nrow(tags)){
  
  data = tags$tags[i]
  data = gsub("'","",data)
  data = substr(data,2,nchar(data)-1)
  data = as.data.frame(data)
  data = unnest_tokens(data,tag,data, token = "regex", pattern = ",")
  data$tag = trimws(data$tag,which = "left")
  data$tag = gsub("[[:punct:]]","",data$tag)
  data$title = tags[i,"title"]
  colnames(data) = c("tag","title")
  
  ls[[i]] = data
  
}
# need to unlist tags so we can count 
tag.data = do.call(rbind,ls)

tag.summary = summarise(group_by(tag.data,tag), count = n())
tag.summary = tag.summary[order(tag.summary$count,decreasing = T),]
head(tag.summary)


top_themes = ggplot(data = head(tag.summary, 10), aes(tag, count, fill = tag)) + 
             geom_bar(stat = "identity",position = "dodge") +  
             geom_text(aes(label = count),vjust = 1.6) + 
             ggtitle("Most popular themes of Ted Talks")
             
top_themes

""" top themes are as follows: 
1      technology  727
2         science  567
3   global issues  501
4         culture  486
5            TEDx  450
6          design  418
7        business  348
8   entertainment  299
9          health  236
10     innovation  229
Top theme is technology & science 
""" 

# 2. When to talk about it? 
# Now i will explore when the top talks are under the following: 
#- length of talks 
#- most populat day for ted talks 
#- most popular month for ted talks 


duration_ted=ggplot(ted_main,aes(duration,..count..))+geom_histogram(fill="red")+labs(x="Duration",y="Count",title="Distribution of Duration")+geom_vline(aes(xintercept = median(ted_main$duration)),linetype=4,size=1,color="black")+scale_x_continuous(limits=c(0,4000),breaks=seq(0,4000,500))
duration_ted
# duration follows a normal distribution.It is seen that the median value is less than 1000 seconds that is less than 16 minutes.


#Let explore which weekday has generated most views.


wkdays=ted_main %>% group_by(pubwkday) %>% summarise(totalviews=sum(views)) %>% arrange(desc(totalviews)) 
ggplot(wkdays,aes(factor(pubwkday,levels=pubwkday),totalviews,fill=pubwkday))+geom_bar(stat="identity")+labs(x="Published Week Day",y="Total Views",title="Published Weekday Vs Total number of views")+scale_fill_brewer(name="pubwkday",palette = "Set1")+scale_y_continuous(labels=scales::comma)


#Talks published on tuesday has generated more views followed by friday,wednesday,thursday and monday.The difference between the dates are very small and hence it is not possible to say more on this.Whereas talks published on saturday and sunday have generated lowwer views.Therefore it may be concluded that the site has 5 day working and works only occasionaly on weekends and publishes more contents only on weekdays.

tedx <- filter(ted_main, grepl("TEDx", ted_main$event, fixed = TRUE))
month_df <- as.data.frame(table(tedx$pubmonth))
colnames(month_df) <- c("Month", "Talks")
month_df$Month <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
#Turn your 'Month' column into a character vector
month_df$Month <- as.character(month_df$Month)
#Then turn it back into an ordered factor
month_df$Month <- factor(month_df$Month, levels=unique(month_df$Month))
top_months<- ggplot(data = month_df, aes(Month, Talks, fill = Talks)) +
  geom_bar(position = "dodge", stat = "identity") +
  geom_text(aes(label = Talks), vjust = 1.6, color = "white", size = 3) +
  ggtitle("Tedx Talks on top months")
top_months
""" as we can see the most popular month is January and Febuary. This may be because of new years resolutions
and new drive at the start of the year to expand knowledge. 
"""



#3. Is where to talk about it? 
"""so we have looked at what to talk about and when to talk about it, now i am going to try and detremine where to talk 
about it? 
considering our dataset does not have where in the world the talks took place, another avenue of data retrieval 
was adopted. I decided to do two things.  
I decided to make a twitter Api and scrape tweets with the hashtag #tedtalks and #tedx from 2006 (when twitter was created) 
to the 21st of september 2017 (whene the dataset ends). However twitters api only allows tweets from the last 7 
days to be scrapped. so instead i scrapped 10,000 tweets over the 09/03/2019 to the 16/03/2019. 
the i went to ted.com main website. On their website they have an events section (https://www.ted.com/tedx/events) 
That contains a table with past events. 
so considering i had tweets from the week of 09-16th of march i scraped the table on the main ted website 
containing past eventsmatching the same dates as the twitter dates. 

now i can map the tweet location as well as map the ted confences and detremine the relationship between the two. 
""" 
#***************************************************************************************************************************8 
# -------------------------------------------------TWITTER SCRAPING -------------------------------------------------------- 
#*************************************************************************************************************************** 

# api_key <- "5ay5kmyooSAQy1axXXXXX"
# api_secret <- "1uK4n4YBjgxwwsL8Mt9fxX5ZnporRg3li5sJzFXXXXXXXX"
# access_token <- "201773837-ltWsPMBHv710ACv2X5vdwGRhPhilYMXXXXXXXXX"
# access_token_secret <- "XklzF9y5j7Y0KCrQO22XgH74pxTA8kgXXXXXXXXXXXXX"
# setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

# For GDPR purposes the above keys fo the twitter Api are not complete. 
# the api was registered only for this project and the keys are active and therefore can be used for other 
# purposes. Therefor the zip file contains a csv file containg the data scraped from twitter.  
# also the scraping is computationally expensive aswell as the dates should match for both of the scraping datasets 
# it was more efficient to also give the datasets in csv form.

# fn_twitter <- searchTwitter(c("tedtalks", "tedx"),n = 10000, lang="en")
# no_retweets = strip_retweets(fn_twitter)
# fn_twitter_df <- twListToDF(fn_twitter) # Convert to data frame

write.csv(fn_twitter_df, "TedTalksTweets_noRT2..csv")
tweets <- read.csv("TedTalksTweets_noRT2..csv") # here is our scarpped tweets in a datafram 


# also note that scrapping tweets about a certain hashtag does not return a latitude and longatiude, unless the 
# tweeter themselves enalble their location sharing sevices. 
# because i want the lat and lon i had to instead looup the users location using their screen name, 
# this return the location where they live and not infact where they tweeted from 
# so the plan had to be slightly modified again. 

# userInfo <- lookupUsers(tweets$screenName)  # Batch lookup of user info

# user_location <- twListToDF(userInfo)  # Convert to a nice dF
write.csv(user_location, "geoTweets.csv")

geo_tweets <- read.csv("geoTweets.csv")
#again api had to be used therfore had to write another csv. Now we had a dataframe with LOCATION of the twitter users tweeting about tedtalks from 09th-16th of march. 

geo_tweets[geo_tweets==""] <- NA

geo_tweets <- na.omit(geo_tweets)
# lets get rid of any NAs 
geo_tweets$statusesCount <- NULL
geo_tweets$followersCount <- NULL
geo_tweets$favoritesCount <- NULL
geo_tweets$friendsCount <- NULL 
geo_tweets$url <- NULL
geo_tweets$created <- NULL 
geo_tweets$protected <- NULL
geo_tweets$verified <- NULL 
geo_tweets$description <- NULL
geo_tweets$lang <- NULL
geo_tweets$id <- NULL
geo_tweets$listedCount <- NULL 
geo_tweets$followRequestSent <- NULL
geo_tweets$profileImageUrl <- NULL 
geo_tweets$X <- NULL 
geo_tweets$location <- as.character(geo_tweets$location)

# Now that we had the location of users we have to turn it into latitude and longatude. We do this by using the api 
# and the function mutate_geocode. And again a csv was written
# geo_tweets <- mutate_geocode(geo_tweets, location)

write.csv(geo_tweets, "GEOtweet_df.csv", row.names=FALSE)


GeoTweets <- read.csv("GEOtweet_df.csv")



######### GeoTweets is the final dataframe for our twitter scrapping section 





#***********************************************************************************************************************
#-------------------------------------web scarping for geo codes ------------------------------------------------------------ 
#*************************************************************************************************************************



""" now I have to scarpe details about Ted events from 09/03/19 to 16/03/19 on the maisn website 
contains 99 locations. Then i  need to use geo_mutate function from ggmap to return latitude and longitude for locations""" 

webpage <- read_html('https://www.ted.com/tedx/events?when=past')

table <- webpage %>% 
  html_table(fill = TRUE) 


TEDtable <- as.data.frame(table, header=FALSE, stringsAsFactors = FALSE)
View(TEDtable) 

TEDtable <- TEDtable[-1,]
removewords = c("Location", "Event name", "Date")

gsub(paste0(removewords,collapse = "|"),"", TEDtable)


TEDtable$Event.name <- gsub(paste0(removewords,collapse = "|"),"", TEDtable$Event.name)
TEDtable$Location <- gsub(paste0(removewords,collapse = "|"),"", TEDtable$Location)
TEDtable$Date <- gsub(paste0(removewords,collapse = "|"),"", TEDtable$Date)


TEDtable$Videos <- NULL
TEDtable$Photos <- NULL
TEDtable$NA. <- NULL





webpage <- read_html('https://www.ted.com/tedx/events?page=2&when=past')

table1 <- webpage %>% 
  html_table(fill = TRUE) 


TEDtable1 <- as.data.frame(table1, header=FALSE, stringsAsFactors = FALSE)
View(TEDtable1) 

TEDtable1 <- TEDtable1[-1,]
removewords = c("Location", "Event name", "Date")

gsub(paste0(removewords,collapse = "|"),"", TEDtable1)


TEDtable1$Event.name <- gsub(paste0(removewords,collapse = "|"),"", TEDtable1$Event.name)
TEDtable1$Location <- gsub(paste0(removewords,collapse = "|"),"", TEDtable1$Location)
TEDtable1$Date <- gsub(paste0(removewords,collapse = "|"),"", TEDtable1$Date)


TEDtable1$Videos <- NULL
TEDtable1$Photos <- NULL
TEDtable1$NA. <- NULL


result<-rbind(TEDtable, TEDtable1)
View(result)

result <- result[-17,] # only has today in each column
write.csv(result, "TedX_GEO.csv", row.names=FALSE)
write.csv(result, "Ted_locations.csv")
ted_locations <- read.csv("TedX_GEO.csv")
View(ted_locations)
ted_locations <- ted_locations[-10, ] 
ted_locations <- ted_locations[-52, ]
ted_locations$Event.name <- as.character(ted_locations$Event.name)
ted_locations$Location <- as.character(ted_locations$Location)
write.table(ted_locations, "locationsTED.csv")


# some work has to be done in excel to separate location names  
# fixed data is then read in 


ted_locations_df <- read.csv("locationsTED.csv")

ted_locations_df$Location <- as.character(ted_locations_df$Location)
# no have to get the lat and long  

# register_google(key = "AIzaSyDLXk_XsIWrBMirCwxxxxxxxxxx")


geo_ted <- mutate_geocode(ted_locations_df, Location)

write.csv(geo_ted, "geo_ted.csv", row.names=FALSE)
geo_ted <- read_csv("geo_ted1.csv")



### Now i have 2 dataframes: 
# geo_tweets contains users lat and long 
# geo_ted contains lat and lon for ted events 
# both dataframe have dates for last 7 days 
# ted talk events scrapes from webpage from last 7 days to match the fact that can 
# only scrape 7 days worth of tweets so its up to date data 
# will use tableau for GIS plots  

# dataframes were merged into a stacked format for use in Tableau.


























