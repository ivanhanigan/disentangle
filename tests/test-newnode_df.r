
#### name:newnode_df####

newnode_df <- function(indat = NA,names_col = "FILE",in_col = "INPUTS",out_col = "OUTPUTS",desc_col = "DESCRIPTION",clusters_col = "CLUSTER", todo_col = "STATUS", nchar_to_snip = 40){
  
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

filesList <- read.csv(textConnection('
CLUSTER ,  STEP    , INPUTS                    , OUTPUTS                                , DESCRIPTION                      
A  ,  siteIDs      , "GPS, helicopter"          , "spatial, site doco"                 , latitude and longitude of sites  
A  ,  weather      , BoM                       , exposures                              , weather data from BoM            
B  ,  trapped      , spatial                   , trapped_no                             , counts of species caught in trap 
B  ,  biomass      , spatial                   , biomass_g                              ,                                  
B  ,  correlations , "exposures,trapped_no,biomass_g" , report1                         , A study we published             
C  ,  paper1       , report1                   , "open access repository, data package" ,                                  
D  ,  biomass revision, new estimates           , biomass_g                              , this came late
'), stringsAsFactors = F, strip.white = T)
write.csv(filesList, "fileTransformations.csv", row.names = F)
filesList <- read.csv("fileTransformations.csv", stringsAsFactors = F, strip.white = T)

str(filesList)
filesList$STATUS <- "TODO"

nodes_graphy <- newnode_df(indat = filesList, names_col = "STEP", in_col = "INPUTS", out_col = "OUTPUTS", desc_col = "DESCRIPTION", clusters_col = "CLUSTER", todo_col = "STATUS", nchar_to_snip = 40)

sink("fileTransformations.dot")
cat(nodes_graphy)
sink()
system("\"C:\\Program Files (x86)\\Graphviz2.38\\bin\\dot\" -Tpdf fileTransformations.dot -o fileTransformations.pdf")
system("\"C:\\Program Files (x86)\\Graphviz2.38\\bin\\dot\" -Tpng fileTransformations.dot -o fileTransformations.png")

