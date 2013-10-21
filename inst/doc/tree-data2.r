
################################################################
# name:reassurance-re-weights
 
# just to reasure myself I understand what case weights do, I'll make
# this into a survey dataset with one row per respondent
df <- as.data.frame(matrix(NA, nrow = 0, ncol = 3))
for(i in 1:nrow(civst_gend_sector))
    {
    #    i <- 1
        n <- civst_gend_sector$number_of_cases[i]
        if(n == 0) next
        for(j in 1:n)
            {
              df <- rbind(df, civst_gend_sector[i,1:3])              
            }
 
    }
# save this for use later
write.csv(df, "inst/extdata/civst_gend_sector_full.csv", row.names = F)
# clean
nrow(df)
str(df)
fit1 <- rpart(civil_status ~ gender + activity_sector, data = df)
summary(fit1)

# report
par(mfrow=c(1,2), xpd = NA) 
plot(fit)
text(fit, use.n = TRUE)
title("fit")
plot(fit1)
text(fit1, use.n = TRUE)
title("fit1")
# great these are the same which is what we'd hoped to see
