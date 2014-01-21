
#### name:test-stringdist####
require(disentangle)
source("tests/test-levenshtein-text2test.r")
test <- text2test[grep("barnacles", tolower(text2test[,1])),1]
str(test)
# get source and target
matrix(test)
test[5]
z2 <- expand.grid(test[4], test, stringsAsFactors = F)
list(z2)
z2
z <- z2
mapply(z2,
       function(z) levenshtein(z[,1],z[,2]))
list(test[1],
test[-1])

test <- tolower(test)
i  <-  5
cbind(test[i], test[-i],  (nchar(test[i]) - stringdist(test[i], test[-i])) / nchar(test[i]))
