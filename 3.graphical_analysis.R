# Threatened Species
# Sam Wolf
# Data Exploration


All_Dataframes_df<-read.csv("./Data/Processed/Clean_Turtle_Lifehistory_Data.csv")

# Data exploration ------------------------------------------------------------------------------------
## Combining group_by() and summarize() in a pipe to find interesting data about the dataframe. 
### Exploring mean body mass
dt<-All_Dataframes_df %>% 
  group_by(iucn) %>% 
  dplyr::summarise(N_sp=n_distinct(Binomial),  # add dplyr because summarise belongs to two packages
                   Weight_avg=mean(adult_body_mass_g, na.rm=TRUE))

# Graphing log bodymass by IUCN status 
pdf("./Figures/boxplot_IUCN_logmass.pdf")
ggplot(data=All_Dataframes_df, aes(x=iucn,y=log(adult_body_mass_g)))+
  geom_boxplot()
dev.off()

# Graphing average log bodymass by IUCN status
pdf("./Figures/boxplot_IUCN_logweight.pdf")
All_Dataframes_df %>% 
  group_by(Binomial) %>% 
  dplyr::summarise(Weight_avg=mean(adult_body_mass_g, na.rm=TRUE),
                   status_iucn=unique(iucn)) %>% 
  ggplot(aes(x=status_iucn,y=log(Weight_avg), fill=status_iucn))+
  geom_boxplot(alpha=0.3)+
  theme(legend.position = "none")+
  ylab("Log Body Mass (g)") +
  xlab("IUCN Status")
dev.off()

# create 2 dataframes, one aminote and IUCN, then the alldata with gbif only when I want maps

All_Dataframes_df %>% 
  filter(iucn=="CR" | iucn=="EX") %>% 
  group_by(Binomial,iucn) %>%
  dplyr::summarise(Weight_avg=mean(adult_body_mass_g, na.rm=TRUE),
                   status_iucn=unique(iucn))
  

# Data Distribution ---------------------

###write down my variables. use worldsmpl for maps to plot occurrences. rasters for biomes is OK too
data(wrld_simpl)

#cols contain the names of 3 different colors
cols<-brewer.pal(n=n_distinct(All_Dataframes_df$iucn),name="Set1")
cols_status<-cols[All_Dataframes_df$iucn]

pdf("./Figures/map_occurrence_by_status.pdf")
plot(wrld_simpl, xlim=c(min(All_Dataframes_df$lon)-1,max(All_Dataframes_df$lon)+1), ylim=c(min(All_Dataframes_df$lat)-1,max(All_Dataframes_df$lat)+1), axes=TRUE, col="light cyan")
points(All_Dataframes_df$lon, All_Dataframes_df$lat, col=cols_status, pch=16, cex=0.75)
legend("top",fill=cols,legend = levels(All_Dataframes_df$iucn),horiz=TRUE)
dev.off()

#  by country
All_Dataframes_df %>% 
  group_by(litter_or_clutch_size_n) %>% 
  dplyr::summarise(N_sp=n_distinct(Binomial))  # dplyr because summarise belongs to two packages, gets confused

# Creating a background map with leaflet
# Create a color palette by factor:
mypalette = colorFactor( palette="YlOrBr", domain=All_Dataframes_df$iucn, na.color="transparent")

# Prepare the text for the tooltip:
mytext=paste("Status: ", All_Dataframes_df$iucn, "<br/>", "Species: ", All_Dataframes_df$Binomial, "<br/>", "Bodymass (g): ", All_Dataframes_df$adult_body_mass_g, sep="") %>%
  lapply(htmltools::HTML)

# Final Map
leaflet(All_Dataframes_df) %>% 
  addTiles()  %>% 
  addProviderTiles("Esri.WorldImagery") %>%
  addCircleMarkers(~lon, ~lat, 
                   fillColor = ~mypalette(iucn), fillOpacity = 0.7, color="white", radius=3, stroke=FALSE,
                   label = mytext,
                   labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto")
  ) %>%
  addLegend( pal=mypalette, values=~iucn, opacity=0.9, title = "IUCN Status", position = "bottomright" )

# Results ------------------------------------------------------------------------------------------
png("./Figures/boxplot_status_by_logclutchsize")
ggplot(data=All_Dataframes_df, aes(x=iucn,y=log(litter_or_clutch_size_n)))+
  geom_boxplot()
dev.off()

ggplot(All_Dataframes_df,aes(x=iucn, y=log(egg_mass_g))) + 
  geom_boxplot()

names(All_Dataframes_df)
#Scatterplot for IUCN and clutch size relation
ggplot(All_Dataframes_df,aes(x=litter_or_clutch_size_n, y=egg_mass_g)) + 
  geom_point(aes(colour=iucn, size=adult_body_mass_g), alpha=0.8)

#Scatter
pdf("./Figures/bodymass_by_eggmass_clutchsize.pdf")
ggplot(All_Dataframes_df,aes(x=log(adult_body_mass_g), y=log(egg_mass_g))) + 
  geom_point(aes(colour=iucn, size=litter_or_clutch_size_n), alpha=0.8) +
  ylab("Log Egg Mass (g)") +
  xlab("Log Adult Body Mass (g)")
dev.off()

pdf("./Figures/bodymass_by_eggmass_littersize.pdf")
ggplot(All_Dataframes_df,aes(x=female_maturity_d, y=incubation_d)) + 
  geom_point(aes(colour=iucn, size=litter_or_clutch_size_n), alpha=0.8) +
  ylab("Log Egg Mass (g)") +
  xlab("Log Adult Body Mass (g)")
dev.off()