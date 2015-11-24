
library(devtools)
#document()
#load_all()
install_github("ivanhanigan/disentangle", ref = "gh-pages")
library(disentangle)
#source("R/newnode.r")
library(stringr)
## filesList <- read.csv(textConnection('
## CLUSTER ,  STEP    , INPUTS                    , OUTPUTS                                , DESCRIPTION                      
## A  ,  Ivan\'s siteIDs      , "Ivan\'s GPS, helicopter"          , "Ivan\'s spatial, site doco"                 , "Ivan\'s latitude and longitude of sites"
## A  ,  weather      , BoM                       , exposures                              , weather data from BoM            
## B  ,  trapped      , spatial                   , trapped_no                             , counts of species caught in trap 
## B  ,  biomass      , spatial                   , biomass_g                              ,                                  
## B  ,  correlations , "exposures,trapped_no,biomass_g" , report1                         , A study we published             
## C  ,  paper1       , report1                   , "open access repository, data package" ,                                  
## D  ,  biomass revision, new estimates          , biomass_g                              , this came late
## '), stringsAsFactors = F, strip.white = T)
#write.csv(filesList, "fileTransformations.csv", row.names = F)
filesList <- read.csv("fileTransformations.csv", stringsAsFactors = F, strip.white = T)

str(filesList)
nrow(filesList)
filesList$COL <- c("red", "yellow", "blue", "green", "orange", "blue", "red", "red", "blue")
filesList[,c("STEP", "COL")]

nodes <- newnode(
  indat = filesList
  ,
  names_col = "STEP"
  ,
  in_col = "INPUTS"
  ,
  out_col = "OUTPUTS"
  ,
  desc_col = "DESCRIPTION"
  ,
  clusters_col = "CLUSTER"
  ,
  todo_col = "STATUS"
  ,
  nchar_to_snip = 40
  ,
  colour_col = "COL"
  )
DiagrammeR::grViz(nodes)

sink("fileTransformations.dot")
cat(nodes)
sink()
#DiagrammeR::grViz("fileTransformations.dot")
system("dot -Tpdf fileTransformations.dot -o fileTransformations.pdf")
browseURL("fileTransformations.pdf")
