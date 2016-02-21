
#' @name fill_columns
#' @title fill columns
#' @param x a data frame
#' @param col.name a column name
#' @return a filled data frame
#' @export
#'
fill_columns <- function(x, col.name) {
    s <- which(!x[[col.name]] == "")
    item <- x[[col.name]][s]
    hold <- vector('list', length(item))      
    for(i in 1: length(hold)) hold[[i]] <- rep(item[i], ifelse(is.na(s[i+1]), dim(x)[1] + 1, s[i+1]) - s[i])
    x[[col.name]] <- unlist(hold)
    return(x)
    }
