
################################################################
# name:bounding_box
morpho_bounding_box <- function(longitude = NA,
                                latitude = NA,
                                projection = '4283'){
  long <- longitude
  lat <- latitude
  d <- as.data.frame(cbind(long, lat))
  ## Treat data frame as spatial points
  epsg <- make_EPSG()
  # epsg[grep("GDA94$", epsg$note),]
  pts <- SpatialPointsDataFrame(cbind(long, lat), d,
    proj4string=CRS(epsg$prj4[epsg$code %in% projection]))
  #str(pts)
  bb <- pts@bbox
  #bb
  # TODO polygons   
  # TODO only for southern hemisphere, east of GMT?
  loc <- data.frame(rbind(
  c(NA, abs(bb[2,2]), NA),
  c(bb[1,1],  NA, bb[1,2]),
  c(NA, abs(bb[2,1]), NA)
  ))
  #loc
  loc$X2[c(1,3)] <- sprintf("%s S", abs(loc$X2[c(1,3)]))
  loc[2,c(1,3)] <- sprintf("%s E", abs(loc[2,c(1,3)]))
   
  return(loc)
  }
