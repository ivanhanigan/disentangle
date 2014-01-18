
# name:upcase_string
x <- c("The", "quick", "Brown", "fox/lazy dog")
sapply(x, upcase_string)
sapply(x, upcase_string, tosplit = "/")
