
################################################################
# name:bounding_box
require(xtable)
#if (!require(rgdal)) install.packages('rgdal'); require(rgdal)
#epsg <- make_EPSG()
# load
d <- read.table(textConnection(
"ID    long       lat
1  150.555699999 -35.093059999999999
2  150.685199999 -35.015359999999999 
3  150.671099999 -35.064129999999999 
4  150.653499999 -35.086669999999999 
"), header = TRUE)
# do
str(d)
head(d)
epsg <- make_EPSG()
# epsg[grep("GDA94$", epsg$note),]
projection  <- '4283'
pts <- SpatialPointsDataFrame(cbind(d$long, d$lat), d,
  proj4string=CRS(epsg$prj4[epsg$code %in% projection]))
str(pts)
loc  <- morpho_bounding_box(x = pts)
loc
print(xtable(loc), type = 'html')
