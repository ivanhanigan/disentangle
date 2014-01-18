
################################################################
# name:levenshtein
levenshtein <- function(string1, string2, case=TRUE, map=NULL) {
        if(!is.null(map)) {
                m <- matrix(map, ncol=2, byrow=TRUE)
                s <- c(ifelse(case, string1, tolower(string1)), ifelse(case, string2, tolower(string2)))
                for(i in 1:dim(m)[1]) s <- gsub(m[i,1], m[i,2], s)
                string1 <- s[1]
                string2 <- s[2]
        }
 
        if(ifelse(case, string1, tolower(string1)) == ifelse(case, string2, tolower(string2))) return(1)
 
        s1 <- strsplit(paste(" ", ifelse(case, string1, tolower(string1)), sep=""), NULL)[[1]]
        s2 <- strsplit(paste(" ", ifelse(case, string2, tolower(string2)), sep=""), NULL)[[1]]
        
        l1 <- length(s1)
        l2 <- length(s2)
        
        d <- matrix(nrow = l1, ncol = l2)
 
        for(i in 1:l1) d[i,1] <- i-1
        for(i in 1:l2) d[1,i] <- i-1
        for(i in 2:l1) for(j in 2:l2) d[i,j] <- min((d[i-1,j]+1) , (d[i,j-1]+1) , (d[i-1,j-1]+ifelse(s1[i] == s2[j], 0, 1)))
        
        d[l1,l2]
        
        (max(l1,l2) - d[l1,l2]) / (max(l1,l2))
        
}
