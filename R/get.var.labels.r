
################################################################
# name:get.var.labels
# from http://stackoverflow.com/a/10261534
get.var.labels = function(data) {
  if(!require(Hmisc)) install.packages('Hmisc', dependencies = TRUE); require(Hmisc)
  a = do.call(llist, data)
  tempout = vector("list", length(a))

  for (i in 1:length(a)) {
    tempout[[i]] = label(a[[i]])
  }
  b = unlist(tempout)
  structure(c(b), .Names = names(data))
}
