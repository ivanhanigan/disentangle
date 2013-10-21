
#########################################
# func
require(rpart)
require(partykit) 


# clean
str(civst_gend_sector)

# do
fit <- rpart(civil_status ~ gender + activity_sector,
             data = civst_gend_sector, weights = number_of_cases,
             control=rpart.control(minsplit=1))
# NB need minsplit to be adjusted for weights.
summary(fit)
  
# report
plot(fit, margin=.1)
text(fit, use.n = TRUE)
title("fit")

# nicer plots
png("images/fit1.png", 1000, 480)
plot(as.party(fit))
dev.off()
