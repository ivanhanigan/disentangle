
################################################################
# name:tree.chisq
tree.chisq <- function(null_model, fitted_model)
{
    # TODO check if these are tree model class
    fit_dev  <- summary(fitted_model)$dev
    null_dev  <- summary(null_model)$dev    
    dev  <-  null_dev - fit_dev
    df  <- summary(fitted_model)$size - summary(null_model)$size
    sig  <- 1 - pchisq(dev, df)
    sprintf("Reduction in deviance is %s percent, p-value is %s (based on a chi-squared test)",
            ((null_dev - fit_dev) / null_dev) * 100,
            sig)
}
