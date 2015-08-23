
#' @title variable_names_and_labels
#' @name variable names and labels
#' @param datadict a dd object (optional)
#' @param infile the full pathname (optional)
#' @param orig_names the original names (optional)
#' @param insert_labels T/F if the output should summarise the value labels

variable_names_and_labels <- function(datadict = NULL, infile = NULL, orig_names=NULL, insert_labels = FALSE){
  
if(is.null(datadict)){  
dat <- read.csv(infile, stringsAsFactors =  F)
datadict <- data_dictionary(dat)
}

#### now get variable names as they appear in the dd ####
datadict$ordering <- 1:nrow(datadict)
col_defs <- sqldf::sqldf("
select Variable, Type
from datadict
group by Variable, Type
order by ordering
", drv = "SQLite")
col_defs <- col_defs[col_defs$Variable != "",]
# col_defs
# orig_names
if(!is.null(orig_names)){
  vl <- as.data.frame(cbind(col_defs,orig_names))
  names(vl) <- c("variable_name", "simple_type", "original_name")
} else {
  vl <- col_defs
}
# vl
vl$description <- ""
vl$nominal_ordinal_interval_ratio_datetime <- ""
vl$unit_of_measurement <- ""
vl$value_labels <- ""
vl$issue_description <- ""
vl$depositor_response <- ""
# it is easy in a spreadsheet to add the value labels but an
# automation approach is here
if(insert_labels){
  dat <- read.csv(infile, stringsAsFactors =  F)
  enums <- NA
  for(j in 1:ncol(dat)){
    if(is.character(dat[,j])){
      if(j == 1){
        enums <- 1
      } else {
        enums <- c(enums, j)
      }
    }
  }
  #enums
  #str(dat)
  lablist  <- reml_boilerplate(dat, enumerated = enums)
  lablist <- lapply(lablist, names)
  maxnlabs <- max(sapply(lablist, length))
  if(maxnlabs > 10) stop("more than 10 labels, try a different approach")
  lablist <- lapply(lablist, paste, sep = "", collapse = " = ?; ")  
  lablist  <- do.call(rbind.data.frame, lablist)
  vl$value_labels <- lablist[,1]
}
  
# vl
return(vl)
}
