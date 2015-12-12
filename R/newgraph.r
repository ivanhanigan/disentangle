
newgraph <- function(
indat2  = nodes

in_col = "causes"

out_col  = "effect"

colour_col = "colour"

pos_col = "pos"
){
nodes2 <-as.data.frame(matrix(ncol = 2, nrow = 0))
names(nodes2)  <- c("inputs", "outputs")
nameslist <- character(0)
colourslist <- character(0)
poslist <- character(0)
for(i in 1:nrow(indat2)){
#  i <- 1
  #i
  indat2[i,]
  inputs <- unlist(lapply(strsplit(indat2[i,in_col], ","), str_trim))
  outputs <- unlist(lapply(strsplit(indat2[i,out_col], ","), str_trim))
  if(length(inputs) > 0){
    nodes2 <- rbind(nodes2, cbind(inputs, outputs))
  }
  nameslist <- c(nameslist, outputs)
  colourslist <- c(colourslist, indat2[i, colour_col]) 
  poslist <- c(poslist, indat2[i, pos_col])
}
## nodes2
## nameslist
## colourslist
## poslist
edges_outcome <- create_edges(from = nodes2$inputs,
                        to =   nodes2$outputs
                        )

nodes_outcome <- create_nodes(nodes = nameslist,
                        label = TRUE,
                        color = colourslist, pos = poslist)
#nodes_outcome
graph_outcome <- create_graph(nodes_df = nodes_outcome,
                       edges_df = edges_outcome)
return(graph_outcome)
}
