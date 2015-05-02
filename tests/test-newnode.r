
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
#install_github("disentangle", "ivanhanigan")
load_all()
#require(disentangle)
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
  plot = T, rgraphviz = F
  )

nodes <- newnode("merge", c("d1", "d2", "d3"), c("EDA"),
                 newgraph =T)
nodes <- newnode("qc", c("data1", "data2", "data3"), c("d1", "d2", "d3"))
nodes <- newnode("modelling", "EDA")
nodes <- newnode("model checking", "modelling", c("data checking", "reporting"))
