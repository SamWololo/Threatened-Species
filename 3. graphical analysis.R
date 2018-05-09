# Threatened Species
# Sam Wolf
# Data Exploration

# Data exploration ------------------------------------------------------------------------------------
All_Dataframes_df<-read.csv("./Data/Processed/Clean_Turtle_Lifehistory_Data.csv")

## Combining group_by() and summarize() in a pipe to find interesting data about the dataframe. 
### Mean body mass
All_Dataframes_df %>% 
  group_by(iucn) %>% 
  dplyr::summarise(N_sp=n_distinct(Binomial),  # add dplyr because summarise belongs to two packages
                   Weight_avg=mean(adult_body_mass_g, na.rm=TRUE))
# Graphing log bodymass by IUCN status 
pdf("./Figures/boxplot_IUCN_logmass.pdf")
ggplot(data=All_Dataframes_df, aes(x=iucn,y=log(adult_body_mass_g)))+
  geom_boxplot()
dev.off()

pdf("./Figures/boxplot_IUCN_logweight.pdf")
All_Dataframes_df %>% 
  group_by(Binomial) %>% 
  dplyr::summarise(Weight_avg=mean(adult_body_mass_g, na.rm=TRUE),
                   status_iucn=unique(iucn)) %>% 
  ggplot(aes(x=status_iucn,y=log(Weight_avg)))+
  geom_boxplot()
dev.off()

# create 2 dataframes, one aminote and IUCN, then the alldata with gbif only when I want maps
# can plot occurrenct 

All_Dataframes_df %>% 
  filter(iucn=="CR" | iucn=="EX") %>% 
  group_by(Binomial,iucn) %>%
  dplyr::summarise(Weight_avg=mean(adult_body_mass_g, na.rm=TRUE),
                   status_iucn=unique(iucn))
  

## Maps

###write down my variables. use worldsmpl for maps to plot occurrences. rasters for biomes is OK too
### 

data(wrld_simpl)

#cols contain the names of 3 different colors
cols<-brewer.pal(n=n_distinct(All_Dataframes_df$iucn),name="Set1")
cols_status<-cols[All_Dataframes_df$iucn]

png("./Figures/map_occurrence_by_status.png")
plot(wrld_simpl, xlim=c(min(All_Dataframes_df$lon)-1,max(All_Dataframes_df$lon)+1), ylim=c(min(All_Dataframes_df$lat)-1,max(All_Dataframes_df$lat)+1), axes=TRUE, col="light yellow")
points(All_Dataframes_df$lon, All_Dataframes_df$lat, col=cols_status, pch=16, cex=0.75)
legend("top",fill=cols,legend = levels(All_Dataframes_df$iucn),horiz=TRUE)
dev.off()

# by country
All_Dataframes_df %>% 
  group_by(litter_or_clutch_size_n) %>% 
  dplyr::summarise(N_sp=n_distinct(Binomial))  # dplyr because summarise belongs to two packages, gets confused

png("./Figures/boxplot_status_by_logclutchsize")
ggplot(data=All_Dataframes_df, aes(x=iucn,y=log(litter_or_clutch_size_n)))+
  geom_boxplot()
dev.off()

All_Dataframes_df$status2<-NA
All_Dataframes_df$status2[which(All_Dataframes_df$status=="CR")]<-"EN"
All_Dataframes_df[which(species_iucn=="EW")]<-"EN"
All_Dataframes_df[which(species_iucn=="NA")]<-"DD"



ggplot(All_Dataframes_df, aes(y = Binomial, x = iucn, fill=iucn)) +
  geom_boxplot() +
  geom_jitter(aes(shape = iucn,colour=iucn), width = 0.1) 

ggplot(All_Dataframes_df, aes(x=Binomial, y=egg_mass_g, color=iucn)) + 
  geom_point(size=6, alpha=0.6)


 
ggplot(All_Dataframes_df,aes(x=iucn, y=egg_mass_g)) + 
  geom_boxplot()

names(All_Dataframes_df)
#Scatterplot for IUCN and clutch size relation
ggplot(All_Dataframes_df,aes(x=litter_or_clutch_size_n, y=egg_mass_g)) + 
  geom_point(aes(colour=iucn, size=adult_body_mass_g), alpha=0.8)

#Scatter
png("./Figures/mass_by_eggmass_littersize.png")
ggplot(All_Dataframes_df,aes(x=log(adult_body_mass_g), y=egg_mass_g)) + 
  geom_point(aes(colour=iucn, size=litter_or_clutch_size_n), alpha=0.8)
dev.off()
