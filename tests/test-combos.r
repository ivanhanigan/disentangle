
################################################################
# name:combos
formlas <- combos(yvar = "deaths",
                  xvars = c("x1", "x2", "x3", "x4")
                  )
paste(formlas)
formlas <- combos(yvar = "deaths",
                  xvars = c("x1", "x2", "x3", "x4"),
                  compulsory = c("zone", "ns(time, df = 3)")
                  )
paste(formlas)

################################################################
# name:combos
  vars <- c("cb1.tmax",
            "cb1.ravg",
            "holiday",
            "ws",
            "pmax",
            "nmax",
            "o4max",
            "wday"
            )
  formlas <- NULL
  for(j in length(vars):6)
    {
      combns <- combn(vars, j)
      for(i in 1:ncol(combns))
        {
          terms2include <- combns[,i]
          formla <- reformulate(c(terms2include,
                                  "age",
                                  "zone",
                                  "sin(timevar * 2 * pi) + cos(timevar * 2 * pi) ",
                                  "ns(time, df = 3)",
                                  "offset(log(pop))"),
            response = 'deaths')
          print(formla)
          formlas <- c(formlas,formla)
  
        }
    }
  formlas <- paste(formlas)
  formlas[1:10]
  for(k in 1:length(formlas))
    {
      form <- formlas[k]
      codes <- sprintf("***** model-%s\n#+begin_src R :session *R* :tangle src/modelling-pipeline.r :exports none :eval no\n\nfit <- glm(%s, data = analyte, family = poisson,
             control = glm.control(maxit = 1000))\naictable <- estat(fit, '%s')\n#+end_src\n\n", k, form, form)
      cat(codes)
  
    }

#########################################################################################3

m1 <- matrix(c(2,3,5,6,7,8,9,10,12,13,14), nrow=1, ncol=11)
m2 <- matrix(c(4,4,4,4,4,4,4,4,4,4,4), nrow=1, ncol=11)

combos<- rbind(m1,m2)

library(plyr)
adply(combos, 2, function(x) {
   test <- chisq.test(match.knp[, x[1]], match.knp[, x[2]])

   out <- data.frame("variable1" = colnames(match.knp)[x[1]]
                     , "Variable2" = colnames(match.knp[x[2]])
                     , "Chi.Square" = round(test$statistic,3)
                     ,  "df"= test$parameter
                     ,  "p.value" = round(test$p.value, 3)
   )


   return(out)
})

# expand.grid


# Description

# Create a data frame from all combinations of the supplied vectors or 
# factors. See the description of the return value for precise details of 
# the way this is done.

# Usage

# expand.grid(..., KEEP.OUT.ATTRS = TRUE, stringsAsFactors = TRUE)
