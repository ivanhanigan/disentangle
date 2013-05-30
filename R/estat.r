
# TODO
# make values numeric where needed
#                 AIC(modGLM)
#                 AIC(modGLM, k = log(nrow(analyte)))
################################################################
# name:estat
# a function to get Akaike's and Schwarz's Bayesian information criteria.
  # named after stata function
  estat <- function(modGLM, modName, form = NA, order_by_aic = TRUE, read_previous_aictable = FALSE){
         if(read_previous_aictable & file.exists("aictable.csv"))
           {
             aictable <- read.csv('aictable.csv')
           }

      estats <- c(modName, form,
                  length(coef(modGLM)),
                  (-2 * logLik(modGLM)[1] + 2 * length(modGLM$coeff)),
                  (-2 * logLik(modGLM)[1] + log(nrow(modGLM$data)) * length(modGLM$coeff)),
                  (((modGLM$null.deviance - modGLM$deviance)/
                    modGLM$null.deviance)*100)
        )
        estats <- as.data.frame(t(estats))
        names(estats) <- c('model','formula','param','aic','bic','percentChDev')
        estats$model       <-as.character(estats$model)
        estats$formula       <-as.character(estats$formula)
        estats$param       <-as.numeric(as.character(estats$param       ))
        estats$aic         <-as.numeric(as.character(estats$aic         ))
        estats$bic         <-as.numeric(as.character(estats$bic         ))
        estats$percentChDev<-as.numeric(as.character(estats$percentChDev))
     if(!exists('aictable'))
        {
          aictable <- estats
        } else {
          aictable <- rbind(aictable,estats)
        }
     if(order_by_aic)
       {
        aictable <- aictable[order(aictable$aic),]
       } else {
        aictable <- aictable[order(aictable$bic),]
       }
     return(aictable)
  }
