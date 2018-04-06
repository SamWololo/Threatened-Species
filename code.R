# Libraries ----------------------------------------------------------------------------------------------
library(tidyverse)

# Data ---------------------------------------------------------------------------------------------------
## Download amniote data
download.file("http://www.esapubs.org/archive/ecol/E096/269/Data_Files/Amniote_Database_Aug_2015.csv", 
              "./Data/Amniote_Database_Aug_2015.csv")
## Download The IUCN Red List of Threatened Species
download.file("http://www.iucnredlist.org/data_request_forms/158018/download", 
              "./Data/ICUN_Redlist_Reptile.csv")

## Download 

# Read data
Amniote<-read.csv("./data/Amniote_Database_Aug_2015.csv")
IUCNreptile<-read.csv("./data/ICUN_Redlist_Reptile.csv")


# Data carpentry --------------------------------------------------------------------------------------- 
Amniote[Amniote==-999]<-NA
ICUNreptile[IUCNreptile==-999]<-NA
