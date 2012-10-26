newnode <- function(name, inputs=NA, outputs=NA, graph = 'nodes',
                    newgraph=F, notes=F, code=NA, ttype=NA, plot = T,
                    colour = 'grey'){
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

  if(!exists(nAttrs)){
    nNodes <- length(nodes(nodes))
    nAttrs <- list()
    nAttrs$fillcolor <- rep('grey', nNodes))
    nAttrs$fillcolor[name] <- 'red'
  }
    nAttrs <- lapply(nA, function(x) { names(x) <- nodes(nodes); x})

  if(plot == T){
    try(silent=T,dev.off())
    nNodes <- length(nodes(nodes))
    nAttrs <- list()
    nAttrs$fillcolor <- rep('grey', nNodes))
    nAttrs$fillcolor[name] <- 'red'
    nAttrs <- lapply(nA, function(x) { names(x) <- nodes(nodes); x})
    plot(nodes, nodeAttrs=nAttrs,
         attrs = list(node=list(label="foo",
                        fillcolor="grey",
                        shape="ellipse", fixedsize=FALSE),
           edge=list(color="black")
           )
         )
  }
  return(nodes)
}



#### NOTES ###

## # see the tutorial pdf
#http://www.bioconductor.org/packages/release/bioc/vignettes/Rgraphviz/inst/doc/Rgraphviz.pdf
#page 17
## data(graphExamples)
## z <- graphExamples[[8]]
## nNodes <- length(nodes(z))
## nA <- list()
## nA$fixedSize<-rep(FALSE, nNodes)
## nA$height <- nA$width <- rep("1", nNodes)
## nA$label <- rep("z", nNodes)
## nA$color <- rep("green", nNodes)
## nA$fillcolor <- rep("orange", nNodes)
## nA$shape <- rep("circle", nNodes)
## nA$fontcolor <- rep("blue", nNodes)
## nA$fontsize <- rep(14, nNodes)
## nA <- lapply(nA, function(x) { names(x) <- nodes(z); x})
## plot(z, nodeAttrs=nA)

## #################################################
## nodes <- newnode(name = 'node1',
##                  inputs = c('input1', 'input2'),
##                  outputs = c('output1', 'output2'),
##                  newgraph = T, graph = "nodes")

## nodes <- newnode(name = 'node2',
##                  inputs = 'output2',
##                  outputs = 'final',
##                  graph = "nodes")






## plot(nodes)
## nNodes <- length(nodes(nodes))
## nA <- list()
## nA$fixedSize<-rep(FALSE, nNodes)
## nA$height <- nA$width <- rep("1", nNodes)
## #nA$label <- rep("nodes", nNodes)
## nA$color <- rep("green", nNodes)
## nA$fillcolor <- c('green', rep('grey', nNodes-1))
## nA$shape <- rep("box", nNodes)
## nA$fontcolor <- rep("blue", nNodes)
## nA$fontsize <- rep(25, nNodes)
## #nA$arrowsize <- rep(.1, nNodes)
## nA <- lapply(nA, function(x) { names(x) <- nodes(nodes); x})
## #nA
## plot(nodes, nodeAttrs=nA)
## nA$fillcolor['final'] <- 'red'
## plot(nodes, nodeAttrs=nA)
## legend('bottomleft', legend = c('node','output'), fill=c('green','red'))
## dev.copy2pdf(file='src/newnode-colour.pdf')
## dev.off()
