
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
loc  <- morpho_bounding_box(longitude = d$long,
                    latitude = d$lat,
                    projection = '4283')
loc
print(xtable(loc), type = 'html')
