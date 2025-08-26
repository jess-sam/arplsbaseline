library("Rcpp")
#' baseline
#'
#' Calculate baseline
#'
#' @param x 
#' @return num
#' @export

Spectrum <- function(baseline, x, y, corrected) {
  structure(
    list(
      baseline = baseline,
      x = x,
      y = y,
      corrected = corrected
    ),
    class = "Spectrum"
  )
}

#' @export
summary.Spectrum <- function(spectrum) {
  x <- spectrum$corrected
  cat("---------Summary of Corrected Spectrum----------\n")
  cat("Mean: ", round(mean(x),2), "\n")
  cat("Standard Deviation:", round(sd(x),2),"\n")
  cat("Maximum Signal", max(x), "\n")
  cat("Minimum Signal", min(x), "\n")
  cat("Range of Signals", range(x), "\n")
}

baseline <- function(data, lambda, ratio) {
  x <- data[[1]]
  y <- data[[2]]
  baseline_data <- rcpp_baseline(y, lambda, ratio)
  corrected <- y - baseline_data
  spec <- Spectrum(baseline_data, x, y, corrected)
  return(spec)
}