
################################################################
# name:graphNodesFile
graphNodesFile  <- function(filesList)
  {
    # TODO check validity of fileslist input table
    # remove whitespaces?
    i <- 1
    nodes <- newnode(name = filesList[i,1],
                     inputs = strsplit(filesList$INPUTS, ",")[[i]],
                     outputs = strsplit(filesList$OUTPUTS, ",")[[i]],
                     newgraph=T)
 
    for(i in 2:nrow(filesList))
    {
      # i <- 2
      if(length(strsplit(filesList$OUTPUTS, ",")[[i]]) == 0)
      {
        nodes <- newnode(name = filesList[i,1],
                         inputs = strsplit(filesList$INPUTS, ",")[[i]]
        )    
      } else {
        nodes <- newnode(name = filesList[i,1],
                         inputs = strsplit(filesList$INPUTS, ",")[[i]],
                         outputs = strsplit(filesList$OUTPUTS, ",")[[i]]
        )
      }
    }
    
  }
