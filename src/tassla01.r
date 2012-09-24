
################################################################
# name:tassla06
# ABS spatial units are available at http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1259.0.30.0022006?OpenDocument
dir.create('data')
setwd('data')
download.file('http://www.abs.gov.au/AUSSTATS/subscriber.nsf/log?openagent&1259030002_sla06aaust_shape.zip&1259.0.30.002&Data%20Cubes&18E90A962EFD4D7ECA25795D00244F5A&0&2006&06.12.2011&Previous',
              'SLA06.zip', mode = 'wb')
unzip('SLA06.zip',junkpaths=T)

sink('readme.txt')
  cat(paste('Australian Bureau of Statistics Statistical Local Areas 2006
  downloaded on', Sys.Date(),
  '
  from http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1259.0.30.0022006?OpenDocument')
  )
sink()

# and load spatial data (sd)
install.packages('rgdal')
require(rgdal)
sd <- readOGR('SLA06aAUST.shp', layer = 'SLA06aAUST')
# might take a while
head(sd@data)
plot(sd)
dev.off()
save.image('aussd.Rdata')

######################
# tas
sd2 <-  sd[ sd@data$STATE_CODE == 6,]
 plot(sd2)
 axis(1);axis(2); box()
# plot(sd, add = T)
 names(sd2@data)
 writeOGR(sd2,'tassla06.shp','tassla06','ESRI Shapefile')
 test <- readOGR(dsn = 'tassla06.shp', layer = 'tassla06')
 plot(test, col = 'grey')
 rm(sd)
# save.image('tassd.Rdata')
