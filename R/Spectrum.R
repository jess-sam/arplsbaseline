
#' @importFrom stats sd
#' @importFrom graphics lines
#' @importFrom reshape2 melt
#' @importFrom rlang .data

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
as.data.frame.Spectrum <- function(x, row.names = NULL, optional = FALSE, ...) {
  return(data.frame(baseline = x$baseline, 
                    X = x$x, original = x$y, 
                    corrected = x$corrected))
}

#' @export
print.Spectrum <- function(x, ...) {
  cat("Type: Spectrum object \n")
  cat("Number of signals recorded:", length(x$corrected))
}

#' @export
summary.Spectrum <- function(object, ...) {
  x <- object$corrected
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
plot.Spectrum <- function(x, y = NULL, ...) {
  df <- as.data.frame.Spectrum(x)
  df_long <- melt(data = df, id.vars = "X", value.name = "Signal", 
                  variable.name = "Data")
  
  plot_spec <- ggplot2::ggplot(df_long, ggplot2::aes(x = .data$X, 
                                                     y = .data$Signal, 
                                                     color = .data$Data)) + 
    ggplot2::labs(x = "Wavenumber", title = "Spectra Visualisation") +
    ggplot2::geom_line(linewidth = 0.8) +
    ggplot2::theme_bw() +
    ggplot2::scale_color_manual(values=c("turquoise3", "grey30", "darkmagenta"))
  plot_spec
}
