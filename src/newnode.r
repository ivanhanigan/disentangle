newnode<-function(name, inputs=NA, outputs=NA, graph = 'nodes', append=T, notes=F, code=NA, ttype=NA){
  #  dsc='Clean Weather Data',
  #  ttype='data',
  #  i='BOM',
  #  o='Weather Data',
  # grph <- 'nodes'
  #   append=F,
  #   notes='Error Checking',
  #   code
  # source('http://bioconductor.org/biocLite.R')
  # biocLite("Rgraphviz")
  require(Rgraphviz)
  # example(layoutGraph)
  # require(biocGraph) # for imageMap
  # TODO change names in following
  dsc <- name
  i <- inputs
  o <- outputs
  #   if(!exists('nodes')) {
  if(append==F) {    
    nodes <- new("graphNEL", nodes=c(dsc),
               edgemode="directed")
    # nodes <- addEdge(from=i, to=dsc, graph=nodes, 1)    
  } else {
    if(length(grep(dsc,nodes@nodes)) == 0) nodes <- addNode(node=dsc,object=nodes)
  }  
  if(sum(i %in% nodes@nodes) != length(i)) {
    i <- i[!i %in% nodes@nodes]
    nodes <- addNode(node=i,object=nodes)   
  }
  nodes <- addEdge(i, dsc, nodes, 1)
  #}
  #if(!is.na(o)){
  if(length(grep(o,nodes@nodes)) == 0) nodes <- addNode(node=o,object=nodes)
  nodes <- addEdge(from=dsc, to=o, graph=nodes, 1)  
  #}
  return(nodes)
}
