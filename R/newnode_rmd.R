
#' @title newnode_rmd
#' @name newnode_rmd
#' @param indat the input data.frame
#' @param names_col the name of each edge (the boxes)
#' @param in_col the name of the nodes that are inputs to each edge with comma seperated vals.  whitespace will be stripped
#' @param out_col the nodes that are outputs of each edge.
#' @param desc_col description
#' @param clusters_col optional column identifying clusters
#' @param todo_col optional column with TODO status (DONE and WONTDO will be white, others are red)
#' @return character string object that has the DOT language representatio of the input
newnode_rmd <- function(indat = NULL,names_col = NULL,in_col = NULL,out_col = NULL,desc_col = NULL,clusters_col = NULL, todo_col = NULL, nchar_to_snip = 40){
if (is.null(names_col)) stop("Names of the steps are needed")
if (is.null(in_col)) stop("Inputs are needed")
if (is.null(out_col)) stop("Outputs are needed")
if (is.null(desc_col)){
  print("Descriptions are strongly recommended, we\'re creating empty records for you")
  indat$descriptions <- ""
  desc_col <- "descriptions"
}

  indat2 <- indat
  nodes_graph  <- ""
#  indat2
    for(i in 1:nrow(indat2)){
      # i <- 1
      #i
      indat2[i,]
      name <- indat2[i,names_col]
      desc <- indat2[i,desc_col]

      #if(nchar(name) > 140) print("that's a long name. consider shortening this")
      #if(nchar(desc) > nchar_to_snip) desc <- paste(substr(desc, 1, nchar_to_snip), "[...]")
      name2paste <- paste('', name, ':', sep = "")
      inputs <- unlist(lapply(strsplit(indat2[i,in_col], ","), str_trim))      
      inputs <- paste('## inputs\n',
                      paste("- ", inputs, '\n',
                                            sep = "", collapse = "")
                      , collapse = "\n", sep = "")
#      cat(inputs)
#      inputs_listed <- paste(inputs, name2paste, sep = ' -> ', collapse = "\n")
      #cat(inputs_listed)
      outputs <- unlist(lapply(strsplit(indat2[i,out_col], ","), str_trim))
      outputs <- paste('## outputs\n',
                      paste("- ", outputs, '\n',
                                            sep = "", collapse = "")
                      , collapse = "\n", sep = "")      
#      outputs <- paste('"', outputs, '"', sep = "")  
#      outputs_listed <- paste(name2paste, outputs, sep = ' -> ', collapse = "\n")
#      cat(outputs)
## if(!is.na(todo_col)){
##   status <- indat2[i,todo_col]
       
## strng <- sprintf('%s\n%s  [ shape=record, label="{{ { Name | Description | Status } | { %s | %s | %s } }}"]\n%s\n\n',
##                  inputs_listed, name2paste, name, desc, status, outputs_listed
##                  )
##       # cat(strng)
##       if(!status %in% c("DONE", "WONTDO")){ 
##         strng <- gsub("shape=record,", "shape=record, style = \"filled\", color=\"indianred\",", strng)
##       }
## } else {
  
strng <- sprintf('# %s\n## Description\n\n%s\n\n%s\n\n%s\n\n',
                 name2paste,  desc, inputs, outputs
                 )
#cat(strng)
#nodes_graph  <- ""      
      nodes_graph <- paste(nodes_graph, strng, "\n", sep = '')
#}
}
nodes_graph <- paste("---\ntitle: Test report of Workflow
author: Ivan Hanigan
output:
  html_document:
    toc: true
    theme: united
    number_sections: yes
documentclass: article
classoption: a4paper\n---\n",
                     nodes_graph,
                     "\n", sep = '')

#help_text <- c('# to run this graph
#sink("fileTransformations.dot")
#cat(nodes_graph)
#sink()
#system("dot -Tpdf fileTransformations.dot -o fileTransformations.pdf")
#')
#cat(help_text)
return(nodes_graph)
}
