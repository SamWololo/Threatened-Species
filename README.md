# Threatened-Species
Tentative final project

(1) the question you like to answer, 
How is global animal/plant species geographical distribution related to conservation status. (latitude, etc. - how does this affect animal endangerment)

(2) the potential source of data, 
The IUCN Red List of Threatened Species

(3) the tools you are thinking about using 
I will likely use threatened animal distribution data. With this I would like to construct either a global map or regional maps. Perhaps I can focus on regions with higher numbers of threatnened animals. I would increase reslution if I did so.  

(4) any questions you have about the development of the project.
I would like to answer a question taking advantage of the threatened species list, but am unsure whether an anthropogenic problem can be measured this way. I am thinking about how certain natural patters may make animals more suseptible to endangerment by humans. For example - decreased tree cover making some animal more likely to be hunted. 


amniote database - see if threatened species have life-history characteristics.
think about a narrower group than whole IUCN database - birds, reptiles 

find a way to filter them out then group them by species. 
your threat status is determined by what species you belong to

this weekend: decide on group - filter out other groups. merge them

Susy Meeting
must focus on one group. otherwise too data heavy. 
look at distribution of endangered species. 
focus on a certain threat status. there is an r package for this. install(rredlist)
find a package that gives you a list of animals that are endangered in an area
find: (1) group and (2) area
global assessment is not an option, too big. 
check geographical and taxonomic boundaries. 
check how many species are vulnerable in that particular area. 
i really need just a list of these species that are endangered in the US
can compare two different countries with the same habitat. can contrast this with climate and land use information. 
read the methods and supplementary information of the papers Susy Sends you
for monday define group, region, and which species you want to work with 
Find out if there are range maps with IUCN
check range maps of IUCN

4/9/18 Weeky Update
Found rredlist and installed
Loaded package
thinking about decreasing the lizards order Squamata
*** struggling to narrow down the groups. 

4/13/18
its been shown in mammals that big things make big ranges. pop size small, gotta spread out, need habitat. 
When you are small you have smaller ranges. 
Riverine fish. if you look at which wer endangered. For their size they had a relatively restricted habitat. 
So for my project I can think about that for reptiles. Are there things for body size that matter as well. Amniote life history gives me lots of information. In amniote I can look at that dataframe and find the paper associated with it. There's clutch size, etc. 
So with IUCN data I have range data. I can fist calculate the range size and interface that with the climate data. What are the average species that animal lives under. 

Susy just uploaded a new guide on how do use loops and shapefiles. How to use tracking information. 

4/15/18 Weekly Update
I tested the Rscript given in the website given in class. I installed the new packages and was able to load the libraries. Amniote data works and I was able to filter for a reptile order which I think would be interesting to investigate during this project: turtles of the order Testudines. Unfortunately, I have yet to recieve an API key from the IUCN. Unfortunately the taxize package does not work without the key, without which I cannot move forward. I'm stuck on where to go from here... I'm not sure if I can make any graphs or analyze any data with these errors... 

4/16/2018 update
Used Susy's key. Downloaded the taxize package and loaded the library. Data is being retrieved from all the turtles. 

Susy meeting: 
Now that I have unpacked the Testunides order into 273 species, I have something I can work with. Susy ran some data exploration codes to see what my distribution over different red list categories. We found that we have good heterogenetiy in this regard. One hiccup: some taxa are in outdated categories (from 1994) which means that I have to rename them. I need to then grab the map data from GBIF or a similar database. IN THE CODE FILTER OUT SPECIES WITHOUT REDLIST DATA. Otherwise you will have a massive amount of data, much of which you will not need. Once you get GBIF data, remember to get rid of NA's, 0's and duplicates. Once you do this, you can then merge the dataframes into one, which will give us a big ol' dataframe that we can use for our maps. 

I went through the code Susy and I went over during office hours. I cleaned up the IUCN dataframe of outdated categories as per Wikipedia. I should read some literature this week to verify that my decisions were correct. 

4/20/18 Friday Update:
How I determined the new (2001) IUCN Red List Categories. 
http://www.iucnredlist.org/technical-documents/categories-and-criteria/1994-categories-criteria
http://www.iucnredlist.org/technical-documents/categories-and-criteria/2001-categories-criteria
https://en.wikipedia.org/wiki/IUCN_Red_List#IUCN_Red_List_Categories
Near threatened (LR/nt) and least concern (LR/lc) have become their own categries in the 2001 system. 
Conservation dependent (LR/cd) has merged into near threatened. 

