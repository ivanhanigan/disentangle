
# func
require(tree)
require(devtools)
install_github("TransformSurveyTools", "ivanhanigan")
require(TransformSurveyTools)
# load locally
# fpath  <- "inst/extdata/civst_gend_sector_full.csv"
# or via package
fpath <- system.file("extdata", "civst_gend_sector_full.csv", package="TransformSurveyTools")
civst_gend_sector  <- read.csv(fpath)

# clean
str(civst_gend_sector)

# do
variables  <- names(civst_gend_sector)
y_variable  <- variables[1]
x_variables  <- variables[-1]

# NULL
form0  <- reformulate("1",
                      response = y_variable)
form0
model0 <- tree(form0, data = civst_gend_sector, method = "class")
print(model0)
# FIT
form1  <- reformulate(x_variables,
                      response = y_variable)
form1
model1 <- tree(form1, data = civst_gend_sector, method = "class")
print(model1)
summary(model1)
plot(model1)
text(model1,pretty = 0)
tree.chisq(null_model = model0, fitted_model = model1)

################################################################
# name:tree.chisq
# func
require(tree)

# load
fpath  <- "inst/extdata/civst_gend_sector.csv"
# or
#fpath <- system.file("extdata", "my_raw_data.csv",
# package="my_package")
civst_gend_sector  <- read.csv(fpath)

# clean
str(civst_gend_sector)

# do
variables  <- names(civst_gend_sector)
y_variable  <- variables[1]
x_variables  <- variables[-c(1,4)]
weight  <- civst_gend_sector[,variables[4]]
# NULL
form0  <- reformulate("1",
                      response = y_variable)
form0
model0 <- tree(form0, data = civst_gend_sector, method = "class", weights = weight)
# FIT
form1  <- reformulate(x_variables,
                      response = y_variable)
form1
model1 <- tree(form1, data = civst_gend_sector, method = "class", weights = weight)
# this produces a NaN on node 4!
## > model1 <- tree(form1, data = civst_gend_sector, method = "class", weights = weight)
## > print(model1)
## node), split, n, deviance, yval, (yprob)
##       * denotes terminal node

## 1) root 273 534.00 married ( 0.12088 0.43956 0.43956 )  
##   2) gender: female 132 191.80 single ( 0.07576 0.18182 0.74242 )  
##     4) activity_sector: primary 56    NaN single ( 0.10714 0.00000 0.89286 ) *
##     5) activity_sector: secondary,tertiary 76 123.00 single ( 0.05263 0.31579 0.63158 ) *
##   3) gender: male 141 239.00 married ( 0.16312 0.68085 0.15603 )  
##     6) activity_sector: primary,secondary 113 145.70 married ( 0.11504 0.79646 0.08850 ) *
##     7) activity_sector: tertiary 28  59.41 single ( 0.35714 0.21429 0.42857 ) *
model1 <- tree(form1, data = df, method = "class")
## > print(model1)
## node), split, n, deviance, yval, (yprob)
##       * denotes terminal node

## 1) root 273 534.00 married ( 0.12088 0.43956 0.43956 )  
##   2) gender: female 132 191.80 single ( 0.07576 0.18182 0.74242 )  
##     4) activity_sector: primary 56  38.14 single ( 0.10714 0.00000 0.89286 ) *
##     5) activity_sector: secondary,tertiary 76 123.00 single ( 0.05263 0.31579 0.63158 ) *
##   3) gender: male 141 239.00 married ( 0.16312 0.68085 0.15603 )  
##     6) activity_sector: primary,secondary 113 145.70 married ( 0.11504 0.79646 0.08850 ) *
##     7) activity_sector: tertiary 28  59.41 single ( 0.35714 0.21429 0.42857 ) *
## > 
model1 <- tree(form1, data = df, method = "class")
print(model1)
plot(model1)
# can't plot if used civst_gender_sector
text(model1,pretty = NULL)
