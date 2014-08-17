
################################################################
# name:names_lcu
names_lcu <- function(x){
  names(x)<-lcu(names(x))
  return(names(x))
}
