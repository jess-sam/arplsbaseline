library("Rcpp")
#' baseline
#'
#' Calculate baseline
#'
#' @param x 
#' @return num
#' @export

baseline <- function(data, lambda, ratio) {
  x <- data[[1]]
  y <- data[[2]]
  baseline_data <- rcpp_baseline(y, lambda, ratio)
  corrected <- y - baseline_data
  spec <- Spectrum(baseline_data, x, y, corrected)
  return(spec)
}