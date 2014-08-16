
################################################################
# name:names_lcu
names_lcu <- function(x){
  names(x)<-gsub("\\.","_",names(x))
  names(x)<-gsub("_+","_",names(x))
  names(x)<-tolower(names(x))
  return(names(x))
}
