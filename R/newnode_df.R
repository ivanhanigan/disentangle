
#' @title newnode_df
#' @name newnode_df
#' @param indat the input data.frame
#' @param names_col the name of each edge (the boxes)
#' @param in_col the name of the nodes that are inputs to each edge with comma seperated vals.  whitespace will be stripped
#' @param out_col the nodes that are outputs of each edge.
#' @param desc_col description
#' @param clusters_col optional column identifying clusters
#' @param todo_col optional column with TODO status (DONE and WONTDO will be white, others are red)
#' @return character string object that has the DOT language representatio of the input
newnode_df <- function(indat = NA,names_col = NA,in_col = NA,out_col = NA,desc_col = NA,clusters_col = NA, todo_col = NA, nchar_to_snip = 40){
if(any(is.na(indat) |
       is.na(names_col) |
       is.na(in_col) |
       is.na(out_col) |
       is.na(desc_col)
       )) stop("data or arguments are not supplied")

if(!is.na(clusters_col)){
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
      status <- indat2[i,todo_col]

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
strng <- sprintf('%s\n%s  [ shape=record, label="{{ { Name | Description | Status } | { %s | %s | %s } }}"]\n%s\n\n',
                 inputs_listed, name2paste, name, desc, status, outputs_listed
                 )
      # cat(strng)
      if(!status %in% c("DONE", "WONTDO")){ 
        strng <- gsub("shape=record,", "shape=record, style = \"filled\", color=\"indianred\",", strng)
      }
      nodes_graph <- paste(nodes_graph, strng, "\n")
      if(nrow(indat2) == 1) break
    }
nodes_graph <- paste(nodes_graph, "}\n\n")
}
} else {
  indat2 <- indat
  nodes_graph  <- ""
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
if(!is.na(todo_col)){
  status <- indat2[i,todo_col]
       
strng <- sprintf('%s\n%s  [ shape=record, label="{{ { Name | Description | Status } | { %s | %s | %s } }}"]\n%s\n\n',
                 inputs_listed, name2paste, name, desc, status, outputs_listed
                 )
      # cat(strng)
      if(!status %in% c("DONE", "WONTDO")){ 
        strng <- gsub("shape=record,", "shape=record, style = \"filled\", color=\"indianred\",", strng)
      }
} else {
  
strng <- sprintf('%s\n%s  [ shape=record, label="{{ { Name | Description } | { %s | %s } }}"]\n%s\n\n',
                 inputs_listed, name2paste, name, desc, outputs_listed
                 )
}
      nodes_graph <- paste(nodes_graph, strng, "\n")
}
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
