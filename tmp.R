## With my IUCN API key
library(tidyverse)
library(rredlist)
library(taxize)

# Read data
Amniote<-read.csv("./Data/Amniote_Database_Aug_2015.csv")
Amniote[Amniote==-999]<-NA

# Viewing data
View(Amniote)

# Data carpentry --------------------------------------------------------------------------------------- 
Testudines<-
  Amniote %>% 
  filter(class == "Reptilia" & order =="Testudines")


Sys.setenv(IUCN_REDLIST_KEY="79326e37e61929e5349ff01eaef7da1a0a8a9003583714d5282227332875d576")

Testudines$Binomial<-paste(Testudines$genus,Testudines$species)

ia <- iucn_summary(Testudines$Binomial) ## WARNING: This script loads all the taxa for the Testudines order
species_iucn<-iucn_status(ia) # creates an object out of these unpacked taxa

## Include the info into the data frame
Testudines$iucn<-species_iucn

iucn_df<-data.frame(species=names(species_iucn),status=species_iucn)

##Merging dataframe

Testudines_iucn_traits<-merge(Testudines, iucn_df, by.x="Binomial",by.y="species")

All_dataframes<-merge(Testudines_iucn_traits, gbif, by.x="Binomial",by.y="species")
