
# name:upcase_strin
require(devtools)
install_github("disentangle","ivanhanigan")
require(disentangle)
x <- c("The", "quick", "Brown", "fox/lazy dog")
sapply(x, upcase_string)
sapply(x, upcase_string, tosplit = "/")
