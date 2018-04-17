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
thinking about decreasing the izards order Squamata
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
Now that I have unpacked the Testunides order into 273 species, I have something I can work with. Susy ran some visualization codes to see what my distribution over different red list categories. We found that we have good heterogenetiy in this regard. One hiccup: some taxa are in outdated categories (from 1994) which means that I have to rename them. I need to then grab the map data from GBIF or a similar database. IN THE CODE FILTER OUT SPECIES WITHOUT REDLIST DATA. Otherwise you will have a massive amount of data, much of which you will not need. Once you get GBIF data, remember to get rid of NA's, 0's and duplicates. Once you do this, you can then merge the dataframes into one, which will give us a big ol' dataframe that we can use for our maps. 

I went through the code Susy and I went over during office hours. I cleaned up the IUCN dataframe of outdated categories as per Wikipedia. I should read some literature this week to verify that my decisions were correct. 