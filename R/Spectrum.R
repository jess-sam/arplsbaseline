#' @importFrom stats sd quantile
#' @importFrom graphics lines
#' @importFrom reshape2 melt
#' @importFrom rlang .data

#' @keywords internal
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
  cat("------------------------Printing!------------------------\n")
  cat("Type: Spectrum object \n")
  cat("Number of signals recorded:", length(x$corrected), "\n")
  cat("Elements to extract include: baseline, x, y, corrected \n")
  cat("---------------------------------------------------------\n")
}

#' @export
summary.Spectrum <- function(object, ...) {
  x <- object$corrected
  index <- which(x == max(x))
  
  cat("---------Summary of Corrected Spectrum----------\n")
  cat("Mean:", round(mean(x),4), "\n")
  cat("Standard Deviation:", round(sd(x),4),"\n")
  cat("Median:", round(quantile(x, 0.5), 4), "\n")
  cat("Maximum:", round(max(x), 4), "\n", "at Wavenumber:", object$x[index], "\n")
  cat("Minimum:", round(min(x), 4), "\n")
  cat("Signal Range:", round(max(x) - min(x), 4), "\n")
  cat("Skewness:", round(moments::skewness(x),4), "\n")
  cat("------------------------------------------------\n")
}

#' @export
plot.Spectrum <- function(x, y = NULL, ...) {
  df <- as.data.frame.Spectrum(x)
  df_long <- melt(data = df, id.vars = "X", value.name = "Signal", 
                  variable.name = "Data")
  
  plot_spec <- ggplot2::ggplot(df_long, ggplot2::aes(x = .data$X, 
                                                     y = .data$Signal, 
                                                     color = .data$Data)) + 
    ggplot2::labs(x = "Wavenumber (1/cm)", title = "Spectra Visualisation") +
    ggplot2::geom_line(linewidth = 0.8) +
    ggplot2::theme_bw() +
    ggplot2::scale_color_manual(values=c("turquoise3", "grey30", "darkmagenta"))
  plot_spec
}