# Threatened Species
# Sam Wolf
# Libraries

# Libraries -------------------------------------------------------------------------------------------
if(!require(rredlist)) {
  install.packages("rredlist");
  require(rredlist)}

if(!require(tidyverse)) {
  install.packages("tidyverse");
  require(tidyverse)}

if(!require(foreach)) {
  install.packages("foreach");
  require(foreach)}

if(!require(dismo)) {
  install.packages("dismo");
  require(dismo)}

if(!require(speciesgeocodeR)) {
  install.packages("speciesgeocodeR");
  require(speciesgeocodeR)}

if(!require(taxize)) {
  install.packages("taxize");
  require(taxize)}

if(!require(plyr)) {
  install.packages("plyr");
  require(plyr)}

if(!require(cellranger)) {
  install.packages("cellranger");
  require(cellranger)}

if(!require(maptools)) {
  install.packages("maptools");
  require(maptools)}

if(!require(RColorBrewer)) {
  install.packages("RcolorBrewer");
  require(RColorBrewer)}