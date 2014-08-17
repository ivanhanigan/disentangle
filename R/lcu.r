
################################################################
# name:lcu
lcu <- function(x){
  x <- make.names(x)
  x<-tolower(x)  
  x<-gsub("\\.","_",x)
  x<-gsub("_+","_",x)
  return(x)
}
