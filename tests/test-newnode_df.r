
#### name:test-df-input####
library(devtools)
load_all()
library(stringr)
## filesList <- read.csv(textConnection('
## CLUSTER ,  FILE    , INPUTS                    , OUTPUTS                                , DESCRIPTION                      
## A  ,  siteIDs      , "GPS, helicopter"          , "spatial, site doco"                 , latitude and longitude of sites  
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
# filesList

nodes_graphy <- newnode_df(
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
  todo_col = NA #"STATUS"
  ,
  nchar_to_snip = 40
  )

sink("fileTransformations.dot")
cat(nodes_graphy)
sink()
system("dot -Tpdf fileTransformations.dot -o fileTransformations.pdf")
