
# name:data_dict
data_dict <- function(.dataframe, .variable, .show_levels = -1)
{

summary2 <- function(x){
  summa <- summary(x, digits = nchar(max(x, na.rm = T))+3)
  return(summa)
}

  if(is.character(.dataframe[ ,.variable])){
    .dataframe[,.variable]  <- factor(.dataframe[,.variable])
  }
  if(all(is.na(.dataframe[ ,.variable]))){
    summa <- summary2(.dataframe[,.variable])
    summa <- as.data.frame(t(summa[2]))
    summa[,1]  <- as.numeric(as.character(summa[,1]))
  } else {
    summa <- summary2(.dataframe[,.variable])
  }
# if there are some missing obs in a date var you get a malformed
# summa with less names than levels
  if(length(as.character(summa)) != length(names(summa))){
    summa <- as.character(summa)
  }


  summa <- as.data.frame(
    cbind(
      c(.variable, rep("", length(summa) - 1)),
      names(summa)
      ,
      as.vector(summa)
      )
    )
  summa[,1]  <- as.character(summa[,1])
  summa[,2]  <- as.character(summa[,2])
  # summa

  # if char (factor)
  if(is.factor(.dataframe[,.variable])){
  summa$type <- c("character", rep("", nrow(summa) - 1))
  summa$summa  <- as.numeric(as.character(summa$V3))
  summa$summa2 <- rep(NA, nrow(summa))
      # as.numeric(as.character(summa$V2)) ?
  summa$pct  <- round((summa$summa / sum(summa$summa)) * 100, 2)
  summa <- summa[,c(1,4,2,6,5,7)]
  if(.show_levels > 0){
    if(nrow(summa) > .show_levels){
      summa <- summa[1:.show_levels,]
      summa <- rbind(summa, c("", "",
                              sprintf("more than %s levels. list truncated.", .show_levels),
                              "","", "")
                     )
      }
    }
  # summa
  } else if (
    is.numeric(.dataframe[,.variable])
    ){
  summa$type <- c("number", rep("", nrow(summa) - 1))
  summa$cnt <- NA
  summa$pct  <- NA
  summa <- summa[,c(1,4,2,3,5,6)]
  } else if (
   !all(
      is.na(as.Date(as.character(na.omit(.dataframe[,.variable])), origin = "1970-01-01"))
      )
    ){
  # if date
  ## datevar <- as.Date(as.character(
  ##   .dataframe[,.variable]
  ##   ), origin = "1970-01-01")
  # http://stackoverflow.com/questions/18178451/is-there-a-way-to-check-if-a-column-is-a-date-in-r
  # as.Date(as.character(.dataframe[,.variable]),format="%Y-%m-%d")
  ## if(!all(is.na(datevar))){
  ##   summa[,3] <- as.character(datevar)
  ## }

  summa$type <- c("date", rep("", nrow(summa) - 1))
  summa$cnt <- NA
  summa$pct  <- NA
  # summa
  if(
    length(which(is.na(.dataframe[,.variable]))) > 0
    ){
    summa$V3[-which(summa$V2 == "NA's")] <- as.character(
        as.Date(as.character(
        summa$V3[-which(summa$V2 == "NA's")]
        ), origin = "1970-01-01")
        )
  } else {
    summa$V3 <- as.character(as.Date(as.numeric(as.character(summa$V3)), origin = "1970-01-01"))
  }
  summa <- summa[,c(1,4,2,3,5,6)]
  } else if (all(is.na(.dataframe[ ,.variable]))){

  summa$type <- c("missing", rep("", nrow(summa) - 1))
  summa$fill  <- NA
  summa$pct  <- 100
  summa <- summa[,c(1,4,2,5,3,6)]

  } else {
      stop(sprintf("variable '%s' type is not character, factor, date, numeric or missing", .variable))
  }
  names(summa)  <- c("Variable","Type","Attributes", "Value", "Count", "Percent")
  # summa
  return(summa)
}
