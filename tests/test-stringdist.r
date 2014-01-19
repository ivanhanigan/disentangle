
#### name:test-stringdist####
source("tests/test-levenshtein-text2test.r")
test <- text2test[grep("barnacles", text2test[,1]),1]

# get source and target
test
which(sapply(test, function(z) isTRUE(all.equal(z, x))))
