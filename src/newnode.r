newnode<-function(dsc, i, o=NA, graph = 'rEG', append=T, notes=F, code=NA, ttype=NA){
  #   dsc='Clean Weather Data',
  #  ttype='data',
  #  i='BOM',
  #  o='Weather Data',
# grph <- graph
  #   append=F,
  #   notes='Error Checking',
  #   code
  require(Rgraphviz)
  require(biocGraph)
  
#   if(!exists('rEG')) {
 if(append==F) {    
    rEG <- new("graphNEL", nodes=c(i, dsc),
               edgemode="directed")
    rEG <- addEdge(from=i, to=dsc, graph=rEG, 1)    
  } else {
  rEG <- addNode(node=dsc,object=rEG) 
  rEG <- addNode(node=i,object=rEG) 
  rEG <- addEdge(i, dsc, rEG, 1)
  }
  if(!is.na(o)){
    rEG <- addEdge(from=dsc, to=o, graph=rEG, 1)  
  }
  return(rEG)
}
