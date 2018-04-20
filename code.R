# Libraries --------------------------------------------------------------------------------------------
library(rredlist)
library(tidyverse)
library(foreach)
library(dismo)
library(speciesgeocodeR)
library(taxize)

# Data -------------------------------------------------------------------------------------------------
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

# Data carpentry --------------------------------------------------------------------------------------- 
Testudines<-
  Amniote %>% 
  filter(class == "Reptilia" & order =="Testudines")

# Extracting IUCN Status for each species
## With my IUCN API key
Sys.setenv(IUCN_REDLIST_KEY="79326e37e61929e5349ff01eaef7da1a0a8a9003583714d5282227332875d576")

Testudines$Binomial<-paste(Testudines$genus,Testudines$species)

ia <- iucn_summary(Testudines$Binomial) ## WARNING: This script loads all the taxa for the Testudines order
species_iucn<-iucn_status(ia) # creates an object out of these unpacked taxa

## Include the info into the data frame
Testudines$iucn<-species_iucn

Testudines[,c("Binomial","iucn")]

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

# GBIF Data -----------------------------------------------------------------------------------------
# Getting values of occurrences of the order Testudines
turtleOcc<-gbif("Testudines")

turtleOcc<-
  turtleOcc %>% 
  filter(!is.na(lon)&!is.na(lat))