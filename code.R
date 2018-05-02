# Libraries -------------------------------------------------------------------------------------------
library(rredlist)
library(tidyverse)
library(foreach)
library(dismo)
library(speciesgeocodeR)
library(taxize)
library(plyr)

# Data ------------------------------------------------------------------------------------------------
## To download amniote data
download.file("http://www.esapubs.org/archive/ecol/E096/269/Data_Files/Amniote_Database_Aug_2015.csv", 
              "./Data/Amniote_Database_Aug_2015.csv")
## To download The IUCN Red List of Threatened Species for REPTILES
# The data file did not have a server URL file nor was in .csv format for use of the download.file command. 
# To download the spatial data for reptiles, I visited http://www.iucnredlist.org/technical-documents/spatial-data.
# The main dataset for reptiles was downloaded into the downloads folder of the PC and moved to the data
# folder of this Rproject, where it was unzipped. 

# Read data
Amniote<-read.csv("./Data/Amniote_Database_Aug_2015.csv")
Amniote[Amniote==-999]<-NA

# Viewing data
View(Amniote)

# Data carpentry -------------------------------------------------------------------------------------- 
# Here I filter out the amniote database to only include turtle data. 
Testudines<-
  Amniote %>% 
  filter(class == "Reptilia" & order =="Testudines")

# Extracting IUCN Status for each species
## With my IUCN API key
Sys.setenv(IUCN_REDLIST_KEY="79326e37e61929e5349ff01eaef7da1a0a8a9003583714d5282227332875d576")

Testudines$Binomial<-paste(Testudines$genus,Testudines$species)

ia <- iucn_summary(Testudines$Binomial) ## WARNING: This script loads all the taxa for Testudines ~10 mins
species_iucn<-iucn_status(ia) # creates an object out of these unpacked taxa

## Include the info into the data frame
Testudines$iucn<-species_iucn

Testudines[,c("Binomial","iucn")]

iucn_df<-data.frame(species=names(species_iucn),status=species_iucn)

# Exploring the data
head(ia)
tail(ia)

class(ia)

head(species_iucn)
tail(species_iucn)

unique(species_iucn) # Gives us the unique IUCN categories. No numbers, though. 
table(species_iucn) # Gives us a useful table showing the distribution of taxa over IUCN categories.

## Interestingly, we have some categories which are outdated. We need to get rid of these. 
# Which species are included in these outdated categories? 
species_iucn[which(species_iucn=="LR/lc")]

# I now need to rename the outdated categories 
species_iucn[which(species_iucn=="LR/cd")]<-"NT"
species_iucn[which(species_iucn=="LR/nt")]<-"NT"
species_iucn[which(species_iucn=="LR/lc")]<-"LC"

# Let's see what our table looks like now: 
table(species_iucn)

# GBIF Data using Loops -------------------------------------------------------------------------------
# Getting values of occurrences of the order Testudines
Testudines$genus<-as.character(Testudines$genus)
Testudines$species<-as.character(Testudines$species)

Total_records<-NULL

for(i in 1:length(Testudines$Binomial)){
  
  print(paste("Downloading GBIF for",i,Testudines$genus[i],Testudines$species[i]))
  tmp<-gbif(Testudines$genus[i],Testudines$species[i])
  
  Total_records<-rbind.fill(Total_records,tmp)
  write.csv(Total_records,"./Data/gbif_records2.csv")
  
}  # WARNING: This code loads all of the GBIF records for Testudines and takes 3 hours


gbif_records<-read.csv("Data/gbif_records2.csv")

## Cleaning records
# I only want some of the vectors of the gbif dataset, which means that I will have to clean some of them
# To do this, I need to filter only what I want, but I need to find the exact names of those columns first. 
names(gbif_records)

gbif_records<-
  gbif_records %>% 
  dplyr::filter(!is.na(lon)&!is.na(lat))%>%
  dplyr::select(lon, lat, species, country) #check these names: not fullCountry, country. "lat" "lon" OK

## Get rid of duplicate occurrences
dups=duplicated(gbif_records[, c("lon", "lat", "country")])
gbif_records <-gbif_records[!dups, ]

## Merging data frames
# Now that we have all of our data loaded I need to put all of them in one dataframe for them to be usable. 
iucn_df<-data.frame(species=names(species_iucn),status=species_iucn)

