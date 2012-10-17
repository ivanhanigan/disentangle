
# see the tutorial pdf
data(graphExamples)
z <- graphExamples[[8]]
nNodes <- length(nodes(z))
nA <- list()
nA$fixedSize<-rep(FALSE, nNodes)
nA$height <- nA$width <- rep("1", nNodes)
nA$label <- rep("z", nNodes)
nA$color <- rep("green", nNodes)
nA$fillcolor <- rep("orange", nNodes)
nA$shape <- rep("circle", nNodes)
nA$fontcolor <- rep("blue", nNodes)
nA$fontsize <- rep(14, nNodes)
nA <- lapply(nA, function(x) { names(x) <- nodes(z); x})
plot(z, nodeAttrs=nA)

#################################################
nodes <- newnode(name = 'node1',
                 inputs = c('input1', 'input2'),
                 outputs = c('output1', 'output2'),
                 newgraph = T, graph = "nodes")

nodes <- newnode(name = 'node2',
                 inputs = 'output2',
                 outputs = 'final',
                 graph = "nodes")






plot(nodes)
nNodes <- length(nodes(nodes))
nA <- list()
nA$fixedSize<-rep(FALSE, nNodes)
nA$height <- nA$width <- rep("1", nNodes)
#nA$label <- rep("nodes", nNodes)
nA$color <- rep("green", nNodes)
nA$fillcolor <- c('green', rep('grey', nNodes-1))
nA$shape <- rep("box", nNodes)
nA$fontcolor <- rep("blue", nNodes)
nA$fontsize <- rep(14, nNodes)
nA <- lapply(nA, function(x) { names(x) <- nodes(nodes); x})
nA
plot(nodes, nodeAttrs=nA)
nA$fillcolor['final'] <- 'red'
plot(nodes, nodeAttrs=nA)
legend('bottomleft', legend = c('node','output'), fill=c('green','red'))
dev.copy2pdf(file='src/newnode-colour.pdf')
dev.off()
