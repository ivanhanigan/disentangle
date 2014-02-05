
################################################################
# name:reml_boilerplate

# func
## if(!require(EML)) {
##   require(devtools)
##   install_github("EML", "ropensci")
##   }
## require(EML)

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
        unit_defs[[i]] <- "number"
      } else {
        unit_defs[[i]] <- names(table(data_set[,i]))
      }
    }
  # unit_defs

  ds <- data.set(data_set,
                 col.defs = col_defs,
                 unit.defs = unit_defs
                 )
  # str(ds)

  # metadata  <- ds #metadata(ds)
  # needs names
  ## for(i in 1:ncol(data_set))
  ##   {
  ##     # i = 4
  ##     if(is.numeric(data_set[,i])){
  ##       names(metadata[[i]][[3]]) <- "number"
  ##     } else {
  ##       names(metadata[[i]][[3]]) <- metadata[[i]][[3]]
  ##     }
  ##   }
  # metadata
  eml_config(creator=created_by)
  oldwd <- getwd()
  setwd(data_dir)
  #
  ## >   eml_write(dat=ds, file = paste(titl, "xml", sep = "."), title = titl)
  ## Error in is(dat, "data.set") : object 'dat' not found
  ## > traceback()
  ## 7: is(dat, "data.set") at dataTable_methods.R#14
  ## 6: eml_dataTable(dat = dat, title = title)
  ## 5: initialize(value, ...)
  ## 4: initialize(value, ...)
  ## 3: new("dataset", title = title, creator = who$creator, contact = who$contact,
  ##        coverage = coverage, methods = methods, dataTable = c(eml_dataTable(dat = dat,
  ##            title = title)), ...) at eml_methods.R#61
  ## 2: eml(dat = dat, title = title, creator = creator, contact = contact,
  ##        ...) at eml_write.R#27
  ## 1: eml_write(dat = ds, file = paste(titl, "xml", sep = "."), title = titl)
  dat <- ds
  eml_write(dat, file = paste(titl, "xml", sep = "."), title = titl)
  setwd(oldwd)
  sprintf("your metadata has been created in the '%s' directory", data_dir)
  }
