# Installing packages 
install.packages("rredlist")
install.packages("tidyverse")
install.packages("foreach")
install.packages("dismo")
install.packages("speciesgeocodeR")
install.packages("taxize")

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
## With Susy's key
Sys.setenv(IUCN_REDLIST_KEY="0b62357effbfe43b2324a5a1ac9df09d7b641e6a27ccaeb4fefb87747a0eea81")

Testudines$Binomial<-paste(Testudines$genus,Testudines$species)

ia <- iucn_summary(Testudines$Binomial)
species_iucn<-iucn_status(ia)

## Include the info into the data frame
Testudines$iucn<-species_iucn

Testudines[,c("Binomial","iucn")]
