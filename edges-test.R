newnode<-function(dsc, i, o=NA, append=T, notes=F, code=NA, ttype=NA){
#   dsc='Clean Weather Data',
#  ttype='data',
#  i='BOM',
#  o='Weather Data',
#   append=F,
#   notes='Error Checking',
#   code
  require(Rgraphviz)
  require(biocGraph)
  
#  if(!exists('rEG')) {
if(append==F) {
    
  rEG <- new("graphNEL", nodes=c("outcome", "population", "exposure",'analyte'),
               edgemode="directed")
    rEG <- addEdge("outcome", "analyte", rEG, 1)
    rEG <- addEdge("population", "analyte", rEG, 1)
    rEG <- addEdge("exposure", "analyte", rEG, 1)
    
  }
  rEG <- addNode(node=dsc,object=rEG) 
#  rEG <- addNode(node=i,object=rEG) 
  rEG <- addEdge(i, dsc, rEG, 1)
  if(!is.na(o)){
    rEG <- addEdge(from=dsc, to=o, rEG, 1)  
  }
  return(rEG)
}



# rEG <- new("graphNEL", nodes=c("outcome", "population", "exposure",'analyte'), edgemode="directed")
# plot(rEG)
# rEG <- addNode(node='qc',object=rEG) #,edges=list(c('analyte')))
# rEG <- addEdge("analyte", 'qc', rEG, 1)
# 
# rEG <- addNode(node='eda',object=rEG) 
# rEG <- addEdge("analyte", 'eda', rEG, 1)
# 
# rEG <- addNode(node='model1',object=rEG) 
# rEG <- addEdge('eda', 'model1', rEG, 1)

rEG <- newnode(dsc='model1', i='analyte', append=F)

rEG <- newnode(dsc='modelChecking', i='model1')
# rEG <- newnode(dsc='report', i='model1')
# rEG<-newnode(dsc='Weather Data',ttype='data',i='BOM',o='exposure',
#   append=F,
#   notes='Error Checking',
#   code=NA)
# rEG<-newnode(dsc='EWE criteria',i='algorithms', o='exposure',
#   notes='',
#   code=NA)
# rEG<-newnode(dsc='Population Data',ttype='data',o='population', 
#   i =c('ABS', 'Consistent Spatial Framework'),
#   notes='',
#   code=NA)
# rEG <- newnode(dsc='Select Mortality Data',ttype='data', 
#   i = c('Ethics Approval', 'Specific Causes of Death'), 
#   o= 'outcome',
#   notes='',
#   code=NA)
# rEG <- addEdge('Consistent Spatial Framework', 'Select Mortality Data', rEG, 1)
# 
# plot(rEG)
# dev.off()
# defAttrs <- getDefaultAttrs()
# defAttrs
# 
# width = 2500
# height = 2500
# png('edges-test.png', res=500, width=width, height=height)
# par(mai=rep(0,4))
plot(rEG,attrs=list(node=list(label="foo", 
  fillcolor="grey",shape="ellipse", 
  fixedsize=FALSE),
  edge=list(color="black")))
dev.off()

# width = height = 512
# png('edges-test.png', width=width, height=height)
# par(mai=rep(0,4))
# plot(rEG,attrs=list(node=list(label="foo", fillcolor="lightgreen"),
#                      edge=list(color="cyan"),
#                      graph=list(rankdir="LR")))
# dev.off()