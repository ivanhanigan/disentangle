
################################################################
data_dictionary <- function(dataframe, show_levels = -1){
  out <- matrix(NA, nrow = 0, ncol = 3)
  for(i in 1:ncol(dataframe)){
  #  i = 1
    print(i)
  out2 <- data_dict(
    .dataframe = dataframe
    ,
    .variable = names(dataframe)[i]
    ,
    .show_levels = show_levels
    )
  out <- rbind(out, out2)
  }
  row.names(out) <- NULL
  return(out)
}
