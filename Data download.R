





# For when gbif download is interrupted: 
## First we need to see how many records there are in the gbif file. 
1:length(Testudines$Binomial)

library(plyr)

Total_records<-NULL

for(i in 1:length(Testudines$Binomial)){
  
  print(paste("Downloading GBIF for",i,Testudines$genus[i],Testudines$species[i]))
  tmp<-gbif(Testudines$genus[i],Testudines$species[i])
  
  Total_records<-rbind.fill(Total_records,tmp)
  write.csv(Total_records,"./Data/gbif_records2.csv")
  
}  # WARNING: This code loads all of the GBIF records for Testudines and takes 3 hours
