mergeOptions <- function(opts,defaultOpts){
  optNames <- names(defaultOpts)
  o <- list()
  for(i in optNames){
    o[[i]] <- opts[[i]] %||% defaultOpts[[i]]
  }
  o
}




`%||%` <- function (x, y)
{
  if (is.empty(x))
    return(y)
  else if (is.null(x) || is.na(x))
    return(y)
  else if( class(x)=="character" && nchar(x)==0 )
    return(y)
  else x
}


is.empty <- function(x){
  #   !is.null(x)
  !as.logical(length(x))
}

