
#' @importFrom stats sd
#' @importFrom graphics lines
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
as.data.frame.Spectrum <- function(spectrum) {
  return(data.frame(spectrum$baseline, 
                    spectrum$x, spectrum$y, spectrum$corrected))
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
  cat("Maximum Signal", round(max(x), 2), "\n")
  cat("Minimum Signal", round(min(x), 2), "\n")
  cat("Range of Signals", round(max(x) - min(x), 2), "\n")
  cat("Skewness:", round(moments::skewness(x),2), "\n")
  cat("Kurtosis:", round(moments::kurtosis(x),2))
}

#' @export
plot.Spectrum <- function(spectrum) {
  ylim <- range(c(spectrum$y, spectrum$corrected, spectrum$baseline))
  plot(spectrum$x, spectrum$y, type = "l", ylab = "Signal Intensity", 
       xlab = "Wavenumber", ylim = ylim)
  lines(spectrum$x, spectrum$corrected, col = "red", ylim = ylim)
  lines(spectrum$x, spectrum$baseline, col = "blue", ylim = ylim)
  legend("topright",
         legend=c("data", "corrected data", "baseline"), 
         fill = c("black","red", "blue"))
}
