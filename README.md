
# A Data Driven Guide to the Perfect Ted Talk  


## Introduction 
Ted Talks is a non-profit organisation, founded in 1984 by Richard Saul Wurman and Harry Marks as a platform for spreading ideas through short powerful talks(Ted.com, 2019). Ted Talks conferences bring together world renowned experts from various walks of life and study and gives them a platform to distil years of their work and research into talks(Ted.com, 2019). Ted Talks operates under the slogan ‘Ideas Worth Spreading’ and that is exactly what they do. All the talks from the conferences are streamed across a wide variety of social networks including the Ted Talks website(Ted.com, 2019).  

### Data 
The dataset used for this project was compiled of 2,550 rows of data and 17 variables on Ted Talks from  1984 up until the 21st of September 2017. This data was originally scrapped form the ted talks main website (TED.com) and includes information about all audio- video talks. The dataset is available for CSV download from the Kaggle website. A snapshot of the data can be seen below: 
 	Table 1: Snapshot of Dataset

## Analysing the data  
The data was in a clean format and therefore could be read straight into RStudio. Data manipulation had to be carried out on the film_date variable to convert it to regular data format. 
 Many avenues could be taken with the dataset however the project was chosen to act as a data driven guide to the perfect Ted Talk. Therefore, the project will be broken down into the following question: 
	1.	What to talk about? 
	2.	When to talk about it? 
	3.	Where to talk about it? 
These questions will be answered using the dataset chosen and also web scraping techniques.  

### 1.	What to talk about? 
This is the first question will give an underlying foundation of the type of talks that are popular, the top occupations among the speakers and also the top themes of these talks.  
The first Visualisation (Fig 1.1) was generated in Rstudio and is a treemap of the top five talks in each event based on the highest number of views.  As we can see some of the top talks are by some very well know people such as Bill Gates: Innovating to zero (TED2010),  Elon Musk: The future we're building and boring (TED2017)etc. and also, we have some talks that have quite attention grabbing headings such as Ken Robinson: Do schools kill creativity (TED2006) and 
Chris Hadfield: What I learned from going blind (TED2014).
		Fig 1.1: Treemap Top 5 talks in each TED event.
Fig 1.2 shows  the most popular professions among the speakers with Writer, Artist, Designer, Journalist and Entrepreneur being the top five. These occupations represent the type of professions Ted Talks attracts to thrill audiences and spread ideas.  It is quite surprising to see writer at the top of the list considering the foundation was primarily built on bringing together people from Technology, Design and Science(Ted.com, 2019). It was expected to see professions such as scientist or engineers and therefore we can conclude that the Ted talks conferences have now diversified into virtually all fields of study.  
	 






	
	
	Fig1.2: Barplot of Top Occupations
Next, we will explore the top type of themes among the talks. This was a little trickier to do. For each talk and depending on the contents of the talk a tag is given as a descriptor of the type on content available in that talk. Each talk contains two or more tags and they are stored in a list for each observation. A function was built to unlist and split the tags, so they could be counted and plotted. This was achieved using the unset_tokens() functions from the “tidytext” package and regular expression string manipulation. Fig 1.3 depicts the resulting plot. The counts for each tag were super imposed onto the graph, and now we see what we expected from the professions plot (Fig1.2). We see that the most popular topic is technology,  as well as our other two original factions Science and Design making the list. 

	Fig 1.3: Top Themes of Ted Talks   

### 2.	When to talk about it? 
The next question on our mind when exploring a guide to the perfect ted talk is when to talk. What are the best days of the week for a talk to go live, what are the most popular months to speak and how long should a talk be. 
Fig 2.1 shows the mean duration of ted talks and it seems from the figure that the average ted talk is less that 1000 seconds long which is approximately 16 minutes. This is consistent with what we know of Ted Talks in that they are short powerful talks (Ted.com, 2019),
 












	Fig 2.1: Average Length of Ted Talks. 
Fig 2.2 below  shows the most popular day of the week to post a ted talk video. As we can see Tuesday has generated the most views, followed closely by Friday, Wednesday, Thursday and Monday. However, the difference between each day is small and therefore cannot determine whether this is statistically significant. It is also good to note that again this information has been scrapped from the ted talks main website. The videos are posted on their website during the working week. Therefore, we can conclude that the company has a five day working week and therefore publish the content during the work week.

 
		Fig 2.2: Most Popular Weekdays 

Lastly in this section we will explore the most popular months of the year for Ted Talks.  Fig 2.3 depicts the most popular months of the year for Ted Talks. As we can see January and February are the top months by far. Therefore, we can conclude that the start of the year is popular for Ted Talks. It may have some relationship to the new year and new years resolutions. 












			Fig 2.3: Popular Months for Ted Talks.  

### 3.	Where to Talk?  

