
################################################################
# name:R-spss-variable-labels-read
spss_variable_labels_read  <- function(x, filter, case_sensitive = FALSE, return_df = FALSE)
{
  if(case_sensitive)
    {
      col_index  <- grep(filter, attributes(x)$variable.labels)      
    } else {
      col_index  <- grep(tolower(filter), tolower(attributes(x)$variable.labels))      
    }
  names_returned <- attributes(x)$variable.labels[col_index]
  col_names  <- names(names_returned)
  col_refs  <-  as.data.frame(cbind(col_names, names_returned))
  col_refs[,1]  <-  as.character(col_refs[,1])
  col_refs[,2]  <-  as.character(col_refs[,2])
  row.names(col_refs)  <- NULL
  if(return_df)
    {
      names_returned <- paste(names_returned, sep = "", collapse = "', '")
      cat(sprintf("returning the columns '%s'", names_returned))
      data_out <- x[,col_index]
      return(data_out)
    } else {
      return(col_refs)
    }   
}
