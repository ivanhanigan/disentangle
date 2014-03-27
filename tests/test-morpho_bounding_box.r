
################################################################
# name:bounding_box
require(xtable)
#if (!require(rgdal)) install.packages('rgdal'); require(rgdal)
#epsg <- make_EPSG()
# load
d <- read.table(textConnection(
"ID    long       lat
1  150.5556 -35.09305
2  150.6851 -35.01535
3  150.6710 -35.06412
4  150.6534 -35.08666
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
