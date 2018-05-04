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

# Data carpentry -------------------------------------------------------------------------------------- 
# Here I filter out the amniote database to only include turtle data. 
Testudines<-
  Amniote %>% 
  filter(class == "Reptilia" & order =="Testudines")

# Extracting IUCN Status for each species
## With my IUCN API key
Sys.setenv(IUCN_REDLIST_KEY="79326e37e61929e5349ff01eaef7da1a0a8a9003583714d5282227332875d576")

Testudines$Binomial<-paste(Testudines$genus,Testudines$species)

# ia is a list of summaries. This is NOT an object, so you can't turn it into a .csv
ia <- iucn_summary(Testudines$Binomial) ## WARNING: This script loads all the taxa for Testudines ~10 mins
#This unpacks ia so that we're just looking at the status
Turtle_status<-iucn_status(ia) # "species_iucn" is the name of the dataframe full of turtle statuses

write.csv(Turtle_status, file="./Data/Turtle_status.csv")

## Include the info into the data frame (species_iucn=Turtle_status)
Turtle_status<-read.csv("./Data/Turtle_status.csv")

colnames(Turtle_status) <- c("Binomial","iucn")

Testudines$iucn<-Turtle_status

Turtle_status[,c("Binomial","iucn")]

iucn_df<-data.frame(species=Turtle_status$species,
                    status=Turtle_status$status)

# Exploring the data
head(ia)
tail(ia)

class(ia)

head(species_iucn)
tail(species_iucn)

unique(Turtle_status) # Gives us the unique IUCN categories. No numbers, though. 
table(Turtle_status) # Gives us a useful table showing the distribution of taxa over IUCN categories.

## Interestingly, we have some categories which are outdated. We need to get rid of these. 
# Which species are included in these outdated categories? 
Turtle_status[which(Turtle_status=="LR/lc")]

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

# Merging Data Frames ------------------------------------------------------------------------------
# Now that we have all of our data loaded I need to put all of them into one dataframe for them to be usable. 
iucn_df<-data.frame(Binomial=names(species_iucn),status=species_iucn)

# To merge the turtle amniote data and iucn data 
Turtle_Lifehistory_df<-merge(Testudines, iucn_df, by.x="species", by.y="Binomial")

# To merge the previous merger with gbif records 
All_Dataframes_df<-merge(Testudines, gbif_records, by.x="species", by.y="Binomial")

write.csv(All_Dataframes_df, file="./Data/Processed/Clean_Turtle_Lifehistory_Data.csv")

# Data exploration ------------------------------------------------------------------------------------
## Combining group_by() and summarize() in a pipe to find interesting data about the dataframe. 
# Mean body mass
All_Dataframes_df %>% 
  group_by(status) %>% 
  dplyr::summarise(N_sp=n_distinct(Binomial),  # add dplyr because summarise belongs to two packages
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

# create 2 dataframes, one aminote and IUCN, then the alldata with gbif only when I want maps
# can plot occurrenct 

All_Dataframes_df %>% 
  filter(status=="CR" | status=="EX") %>% 
  group_by(Binomial,status) %>%
  dplyr::summarise(Weight_avg=mean(adult_body_mass_g, na.rm=TRUE),
                   status_iucn=unique(status))
  

## Maps

###write down my variables. use worldsmpl for maps to plot occurrences. rasters for biomes is OK too
### 

data(wrld_simpl)

#cols contain the names of 3 different colors
cols<-brewer.pal(n=n_distinct(All_Dataframes_df$status),name="Set1")
cols_status<-cols[All_Dataframes_df$status]


plot(wrld_simpl, xlim=c(min(All_Dataframes_df$lon)-1,max(All_Dataframes_df$lon)+1), ylim=c(min(All_Dataframes_df$lat)-1,max(All_Dataframes_df$lat)+1), axes=TRUE, col="light yellow")
points(All_Dataframes_df$lon, All_Dataframes_df$lat, col=cols_status, pch=16, cex=0.75)
legend("top",fill=cols,legend = levels(All_Dataframes_df$status),horiz=TRUE)

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