
# name:data_dict
data_dict <- function(.dataframe, .variable, .show_levels = -1)
{
  summa  <- summary(.dataframe[,.variable])
  summa  <- as.data.frame(cbind(
      c(.variable, rep("", length(summa) - 1)),
      names(summa), summa))
  summa[,1]  <- as.character(summa[,1])
  summa[,2]  <- as.character(summa[,2])
  if(is.numeric(.dataframe[,.variable])){
  summa$type <- c("number", rep("", nrow(summa) - 1))
  summa$cnt <- NA
  summa$pct  <- NA
  summa <- summa[,c(1,4,2,3,5,6)]
  } else {
  summa$type <- c("character", rep("", nrow(summa) - 1))
  summa$summa  <- as.numeric(as.character(summa$summa))  
  summa$summa2 <- rep("", nrow(summa))
      # as.numeric(as.character(summa$V2)) ?
  summa$pct  <- round((summa$summa / sum(summa$summa)) * 100, 2)
  summa <- summa[,c(1,4,2,5,3,6)]
  if(.show_levels > 0){
  if(nrow(summa) > .show_levels){
      summa <- summa[1:.show_levels,]  
  summa <- rbind(summa, c("", "", sprintf("more than %s levels. list truncated.", .show_levels), "","", ""))
  }
  }
  }
  names(summa)  <- c("Variable","Type","Attributes", "Value", "Count", "Percent")
#summa
  return(summa)
}