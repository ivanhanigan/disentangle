
# TODO
# make values numeric where needed

################################################################
# name:estat
# a function to get Akaike's and Schwarz's Bayesian information criteria.
  # named after stata function
  estat <- function(modGLM,modName,createCsv=F){
      estats <- c(modName,
                    length(coef(modGLM)),
                    AIC(modGLM),
                    AIC(modGLM, k = log(nrow(analyte))),
                    ((modGLM$null.deviance - modGLM$deviance)/
                      modGLM$null.deviance)*100
        )
        estats <- as.data.frame(t(estats))
        names(estats) <- c('model','param','aic','bic','percentChDev')
        estats$model       <-as.character(estats$model)
        estats$param       <-as.numeric(as.character(estats$param       ))
        estats$aic         <-as.numeric(as.character(estats$aic         ))
        estats$bic         <-as.numeric(as.character(estats$bic         ))
        estats$percentChDev<-as.numeric(as.character(estats$percentChDev))
     if(!exists('aic_table'))
        {
          aic_table <- estats
        } else {
          aic_table <- rbind(aic_table,estats)
        }
     aic_table <- aic_table[order(aic_table$bic),]
     # write to csv
     # if(createCsv==T){
     #   write.table(as.data.frame(t(estats)), 'aic_table.csv', sep=',', row.names=F, append=F, col.names=F)
     # } else {
     #   write.table(as.data.frame(t(estats)), 'aic_table.csv', sep=',', row.names=F, append=T, col.names=F)
     # }

     return(aic_table)
  }
