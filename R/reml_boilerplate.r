
################################################################
# name:reml_boilerplate
 
# func
## if(!require(EML)) {
##   require(devtools)
##   install_github("EML", "ropensci")
##   } 
## require(EML)

reml_boilerplate <- function(data_set, outfile = NA, created_by = "Ivan Hanigan <ivanhanigan@gmail.com>", data_dir = getwd(), titl = NA)
{

  # next create a list from the data
  unit_defs <- list()
  for(i in 1:ncol(data_set))
    {
      # i = 4
      if(is.numeric(data_set[,i])){
        unit_defs[[i]] <- "number"
      } else {
        unit_defs[[i]] <- names(data_set)[i]
      }
    }

# print helpful comments
cat(
sprintf('
# you just got a cheater\'s unit_defs
# we can get the col names easily
col_defs <- names(dat)
# then create a dataset with metadata
ds <- data.set(dat,
               col.defs = col_defs,
               unit.defs = unit_defs
               )
# now write EML metadata file
eml_config(creator="%s")
eml_write(ds,
          file = "%s",
          title = "%s"
          )

# now your metadata has been created
# if you want to add this to morpho and metacat it will needs something like
</dataFormat>
  <distribution scope="document">
    <online>
      <url function="download">ecogrid://knb/hanigan.34.1</url>
    </online>
  </distribution>
</physical>', created_by, outfile, titl)
)


  return(unit_defs)

 }