Once I download the gbif data I need to write a csv file from the data. 

4/23/18 Weekly Update: 
While running the gbif download, the internet connection broke, stopping the download . Unfortunately after troubleshooting it gave me the error: 
 Error in `[.data.frame`(gbif(Testudines$genus[i], Testudines$species[i]),  : 
  undefined columns selected 
When I tried to run the entire gbif from the start, I got the error: 
  Error in { : task 29 failed - "undefined columns selected" 
I'm not sure what to do. 

4/25/18
I was getting errors in my data download because of a number of columns error. That is, some of the species I was downloading had more/less vectors, which confused the download, as R wanted to have, say, all species to have 5 vectors, even though some turtles only had 4. There is now a function that does two things: downloads the entire GBIF log of a species (183 vectors) and writes a .csv. I need to check to see if I want to upload this .csv, as for reproducibilitie's sake I don't want someone using my code to have to download everything (takes 3 hours). 
I am now going to move on, and will try to clean my data and possibly merge dataframes. 

4/28/18 Update
can open presentation with this graph, say: I expected there to be a latitudinal relationship-not so
can talk aobut how Russia has no data, make a case for data sharing
check for plot continuous variables in a map for a chromatic scale which I can tie to occurrence of data

use this graph as a jumping off point. 
look at the graph gallery for inspiration. r-graph-gallery.com

for the presentation you need a couple of graphics that makes you summarise data (tables too), then one
about the vulnerability of turtles. This was my question and this was what I found. 

most sampling in europe and US.

so as part of the final project you need to clean it up. In the final project, the final code you just
include the code that you need to produce the plots you want. 

maybe split up threatened species by norhern hemisphere and south? select all the points of the tropics
between 15 and -15 in latitude and call those tropics. call the rest temperate. 

can collapse some of the status. don't overwrite in object "status", just make a status2. then see how this data looks
can create a raster for how many species of turtles i have per pixel - not necessary though
use other graphs to show relationships between variables and IUCN status
can have a colored scatterplot

5/1/18 Update
Tidying up the data. I want to finish up the code soon. I need to finish data exploration to find interesting relationships and then make some maps that show these trends. Perhaps some scatterplots showing relationships as well. 

5/3/2018 Update
Begun writing rmarkdown. I will want to write a powerpoint version. Presentations are 5 minutes long. It's in an ignite format, which means 10 slides, 30 seconds for each slide. 
Made improvements throughout the Rcode. Libraries reproducible now. 
Having great difficulty merging my dataframes. 
Note:I changed the column names of Turtle_status in the .csv. This makes this df not reproducible. I need to figure this out before I turn it in.  
Table of the occurrence map is outdated. Map has correct pts

5/9/2018
Dividing project into different .R files. So far I have libraries, data processing and then the graphical analysis. I need to make it clear that the data processing part shouldn't be run upon evaluation. I will be putting a line of code to run the iucn/gbif/amniote merged dataframe at the start of the graphical analysis portion of the script. 
So far, I have a few boxplots and a graph. I've created some scatterplots as well. 

I have begun my project write-up in html Rmarkdown format. So far I have begun writing an introduction, but am struggling to open up on my project. The angle I'm thinking of is why we should be concerned about turtle conservation - why the project matters. This can segue into the next paragraph which might be about the macroecological tools I used, though this may become repetitive when in concert with the methods section. 

I am struggling to make a table of IUCN statuses, which I once had. I am now getting a table of 273 rows, but I only want something that describes how many species I have for each status. I need to ask about this tomorrow. 

Questions For Susy: 
1. How to make table (I managed but the old vectors remain - why?)
2. Is how I reference my dataframes ok? Good for reproducibility and legibility?
3. Continuation of the above question: gbif_records when loaded is huge, and slows the knitting by a lot. I need to run it to show that the cleaning works. 
4. Is it OK to do output only?
5. Is it OK to say "4 vectors"? Or do I have to name each vector? Name each species?
6. Some of the data I link in the methods section has been put in the gitignore list. 

5/11/18
I will be running the code and Rmarkdown on a new computer. I want to verify whether it is completely reproducible. I also noticed that the original Turtle_status (pre-merge) file has lost the outdated IUCN files. I don't know why this is, hopefully I can fix it. 