Turtle_Lifehistory_df<-merge(Testudines, iucn_df, by.x="Binomial", by.y="species")
All_Dataframes_df<-merge(Turtle_Lifehistory_df, gbif_records, by.x="Binomial", by.y="species")

View(Turtle_Lifehistory_df)
View(All_Dataframes_df)

write.csv(All_Dataframes_df, file="./Data/Processed/Clean_Turtle_Lifehistory_Data.csv")

# Data exploration ------------------------------------------------------------------------------------
## Combining group_by() and summarize() in a pipe to find interesting data about the dataframe. Weight
All_Dataframes_df %>% 
  group_by(status) %>% 
  dplyr::summarise(N_sp=n_distinct(Binomial),  # dplyr because summarise belongs to two packages, gets confused
                   Weight_avg=mean(adult_body_mass_g, na.rm=TRUE))
#graph it
ggplot(data=All_Dataframes_df, aes(x=status,y=log(adult_body_mass_g)))+
  geom_boxplot()

All_Dataframes_df %>% 
  group_by(Binomial) %>% 
  dplyr::summarise(Weight_avg=mean(adult_body_mass_g, na.rm=TRUE),
                   status_iucn=unique(status)) %>% 
  ggplot(aes(x=status_iucn,y=log(Weight_avg)))+
  geom_boxplot()

# create 2 datafroames, one aminote and IUCN, then the alldata with gbif only when I want maps
# can plot occurrenct 

All_Dataframes_df %>% 
  filter(status=="CR" | status=="EX") %>% 
  group_by(Binomial,status) %>%
  dplyr::summarise(Weight_avg=mean(adult_body_mass_g, na.rm=TRUE),
                   status_iucn=unique(status))
  

## Maps

###write down my variables. use worldsmpl for maps to plot occurrences. rasters for biomes is OK too
### 

library(maptools)
library(RColorBrewer)
data(wrld_simpl)

#cols contain the names of 3 different colors
cols<-brewer.pal(n=n_distinct(All_Dataframes_df$status),name="Set1")
cols_status<-cols[All_Dataframes_df$status]


plot(wrld_simpl, xlim=c(min(All_Dataframes_df$lon)-1,max(All_Dataframes_df$lon)+1), ylim=c(min(All_Dataframes_df$lat)-1,max(All_Dataframes_df$lat)+1), axes=TRUE, col="light yellow")
points(All_Dataframes_df$lon, All_Dataframes_df$lat, col=cols_status, pch=16, cex=0.75)
legend("top",fill=cols,legend = levels(All_Dataframes_df$status),horiz=TRUE)

# can open presentation with this graph, say: I expected there to be a latitudinal relationship-not so
# can talk aobut how Russia has no data, make a case for data sharing
# check for plot continuous variables in a map for a chromatic scale which I can tie to occurrence of data

# use this graph as a jumping off point. 
# look at the graph gallery for inspiration. r-graph-gallery.com

# for the presentation you need a couple of graphics that makes you summarise data (tables too), then one
# about the vulnerability of turtles. This was my question and this was what I found. 

#most sampling in europe and US.

# so as part of the final project you need to clean it up. In the final project, the final code you just
# include the code that you need to produce the plots you want. 

# maybe split up threatened species by norhern hemisphere and south? select all the points of the tropics
# between 15 and -15 in latitude and call those tropics. call the rest temperate. 

# can collapse some of the status. don't overwrite in object "status", just make a status2. then 
# see how this data looks

#can create a raster for how many species of turtles i have per pixel - not necessary though
# use other graphs to show relationships between variables and IUCN status
# can have a colored scatterplot

# by country
All_Dataframes_df %>% 
  group_by(litter_or_clutch_size_n) %>% 
  dplyr::summarise(N_sp=n_distinct(Binomial))  # dplyr because summarise belongs to two packages, gets confused

ggplot(data=All_Dataframes_df, aes(x=status,y=log(litter_or_clutch_size_n)))+
  geom_boxplot()

All_Dataframes_df$status2<-NA
All_Dataframes_df$status2[which(All_Dataframes_df$status=="CR")]<-"EN"
All_Dataframes_df[which(species_iucn=="EW")]<-"EN"
All_Dataframes_df[which(species_iucn=="NA")]<-"DD"