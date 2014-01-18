
require(devtools)
install_github("disentangle", "ivanhanigan")
require(disentangle)
# load
fpath <- system.file(file.path("extdata", "civst_gend_sector_full.csv"), package = "disentangle")

analyte  <- read.csv(fpath)
analyte$random <- rnorm(nrow(analyte), 0 , 1)
summary(analyte)
# create a large number of randome variables
for(i in 1:75)
  {
    analyte[,ncol(analyte) + 1] <- rnorm(nrow(analyte), 10 , 20)    
  }
names(analyte)
str(analyte)
analyte_varlist <- as.data.frame(names(analyte))
write.csv(analyte_varlist, "inst/extdata/civst_gend_sector_withrnorm.csv", row.names=F)
# edit with spreadsheet to include H1, H2, H3
analyte_varlist <- read.csv("inst/extdata/civst_gend_sector_withrnorm.csv", stringsAsFactor = F)
str(analyte_varlist)
