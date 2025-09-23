
#' @importFrom stats sd
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
print.Spectrum <- function(spectrum) {
  cat("Type: Spectrum object \n")
  cat("Number of signals recorded:", length(spectrum$corrected))
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
  cat("Skewness:", round(moments::skewness(x),2), "\n")
  cat("Kurtosis:", round(moments::kurtosis(x),2))
}

#' @export
plot.Spectrum <- function(spectrum) {
  plot(spectrum$x, spectrum$y, type = "l")
  lines(spectrum$x, spectrum$corrected, col = "red")
  lines(spectrum$x, spectrum$baseline, col = "blue")
}