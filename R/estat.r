
# TODO
# make values numeric where needed

################################################################
# name:estat
# a function to get Akaike's and Schwarz's Bayesian information criteria.
  # named after stata function
  estat <- function(modGLM,modName,createCsv=F){
    if(!exists('aic_table'))
      {
        aic_table <- matrix(ncol=5,nrow=0)
      }

    estats <- c(modName,
                length(coef(modGLM)),
                AIC(modGLM),
                AIC(modGLM, k = log(nrow(analyte))),
                ((modGLM$null.deviance - modGLM$deviance)/ modGLM$null.deviance)*100
    )

    aic_table <- rbind(aic_table,estats)

    # write to csv
    # if(createCsv==T){
    #   write.table(as.data.frame(t(estats)), 'aic_table.csv', sep=',', row.names=F, append=F, col.names=F)
    # } else {
    #   write.table(as.data.frame(t(estats)), 'aic_table.csv', sep=',', row.names=F, append=T, col.names=F)
    # }
    return(aic_table)
  }
