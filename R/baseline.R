library("Rcpp")
#' baseline
#'
#' Calculate baseline
#'
#' @param x 
#' @return num
#' @export

baseline <- function(x, lambda, ratio) {

  ans <- rcpp_baseline(x, lambda, ratio)

  return(ans)
}

