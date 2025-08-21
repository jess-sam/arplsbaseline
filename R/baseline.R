library("Rcpp")
#' baseline
#'
#' Calculate baseline
#'
#' @param x 
#' @return num
#' @export

baseline <- function(x) {

  ans <- rcpp_baseline(x, lambda = 2, ratio = 3)

  return(ans)
}

