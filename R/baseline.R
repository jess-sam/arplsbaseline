library("Rcpp")
#' baseline
#'
#' Calculate baseline
#'
#' @param x 
#' @return num
#' @export

Spectrum <- function(baseline, raw_data) {
  structure(
    list(
      baseline = baseline,
      raw_data = raw_data
    ),
    class = "Spectrum"
  )
}

baseline <- function(data, lambda, ratio) {
  
  baseline_data <- rcpp_baseline(data, lambda, ratio)
  spec <- Spectrum(baseline_data, data)
  return(spec)
}

