require(Rgraphviz)
require(biocGraph)

rEG <- new("graphNEL", nodes=c("outcome", "population", "exposure",'analyte'), edgemode="directed")
rEG <- addEdge("outcome", "analyte", rEG, 1)
rEG <- addEdge("population", "analyte", rEG, 1)
rEG <- addEdge("exposure", "analyte", rEG, 1)
plot(rEG)
rEG <- addNode(node='qc',object=rEG) #,edges=list(c('analyte')))
rEG <- addEdge("analyte", 'qc', rEG, 1)

rEG <- addNode(node='eda',object=rEG) 
rEG <- addEdge("analyte", 'eda', rEG, 1)

rEG <- addNode(node='model1',object=rEG) 
rEG <- addEdge('eda', 'model1', rEG, 1)

newnode<-function(nodeName, input){
  if(!exists('rEG')) {
    rEG <- new("graphNEL", nodes=c("outcome", "population", "exposure",'analyte'), edgemode="directed")
  }
rEG <- addNode(node=nodeName,object=rEG) 
rEG <- addEdge(input, nodeName, rEG, 1)
return(rEG)
}

rEG <- newnode('modelChecking', 'model1')
rEG <- newnode('report', 'model1')
dev.off()
plot(rEG)
