################################################################
# name:bounding_box
morpho_bounding_box <- function(x){
  ## Check if spatial obj and proj4string is valid
  #str(x)
  bb <- x@bbox
  #bb
  # TODO polygons
  # TODO only for southern hemisphere, east of GMT?
  loc <- data.frame(
    rbind(
      c(NA, round(abs(bb[2,2]), 5), NA),
      c(round(bb[1,1], 5),  NA, round(bb[1,2],5)),
      c(NA, round(abs(bb[2,1]),5), NA)
      )
    )
  #loc
  loc$X2[c(1,3)] <- sprintf("%s S", abs(loc$X2[c(1,3)]))
  loc[2,c(1,3)] <- sprintf("%s E", abs(loc[2,c(1,3)]))

  return(loc)
  }
