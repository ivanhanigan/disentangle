
################################################################
# name:newnode
# REQUIRES GRAPHVIZ, AND TO INSTALL RGRAPHVIZ
# source('http://bioconductor.org/biocLite.R')
# biocLite("Rgraphviz")
# or may be needed for eg under ubuntu
# biocLite("Rgraphviz", configure.args=c("--with-graphviz=/usr"))
# FURTHER INFO
# see the Rgraphviz examples
# example(layoutGraph)
# require(biocGraph) # for imageMap

# source("R/newnode.r")
require(devtools)
install_github("disentangle", "ivanhanigan")
require(disentangle)
newnode(
  name = "NAME"
  ,
  inputs="INPUT"
  ,
  outputs = "OUTPUT"
  ,
  graph = 'nodes'
  ,
  newgraph=T
  ,
  notes=F
  ,
  code=NA
  ,
  ttype=NA
  ,
  plot = T
  )

nodes <- newnode("merge", c("d1", "d2", "d3"), c("EDA"),
                 newgraph =T)
nodes <- newnode("qc", c("data1", "data2", "data3"), c("d1", "d2", "d3"))
nodes <- newnode("modelling", "EDA")
nodes <- newnode("model checking", "modelling", c("data checking", "reporting"))
#require(disentangle)
# either edit a spreadsheet with filenames, inputs and outputs 
# filesList <- read.csv("exampleFilesList.csv", stringsAsFactors = F)
# or 
filesList <- read.csv(textConnection(
'FILE,INPUTS,OUTPUTS,DESCRIPTION
siteIDs,GPS,,latitude and longitude of sites
weather,BoM,,weather data from BoM
trapped,siteIDs,,counts of species caught in trap
biomass,siteIDs,,
corralations,"weather,trapped,biomass",report1,A study we published
paper1,report1,"open access repository, data package",
'), stringsAsFactors = F)
# start the graph
i <- 1
nodes <- newnode(name = filesList[i,1],
                 inputs = strsplit(filesList$INPUTS, ",")[[i]],
                 outputs =
                 strsplit(filesList$OUTPUTS, ",")[[i]]
                 ,
                 newgraph=T)
 
for(i in 2:nrow(filesList))
{
  # i <- 2
  if(length(strsplit(filesList$OUTPUTS, ",")[[i]]) == 0)
  {
    nodes <- newnode(name = filesList[i,1],
                     inputs = strsplit(filesList$INPUTS, ",")[[i]]
    )    
  } else {
    nodes <- newnode(name = filesList[i,1],
                     inputs = strsplit(filesList$INPUTS, ",")[[i]],
                     outputs = strsplit(filesList$OUTPUTS, ",")[[i]]
    )
  }
}
 
#dev.copy2pdf(file='fileTransformations.pdf')
#dev.off();
