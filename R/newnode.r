
################################################################
# name:newnode
newnode<-function(
  name = "name_of_step"
  ,
  inputs= c("input_to_step", "input2", "in3", "in4")
  ,
  outputs= c("output_from_step", "out2", "out3") # character(0)
  ,
  desc = "some (potentially) long descriptive text saying what this step is about and why and how"
  ,
  graph = 'nodes'
  , newgraph=F, notes=F, code=NA, ttype=NA, plot = T,
  rgraphviz = F
  ){
  if(rgraphviz){
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
  if(length(o) > 0){
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
} else {
  if(nchar(name) > 140) print("that's a long name. consider shortening this")
  if(nchar(desc) > 140) desc <- paste(substr(desc, 1, 140), "[text snipped]...")
  name2paste <- paste('"', name, '"', sep = "")
  inputs <- paste('"', inputs, '"', sep = "")
  inputs_listed <- paste(inputs, name2paste, sep = ' -> ', collapse = "\n")
  #cat(inputs_listed)
  outputs <- paste('"', outputs, '"', sep = "")  
  outputs_listed <- paste(name2paste, outputs, sep = ' -> ', collapse = "\n")
  #cat(outputs_listed)
  strng <- sprintf('%s
%s  [ shape=record, label="{{ { Name | Description } | { %s | %s } }}"] 
%s\n\n', inputs_listed, name2paste, name, desc, outputs_listed
  )
  if(newgraph == F) eval(parse(text =
                                 sprintf('strng <- paste(%s, strng, "\n")', graph, graph)
                           ))
  # cat(strng)
  return(strng)
}
}
