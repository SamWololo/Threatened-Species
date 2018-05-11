# Threatened Species
# Sam Wolf
# Data Download and Processing

# Life-history data -----------------------------------------------------------------------------------
## Downloading amniote data
download.file("http://www.esapubs.org/archive/ecol/E096/269/Data_Files/Amniote_Database_Aug_2015.csv", 
              "./Data/Base/Amniote_Database_Aug_2015.csv")

# Read data
Amniote<-read.csv("./Data/Base/Amniote_Database_Aug_2015.csv")
Amniote[Amniote==-999]<-NA

# Data carpentry
## Here I filter out the amniote database to only include turtle data. 
Testudines<-
  Amniote %>% 
  filter(class == "Reptilia" & order =="Testudines")

# IUCN Spatial data -----------------------------------------------------------------------------------
## To download The IUCN Red List of Threatened Species for reptiles
# The data file did not have a server URL file nor was in .csv format for use of the download.file command. 
# To download the spatial data for reptiles, I visited http://www.iucnredlist.org/technical-documents/spatial-data.
# The main dataset for reptiles was downloaded into the downloads folder of the PC and moved to the data
# folder of this Rproject, where it was unzipped. The data was then unpacked using the taxize package, which 
# required an IUCN Red List API. The application is at http://apiv3.iucnredlist.org/api/v3/token. 

## Extracting IUCN Status for each species
Sys.setenv(IUCN_REDLIST_KEY="79326e37e61929e5349ff01eaef7da1a0a8a9003583714d5282227332875d576")

# ia is a list of summaries. This is NOT an object, so you can't turn it into a .csv
ia <- iucn_summary(Testudines$Binomial) ## WARNING: This script loads all the taxa for Testudines ~10 mins
#This unpacks ia so that we're just looking at the status
Turtle_status<-iucn_status(ia) # "Turtle_status" is the name of the dataframe full of turtle statuses

write.csv(Turtle_status, file="./Data/Base/Turtle_status.csv")

## Include the info into the data frame (species_iucn=Turtle_status)
Turtle_status<-read.csv("./Data/Base/Turtle_status.csv")

Testudines$iucn<-Turtle_status

Turtle_status[,c("Binomial","iucn")]

## Exploring the data
class(Turtle_status)

head(Turtle_status)
tail(Turtle_status)

unique(Turtle_status$iucn) # Shows us all IUCN categories
table(Turtle_status$iucn) # Gives a table showing IUCN categories and number of species in each.  

## Interestingly, we have some categories which are outdated. We need to get rid of these. 
# Which species are included in these outdated categories? 
Turtle_status$iucn[which(Turtle_status$iucn=="LR/lc")]

# I now need to rename the outdated categories 
Turtle_status$iucn[which(Turtle_status$iucn=="LR/cd")]<-"NT"
Turtle_status$iucn[which(Turtle_status$iucn=="LR/nt")]<-"NT"
Turtle_status$iucn[which(Turtle_status$iucn=="LR/lc")]<-"LC"

# Let's see what our table looks like now: 
table(Turtle_status$iucn)

# GBIF Data using Loops -------------------------------------------------------------------------------
# Getting values of occurrences of the order Testudines
Testudines$genus<-as.character(Testudines$genus)
Testudines$species<-as.character(Testudines$species)

Total_records<-NULL

for(i in 1:length(Testudines$Binomial)){
  
  print(paste("Downloading GBIF for",i,Testudines$genus[i],Testudines$species[i]))
  tmp<-gbif(Testudines$genus[i],Testudines$species[i])
  
  Total_records<-rbind.fill(Total_records,tmp)
  write.csv(Total_records,"./Data/Base/gbif_records2.csv")
  
}  # WARNING: This code loads all of the GBIF records for Testudines and takes 3 hours


gbif_records<-read.csv("Data/Base/gbif_records2.csv")

## Cleaning records
# I only want some of the vectors of the gbif dataset, which means that I will have to clean some of them
# To do this, I need to filter only what I want, but I need to find the exact names of those columns first. 
gbif_records<-
  gbif_records %>% 
  dplyr::filter(!is.na(lon)&!is.na(lat))%>%
  dplyr::select(lon, lat, species, country) #check these names: not fullCountry, country. "lat" "lon" OK

names(gbif_records)

## Get rid of duplicate occurrences
dups=duplicated(gbif_records[, c("lon", "lat", "country")])
gbif_records <-gbif_records[!dups, ]

# Merging Data Frames ------------------------------------------------------------------------------
# Now that we have all of our data loaded I need to put all of them into one dataframe for them to be usable. 
# Create a "binomial" column because data frames must be merged on a name they both have. 
Testudines$Binomial<-paste(Testudines$genus,Testudines$species)

# To merge the turtle amniote data and iucn data 
Turtle_Lifehistory_df<-merge(Testudines, Turtle_status, by.x="Binomial")

# To merge the previous merger with gbif records 
All_Dataframes_df<-merge(Turtle_Lifehistory_df, gbif_records, by.x="Binomial", by.y="species")

write.csv(All_Dataframes_df, file="./Data/Processed/Clean_Turtle_Lifehistory_Data.csv")
