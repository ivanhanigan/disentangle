
################################################################
# name:rpart_deviance_explained-test



  # explanatory power
  require(rpart)
  require(tree)
  require(partykit)
  require(devtools)
  install_github("disentangle", "ivanhanigan")
  require(disentangle)
  # load
  fpath <- system.file(file.path("extdata", "civst_gend_sector_full.csv"), package = "disentangle")
  fpath
  analyte  <- read.csv(fpath)
  str(analyte)
  analyte$income  <- rnorm(nrow(analyte), 1000,200)
  # secondary men earn less
  analyte$income[analyte$gender == "male" & analyte$activity == "secondary"]  <- analyte$income[analyte$gender == "male" & analyte$activity == "secondary"] - 500
  str(analyte)
  fit  <- rpart(income ~ ., data = analyte)
  print(fit)
  par(xpd=T)
  plot(fit);text(fit)
  plot(as.party(fit))
  
  rpart_deviance_explained(fit)
  
  # compare with http://plantecology.syr.edu/fridley/bio793/cart.html
  #Output of the fitted model shows the partition structure.  The root level (no splits) shows the total number of observations (1039), the associated deviance (at the root equal to the null deviance, or the response variable sum of squares (SSY):
  ndev <- sum(sapply(analyte$income,function(x)(x-mean(analyte$income))^2))
  
  #followed by the mean response value for that subset (for the root, this is the overall mean).  Subsequent splits refer to these statistics for the associated data subsets, with final nodes (leaves) indicated by asterisks.  The summary function associated with tree lists the formula, the number of terminal nodes (or leaves), the residual mean deviance (along with the total residual deviance and N-#nodes), and the 5-stat summary of the residuals.  The total residual deviance is the residual sum of squares:
  rdev <- sum(sapply(resid(fit),function(x)(x-mean(resid(fit)))^2))
  (ndev - rdev)/ndev
