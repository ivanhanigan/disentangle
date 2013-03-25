
# TODO
# make values numeric where needed
#                 AIC(modGLM), 
#                 AIC(modGLM, k = log(nrow(analyte))), 
################################################################
# name:estat
# a function to get Akaike's and Schwarz's Bayesian information criteria.
  # named after stata function
  estat <- function(modGLM,modName,aic_table){
      estats <- c(modName,
                  length(coef(modGLM)),
                  -2 * modGLM$loglik[2] + 2 * length(modGLM$coeff),   
                  -2 * modGLM$loglik[2] + log(modGLM$n) * length(modGLM$coeff),
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
     return(aic_table)
  }
