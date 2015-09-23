
#' @title newnode_csv
#' @name newnode_csv
#' @param indat the input data.frame
#' @param names_col the name of each edge (the boxes)
#' @param in_col the name of the nodes that are inputs to each edge with comma seperated vals.  whitespace will be stripped
#' @param out_col the nodes that are outputs of each edge.
#' @param clusters_col optional
#' @return dataframe representation of the inputs and outputs
newnode_csv <- function(indat = NULL,names_col = NULL,in_col = NULL,out_col = NULL, clusters_col = NULL){
if (is.null(names_col)) stop("Names of the steps are needed")
if (is.null(in_col)) stop("Inputs are needed")
if (is.null(out_col)) stop("Outputs are needed")


if(!is.null(clusters_col)){
  cluster_ids <- names(table(indat[,clusters_col]))
#cluster_ids

  nodes_graph  <- as.data.frame(matrix(NA, ncol = 4, nrow = 0))
  names(nodes_graph) <- c("cluster", "name", "in_or_out", "value")

for(cluster_i in cluster_ids){
  # cluster_i <- cluster_ids[1]
  indat2 <- indat[indat[,clusters_col] == cluster_i,]  
    for(i in 1:nrow(indat2)){
      indat2[i,]
      name <- indat2[i,names_col]
      name2paste <- paste('', name, '', sep = "")
      inputs <- data.frame(in_or_out = "input", value = unlist(lapply(strsplit(indat2[i,in_col], ","), str_trim)))
      outputs <- data.frame(in_or_out = "output", value = unlist(lapply(strsplit(indat2[i,out_col], ","), str_trim)))
      inout <- rbind(inputs, outputs)      
      strng <- data.frame(cluster= cluster_i,
                    name = name2paste,                    
                    inout = inout)
      names(strng) <- c("cluster", "name", "in_or_out", "value")
      nodes_graph <- rbind(nodes_graph, strng)
    }
  } 
######################################
# option 2 no cluster
} else { 
  indat2 <- indat
  nodes_graph  <- as.data.frame(matrix(NA, ncol = 3, nrow = 0))
  names(nodes_graph) <- c("name", "in_or_out", "value")
#  indat2
    for(i in 1:nrow(indat2)){
      # i <- 1
      #i
      indat2[i,]
      name <- indat2[i,names_col]
      #desc <- indat2[i,desc_col]

      #if(nchar(name) > 140) print("that's a long name. consider shortening this")
      #if(nchar(desc) > nchar_to_snip) desc <- paste(substr(desc, 1, nchar_to_snip), "[...]")
      name2paste <- paste('', name, '', sep = "")
      inputs <- data.frame(in_or_out = "input", value = unlist(lapply(strsplit(indat2[i,in_col], ","), str_trim)))
      
#      inputs
      
      outputs <- data.frame(in_or_out = "output", value = unlist(lapply(strsplit(indat2[i,out_col], ","), str_trim)))
#      outputs
      inout <- rbind(inputs, outputs)      

strng <- data.frame(name = name2paste,                    
                    inout = inout
                 )
#strng
      names(strng) <- c("name", "in_or_out", "value")
#nodes_graph  <- ""      
      nodes_graph <- rbind(nodes_graph, strng)
#
      }
#nodes_graph
}
return(nodes_graph)
}
