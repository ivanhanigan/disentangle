
#' @title big points intersect
#' @name big_pt_intersect
#' @param pts a points spatial
#' @param ply a polygons spatial
#' @param chunks how many to split into
#' @return a combined data frame that avoids run out of memory with big points file 
big_pt_intersect <- function(pts, ply, chunks = 100){
  idx <- split(pts@data, 1:chunks)
  #str(idx)
  for(i in 1:length(idx)){
  #i = 1
  print(i)
    ids <- idx[[i]][,1]
  #str(pts@data)
  qc <- pts[pts@data[,1] %in% ids,]
  #str(qc)
  tryCatch(chunk <-  raster::intersect(qc, ply), error = function(err){print(err)})
  if(!exists('chunk_out')){
  
    chunk_out <- chunk@data
  } else {
    chunk_out <- rbind(chunk_out, chunk@data)
  }
  rm(chunk)
  
  }
  #str(chunk_out)
  return(chunk_out)
}
# NB warning about split length multiple is not fatal, just due to nonequal chunks (ie the geocodes are 2009/100)
