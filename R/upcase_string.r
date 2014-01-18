
# name:upcase_string
upcase_string <- function(x, tosplit = " ") {
  s <- strsplit(x, tosplit)[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
      sep="", collapse=tosplit)
}
