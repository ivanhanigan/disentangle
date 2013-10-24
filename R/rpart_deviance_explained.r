
################################################################
# name:rpart_deviance_explained
rpart_deviance_explained <- function(model_fit)
{
  estat <- print(model_fit)$frame[,c("var","n","dev","yval")]
  null_deviance  <- estat[1,"dev"]
  residual_deviance  <-  sum(subset(estat, var == "<leaf>")$dev)

  dev_explained  <- (null_deviance - residual_deviance) / null_deviance
  return(dev_explained)
}
