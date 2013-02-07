
################################################################
# name:newnode
newnode<-function(name, inputs=NA, outputs=NA, graph = 'nodes', newgraph=F, notes=F, code=NA, ttype=NA, plot = T){
  # USAGE
  # nodes <- newnode(  # adds to a graph called nodes
  # name = 'aquire the raw data'  # the name of the node being added 
  # inputs = REQUIRED c('external sources','collected by researcher') # single or multiple inputs to it
  # outputs = OPTIONAL c('file server','metadata','cleaning') # single or multiple outputs from it
  # append=F # append to existing graph?  if False remove old graph of that name and start new
  # TODO 
  # nodes <- addEdge(from='analyse using stats package',
  # to='new data in database server',graph=nodes,weights=1)
  # INIT
  # source('http://bioconductor.org/biocLite.R')
  # biocLite("Rgraphviz")
  # or may be needed for eg under ubuntu
  # biocLite("Rgraphviz", configure.args=c("--with-graphviz=/usr"))
  require(Rgraphviz)
  # FURTHER INFO
  # see the Rgraphviz examples
  # example(layoutGraph)
  # require(biocGraph) # for imageMap
  # TODO change names in following
  dsc <- name
  i <- inputs
  o <- outputs
  #   if(!exists('nodes')) {
  if(newgraph==T) {    
    nodes <- new("graphNEL", nodes=c(dsc),
               edgemode="directed")
    # nodes <- addEdge(from=i, to=dsc, graph=nodes, 1)    
  } else {
    if(length(grep(dsc,nodes@nodes)) == 0) nodes <- addNode(node=dsc,object=nodes)
  }  
  if(sum(i %in% nodes@nodes) != length(i)) {
    inew <- i[!i %in% nodes@nodes]
    nodes <- addNode(node=inew,object=nodes)   
  }
  nodes <- addEdge(i, dsc, nodes, 1)
  #}
  if(!is.na(o[1])){
  if(sum(o %in% nodes@nodes) != length(o)) {
    onew <- o[!o %in% nodes@nodes]
    nodes <- addNode(node=onew,object=nodes)   
  }
  nodes <- addEdge(from=dsc, to=o, graph=nodes, 1)  
  }
  if(plot == T){
    try(silent=T,dev.off())
    plot(nodes,attrs=list(node=list(label="foo", fillcolor="grey",shape="ellipse", fixedsize=FALSE), edge=list(color="black")))
  }
  return(nodes)
}
