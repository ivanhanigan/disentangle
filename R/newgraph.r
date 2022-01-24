
newgraph <- function(
  indat2  = nodes
  ,
  in_col = "causes"
  ,
  out_col  = "effect"
  ,
  colour_col = "colour"
  ,
  pos_col = "pos"
  ,
  label_col = FALSE
){
nodes2 <-as.data.frame(matrix(ncol = 2, nrow = 0))
names(nodes2)  <- c("inputs", "outputs")
nameslist <- character(0)
colourslist <- character(0)
poslist <- character(0)
labellist <- character(0)
#indat2[,-7]
for(i in 1:nrow(indat2)){
#  i <- 1
  i
  indat2[i,]
  inputs <- unlist(lapply(strsplit(indat2[i,in_col], ","), str_trim))
  outputs <- unlist(lapply(strsplit(indat2[i,out_col], ","), str_trim))
  if(length(inputs) > 0){
    nodes2 <- rbind(nodes2, cbind(inputs, outputs))
  }
  nameslist <- c(nameslist, outputs)
  labellist <- c(labellist, indat2[i, label_col])
  colourslist <- c(colourslist, indat2[i, colour_col])
  poslist <- c(poslist, indat2[i, pos_col])
}
## nodes2
## add any missing nodes
allnames <- unique(c(as.character(nodes2$inputs), as.character(nodes2$outputs)))
todo <- which(allnames %in% nameslist)
todo <- allnames[-todo]
nameslist <- c(nameslist, todo)
labellist <- c(labellist, rep("", length(todo)))
colourslist <- c(colourslist, rep("", length(todo)))
poslist <- c(poslist, rep("", length(todo)))

## nodes2
## nameslist
## colourslist
## poslist
##
unlist(labellist)
edges_character <- data.frame(from = nodes2$inputs,
                        to =   nodes2$outputs
                        )
## edges_outcome <- create_edge_df(from = nodes2$inputs,
##                         to =   nodes2$outputs
##                         )
## edges_outcome
if(label_col != TRUE){
  label2 <- nameslist
} else {
  label2 <- labellist
}
## label2
nodes_outcome <- create_node_df(n = length(nameslist),
                        label = label2,
                        color = colourslist, pos = poslist)
## cut label = label2,
nodes_outcome
edges_character
edges_characterV2 <- merge(edges_character, nodes_outcome, by.x = "from", by.y = "label", all.x = T)
names(edges_characterV2) <- gsub("id", "from2", names(edges_characterV2))
edges_characterV2 <- merge(edges_characterV2, nodes_outcome, by.x = "to", by.y = "label", all.x = T)
names(edges_characterV2) <- gsub("id", "to2", names(edges_characterV2))
edges_characterV2
edges_outcome <- create_edge_df(from = edges_characterV2$from2,
                        to = edges_characterV2$to2
                        )
## edges_outcome

graph_outcome <- create_graph(nodes_df = nodes_outcome, edges_df = edges_outcome)

return(graph_outcome)
}