The next question to be answered is where to talk? As mentioned earlier the data in the dataset is only available for ted talks up until 2017. We have got a gap in data from the 21st of September 2017 to now March 2019. Therefore, for this section I wanted up-to-date data. I wanted to determine whether the area where a  Ted Talk event is held causes an effect on twitter traffic in that area. In other words, does a Ted Talks event cause people to engage socially with the events speakers and topics of the events in the surrounding vcinity. Therefore, it was decided that for up to date social data I would scrape 10,000 tweets with the hashtags #tedtalks and #tedx. Note ReTweets were stripped from the scraping as I wanted organic data. I did not want most of my tweets being TedTalks themselves retweeting the details of the event in their area. This concluded that the scrapped tweets would be unique as well as be generated mostly from twitter users and not businesses on twitter. To do this a twitter API had to be applied for and setup (Developer.twitter.com, 2019). Note that basic twitter API only allows tweets to be scraped from 7 days previous to scraping.  Therefore, tweets were scraped from the dates 09/03/19 to 16/03/19. After scraping 10,000 tweets no users showed up with latitude and longitude. This is because twitter users have to enable and share their location when sending a tweet. Due to the fact that I now have no data for mapping I had to figure out a work around. So, utilising the tweets I had scraped I used the lookupUsers() function from the “twitterR” package (Brunila, 2019). This function took the 10,000 screen names of the users and returned their actual address from their main twitter profile.  The resultant data frame has the users living location not in fact the location where they tweeted about ted talks. Note we still have no latitude and longitude, we just have a location (See Table 2 for snapshot of data).  

  
	Table 2: Users location Generated
  
To determine the relationship between the Ted events and social communication I also need data on Ted Talks events during the same time frame as the tweets that were scraped ( from 09/03/19 to 16/03/19). Therefore, I went to TED.com main website and in their events section,  they have a table of past events. I scrapped all the data about past events that match my time frame and transformed it into a data frame (See Table 3).   

 
		Table 3: Event Data Scraped from Ted.com


Now I have two new data frames:  

1.	Contains the locations of the twitter users who were tweeting about ted talks during the 09/03/19 to 16/03/19. 
2.	Contains the locations of ted events from the 09/03/19 to 16/03/19 
However, I still need the latitude and longitude to map theses data frames. So, I used the mutate_geocode() function from “ggmap” package to return the latitude and longitude for each location in each data frame. Note that “ggmap” requires a google API and this also had to be applied for and once granted access had to be set up.  The function takes each location and returns the accompanying latitude and longitude for each (Sadler, 2019). Note that some twitter users had more than one location as their hometown on their profiles and some twitter users recorded where they lived as things like “on the moon” or “in paradise”. The geo_mutate() function will only generate coordinates for the addresses it understands, all other anomalies were cut from the data frame.   
Once this was completed the two data frames had to be merged into a staked format for use in Tableau. Data frames were distinguishable  by event name of either TED or TWITTER for mapping. The first visualisation created can be seen in Fig 3.1 & Fig 3.2 and it depicts the pattern of GIS data for ted events compared to GIS data for the twitter users.  
		Fig 3.1: Tableau Map of Plotted Ted location & Plotted Twitter Locations 

There does seem to be some relationship between sharing information on twitter and having a Ted talk event in the area. There are some parts of the map that have no ted event and therefore have no corresponding tweets in the area.
 
	Fig 3.1: Zoomed Tableau Map of Plotted Ted location & Plotted Twitter Locations 
There does seem to be an apparent relationship between where a Ted event is held and the twitter users within the vicinity sharing information about the event. For example, there was no ted talk in Greenland during our timeframe and no twitter data was recorded for that area(Fig 3.1). Let’s have a look at the data superimposed on top of one another (See Fig 3.3)
	Fig 3.3: Superimposed Tableau Map of Twitter and Ted GIS Data 
Fig 3.4 shows a look at the GIS data collected for both twitter users and ted talks conferences in the United States of America. The visualisation does suggest that a Ted event in a certain area will cause twitter users to share information about the conferences through their  twitter account. However further research is needed as  8,635 tweets (after NA’s are removed) is not wholly sufficient to determine how strong a relationship there is between a Ted event and the effect it has on social media sharing and communication in that area. 
Fig 3.5: USA Tableau Map of Twitter and Ted location data. 

## Conclusion 
The Visualizations generated in this project do in fact give a foundational guide to the perfect Ted Talk. However, given sufficient time I would have like to delve deeper into the relationship between Ted events and people sharing their ideas and experiences about the event of social networks. 
All in all, the data concludes that the perfect Ted Talk is : 
•	Approximately 16 minutes long 
•	Generates more views if it has to do with technology 
•	Writer is the top profession among speakers  
•	The start of the year is the best time to speak as there is more traffic recorded 
•	GIS data suggests that Ted Talks contain ideas worth spreading on social media in the vicinity of the Ted Talk.  

## References 
Brunila, M. (2019). Scraping, extracting and mapping geodata from Twitter. [online] Mikael Brunila. Available at: http://www.mikaelbrunila.fi/2017/03/27/scraping-extracting-mapping-geodata-twitter/ [Accessed 19 Mar. 2019].
Developer.twitter.com. (2019). Twitter Developer Platform. [online] Available at: https://developer.twitter.com/ [Accessed 19 Mar. 2019].
Sadler, J. (2019). Geocoding with R. [online] Jesse Sadler. Available at: https://www.jessesadler.com/post/geocoding-with-r/ [Accessed 19 Mar. 2019].
Ted.com. (2019). Our organization. [online] Available at: https://www.ted.com/about/our-organization [Accessed 19 Mar. 2019].
