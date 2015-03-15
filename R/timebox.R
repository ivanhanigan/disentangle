
#### name:timebox####
# func to calculate time boxes
timebox <- function(dat_in){
  # dat_in  <- datin
  if(
    !exists("dat_in$end_date")
    ) dat_in$end_date <- NA
  # str(dat_in)
  nameslist <- names(dat_in)
  dat_in$effortt <- as.numeric(gsub("[^\\d]+", "", dat_in$effort, perl=TRUE))
  dat_in$effortd <- gsub("d", 1, gsub("[[:digit:]]+", "", dat_in$effort, perl=TRUE))
  dat_in$effortd <- gsub("w", 7, dat_in$effortd)
  dat_in$effortd <- gsub("m", 30.5, dat_in$effortd)
  dat_in$effortd <- as.numeric(dat_in$effortd)
  dat_in$efforti <- dat_in$effortt * dat_in$effortd
  dat_in[is.na(dat_in$end_date),"end_date"] <- dat_in[is.na(dat_in$end_date),"start_date"] + dat_in[is.na(dat_in$end_date),"efforti"]
  dat_in$end_date  <- as.Date(dat_in$end_date, '1970-01-01')
  #   str(dat_in)
  dat_in <- dat_in[,c(nameslist, "efforti")]
  return(dat_in)
}
