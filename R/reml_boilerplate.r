
################################################################
# name:reml_boilerplate
 
# func
if(!require(reml)) {
  require(devtools)
  install_github("reml", "ropensci")
  } 
require(reml)

reml_boilerplate <- function(data_set, created_by = "Ivan Hanigan <ivanhanigan@gmail.com>", data_dir = getwd(), titl = NA, desc = "")
{

  # essential
  if(is.na(titl)) stop(print("must specify title"))
  # we can get the col names easily
  col_defs <- names(data_set)
  # next create a list from the data
  unit_defs <- list()
  for(i in 1:ncol(data_set))
    {
      # i = 4
      if(is.numeric(data_set[,i])){
        unit_defs[[i]] <- "numeric"
      } else {
        unit_defs[[i]] <- names(table(data_set[,i]))          
      }
    }
  # unit_defs
  
  ds <- data.set(data_set,
                 col.defs = col_defs,
                 unit.defs = unit_defs
                 )
  #str(ds)

  metadata  <- metadata(ds)
  # needs names
  for(i in 1:ncol(data_set))
    {
      # i = 4
      if(is.numeric(data_set[,i])){
        names(metadata[[i]][[3]]) <- "number"
      } else {
        names(metadata[[i]][[3]]) <- metadata[[i]][[3]]
      }
    }
  # metadata
  oldwd <- getwd()
  setwd(data_dir)
  eml_write(data_set, metadata,
            title = titl,  
            description = desc,
            creator = created_by
            )
  setwd(oldwd)
  sprintf("your metadata has been created in the '%s' directory", data_dir)
  }
