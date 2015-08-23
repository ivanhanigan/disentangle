
#' @title variable_names_and_labels
#' @name variable names and labels
#' @param infile the full pathname
#' @param datadict a dd object (optional will be created if needed)
#' @param insert_labels T/F if the output should summarise the value labels

variable_names_and_labels <- function(infile, datadict = NULL, insert_labels = FALSE){
# NB dont allow mismatch between orig and dd
if(!is.null(datadict)){  
variable_names <- read.csv(infile, nrows = 1, header = F, stringsAsFactors = F)
} else {
dat <- read.csv(infile, stringsAsFactors =  F)
variable_names  <- names(dat)
datadict <- data_dictionary(dat)
}
# variable_names

#### now get variable names as they appear in the dd ####
datadict$ordering <- 1:nrow(datadict)
col_defs <- sqldf::sqldf("
select Variable, Type
from datadict
group by Variable, Type
order by ordering
", drv = "SQLite")
col_defs <- col_defs[col_defs$Variable != "",]
col_defs

vl <- as.data.frame(cbind(col_defs,t(variable_names[1,])))
names(vl) <- c("variable_name", "simple_type", "original_name")
vl$description <- ""
vl$nominal_ordinal_interval_ratio_date_time <- ""
vl$unit_of_measurement <- ""
vl$value_labels <- ""
vl$issue_description_and_suggested_change <- ""
vl$depositor_response <- ""
# it is easy in a spreadsheet to add the value labels but an
# automation approach is here
if(insert_labels){
  if(!exists('dat'))   dat <- read.csv(infile, stringsAsFactors =  F)
  lablist  <- reml_boilerplate(dat, enumerated = 1:3)
  lablist <- lapply(lablist, names)
  lablist <- lapply(lablist, paste, sep = "", collapse = " = ?; ")
  lablist  <- do.call(rbind.data.frame, lablist)
  vl$value_labels <- lablist[,1]
}
  
#vl
return(vl)
}
