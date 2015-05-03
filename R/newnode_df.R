
#### name:newnode_df####

newnode_df <- function(indat = NA,names_col = "FILE",in_col = "INPUTS",out_col = "OUTPUTS",desc_col = "DESCRIPTION",clusters_col = "CLUSTER",nchar_to_snip = 40){

# start the graph
cluster_ids <- names(table(indat[,clusters_col]))
#cluster_ids

for(cluster_i in cluster_ids){
  # cluster_i <- cluster_ids[1]

  if(cluster_i == cluster_ids[1]){
    nodes_graph <- sprintf('subgraph cluster_%s {
    label = "%s"
    ', cluster_i, cluster_i)
  } else {
    nodes_graph <- paste(nodes_graph, sprintf('subgraph cluster_%s {
    label = "%s"
    ', cluster_i, cluster_i))  
  }
#  cat(nodes_graph)    
  indat2 <- indat[indat[,clusters_col] == cluster_i,]
#  indat2
    for(i in 1:nrow(indat2)){
      # i <- 1
      #i
      indat2[i,]
      name <- indat2[i,names_col]
      inputs <- unlist(lapply(strsplit(indat2[i,in_col], ","), str_trim))
      outputs <- unlist(lapply(strsplit(indat2[i,out_col], ","), str_trim))
      desc <- indat2[i,desc_col]

      if(nchar(name) > 140) print("that's a long name. consider shortening this")
      if(nchar(desc) > nchar_to_snip) desc <- paste(substr(desc, 1, nchar_to_snip), "[...]")
      name2paste <- paste('"', name, '"', sep = "")
      inputs <- paste('"', inputs, '"', sep = "")
      #inputs
      inputs_listed <- paste(inputs, name2paste, sep = ' -> ', collapse = "\n")
      #cat(inputs_listed)
      outputs <- paste('"', outputs, '"', sep = "")  
      outputs_listed <- paste(name2paste, outputs, sep = ' -> ', collapse = "\n")
      #cat(outputs_listed)
strng <- sprintf('%s\n%s  [ shape=record, label="{{ { Name | Description } | { %s | %s } }}"]\n%s\n\n',
                 inputs_listed, name2paste, name, desc, outputs_listed
                 )
      # cat(strng)
      nodes_graph <- paste(nodes_graph, strng, "\n")
      if(nrow(indat2) == 1) break
    }
nodes_graph <- paste(nodes_graph, "}\n\n")
}

nodes_graph <- paste("digraph transformations {\n\n",
                     nodes_graph,
                     "}\n")

help_text <- c('# to run this graph
sink("fileTransformations.dot")
cat(nodes_graph)
sink()
system("dot -Tpdf fileTransformations.dot -o fileTransformations.pdf")
')
cat(help_text)
return(nodes_graph)
}
