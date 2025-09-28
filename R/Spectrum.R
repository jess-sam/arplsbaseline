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

#' @title Coerce Spectrum object to data.frame
#' @name as.data.frame.Spectrum
#' @description Converts a Spectrum object into a data.frame.
#' @param x A Spectrum object.
#' @param row.names Not used. Included for consistency with \code{\link[base]{as.data.frame}}.
#' @param optional Not used. Included for consistency with \code{\link[base]{as.data.frame}}.
#' @param ... Not used. Included for consistency with \code{\link[base]{as.data.frame}}.
#' @return A data.frame with spectrum data.
#' @examples
#' # example code to convert to dataframe
#' spec <- baseline(strawberry)
#' as.data.frame(spec)
#' @export
as.data.frame.Spectrum <- function(x, row.names = NULL, optional = FALSE, ...) {
  return(data.frame(baseline = x$baseline, 
                    X = x$x, original = x$y, 
                    corrected = x$corrected))
}

#' @title Print Spectrum
#' @name print.Spectrum
#' @description Prints information about Spectrum object structure
#' @param x A Spectrum object.
#' @param ... Not used. Included for consistency with \code{\link[base]{print}}.
#' @examples
#' # example code to print
#' spec <- baseline(strawberry)
#' print(spec)
#' @export
print.Spectrum <- function(x, ...) {
  cat("------------------------Printing!------------------------\n")
  cat("Type: Spectrum object \n")
  cat("Number of signals recorded:", length(x$corrected), "\n")
  cat("Elements to extract include: baseline, x, y, corrected \n")
  cat("---------------------------------------------------------\n")
}

#' @title Spectrum Summary Statistics
#' @name summary.Spectrum
#' @description Prints summary statistics about the corrected spectrum. This calculates mean,
#'  median, standard deviation, minimum, maximum, signal range and skewness. The maximum also tells
#'  you at what wavenumber this occurs at.
#' @param object A Spectrum object.
#' @param ... Not used. Included for consistency with \code{\link[base]{summary}}.
#' @examples
#' # example code
#' spec <- baseline(strawberry)
#' summary(spec)
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

#' @title Spectra Visualisation
#' @name plot.Spectrum
#' @description Plots the baseline, original data and corrected spectrum all in one plot using ggplot2.
#' @param x A Spectrum object.
#' @param y Not used. Included for consistency with \code{\link[graphics]{plot}}.
#' @param ... Not used. Included for consistency with \code{\link[graphics]{plot}}.
#' @examples
#' # example code
#' spec <- baseline(strawberry)
#' plot(spec)
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