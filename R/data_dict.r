
# name:data_dict
data_dict <- function(.dataframe, .variable, .show_levels = -1)
{
  if(is.character(.dataframe[ ,.variable])){
    .dataframe[,.variable]  <- factor(.dataframe[,.variable])
  }

  summa  <- summary(.dataframe[,.variable])
  summa  <- as.data.frame(
    cbind(
      c(.variable, rep("", length(summa) - 1)),
      names(summa),
      as.vector(as.character(summa))
      )
    )
  summa[,1]  <- as.character(summa[,1])
  summa[,2]  <- as.character(summa[,2])
  # summa
  # if date
  datevar <- as.Date(as.character(
    .dataframe[,.variable]
    ), origin = "1970-01-01")
  # as.Date(as.character(.dataframe[,.variable]),format="%Y-%m-%d")
  ## if(!all(is.na(datevar))){
  ##   summa[,3] <- as.character(datevar)
  ## }
  if(
   !all(
      is.na(datevar)
      )
    ){
  summa$type <- c("date", rep("", nrow(summa) - 1))
  summa$cnt <- NA
  summa$pct  <- NA
  summa <- summa[,c(1,4,2,3,5,6)]
  } else if (
    is.numeric(.dataframe[,.variable])
    ){
  summa$type <- c("number", rep("", nrow(summa) - 1))
  summa$cnt <- NA
  summa$pct  <- NA
  summa <- summa[,c(1,4,2,3,5,6)]
  } else {
  summa$type <- c("character", rep("", nrow(summa) - 1))
  summa$summa  <- as.numeric(as.character(summa$summa))  
  summa$summa2 <- rep(NA, nrow(summa))
      # as.numeric(as.character(summa$V2)) ?
  summa$pct  <- round((summa$summa / sum(summa$summa)) * 100, 2)
  summa <- summa[,c(1,4,2,5,3,6)]
  if(.show_levels > 0){
    if(nrow(summa) > .show_levels){
      summa <- summa[1:.show_levels,]  
      summa <- rbind(summa, c("", "",
                              sprintf("more than %s levels. list truncated.", .show_levels),
                              "","", "")
                     )
      }
    }
  }
  names(summa)  <- c("Variable","Type","Attributes", "Value", "Count", "Percent")
#summa
  return(summa)
}
