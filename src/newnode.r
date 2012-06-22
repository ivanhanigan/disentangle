newnode<-function(dsc, i=NA, o=NA, graph = 'rEG', append=T, notes=F, code=NA, ttype=NA){
  #  dsc='Clean Weather Data',
  #  ttype='data',
  #  i='BOM',
  #  o='Weather Data',
  # grph <- 'rEG'
  #   append=F,
  #   notes='Error Checking',
  #   code
  # source('http://bioconductor.org/biocLite.R')
  # biocLite("Rgraphviz")
  require(Rgraphviz)
  # example(layoutGraph)
  # require(biocGraph) # for imageMap
  
  #   if(!exists('rEG')) {
  if(append==F) {    
    rEG <- new("graphNEL", nodes=c(dsc),
               edgemode="directed")
    # rEG <- addEdge(from=i, to=dsc, graph=rEG, 1)    
  } else {
    if(length(grep(dsc,rEG@nodes)) == 0) rEG <- addNode(node=dsc,object=rEG)
  }  
  if(sum(i %in% rEG@nodes) != length(i)) {
    i <- i[!i %in% rEG@nodes]
    rEG <- addNode(node=i,object=rEG)   
  }
  rEG <- addEdge(i, dsc, rEG, 1)
  #}
  #if(!is.na(o)){
  if(length(grep(o,rEG@nodes)) == 0) rEG <- addNode(node=o,object=rEG)
  rEG <- addEdge(from=dsc, to=o, graph=rEG, 1)  
  #}
  return(rEG)
}
