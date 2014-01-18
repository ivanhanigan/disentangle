
# name:upcase_string
x <- c("The", "quick", "Brown", "fox/lazy dog")
sapply(x, simpleCap)
sapply(x, simpleCap, tosplit = "/")
