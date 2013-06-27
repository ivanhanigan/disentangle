
################################################################
# name:R-combos
combos  <- function(yvar, xvars, compulsory = NA)
  {
    formlas <- NULL
    for(j in length(xvars):1)
      {
        combns <- combn(xvars, j)
        for(i in 1:ncol(combns))
          {
            terms2include <- combns[,i]
            if(!is.na(compulsory[1]))
              {
                terms2include  <- c(terms2include, compulsory)
              }
            formla <- reformulate(terms2include,                                  
                                  response = yvar
                                  )
            formlas <- c(formlas,formla)     
          }
      }
    return(formlas)
  }
