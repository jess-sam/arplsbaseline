#' @importFrom stats sd quantile
#' @importFrom graphics lines
#' @importFrom reshape2 melt
#' @importFrom rlang .data
#' @importFrom mgcv gam
#' @importFrom gridExtra grid.arrange

#' @keywords internal
Spectrum <- function(baseline, wavenumber, original_signal, corrected_signal) {
  structure(
    list(
      baseline = baseline,
      wavenumber = wavenumber,
      original_signal = original_signal,
      corrected_signal = corrected_signal
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
                    wavenumber = x$wavenumber, original_signal = x$original_signal, 
                    corrected_signal = x$corrected_signal))
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
  cat("Number of signals recorded:", length(x$corrected_signal), "\n")
  cat("Elements to extract include: \n baseline, wavenumber, original_signal, corrected_signal \n")
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
  x <- object$corrected_signal
  index <- which(x == max(x))
  
  cat("---------Summary of Corrected Spectrum----------\n")
  cat("Mean:", round(mean(x),4), "\n")
  cat("Standard Deviation:", round(sd(x),4),"\n")
  cat("Median:", round(quantile(x, 0.5), 4), "\n")
  cat("Maximum:", round(max(x), 4), "\n", "at Wavenumber:", object$wavenumber[index], "\n")
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
  df_long <- melt(data = df, id.vars = "wavenumber", value.name = "original_signal", 
                  variable.name = "Data")
  
  plot_spec <- ggplot2::ggplot(df_long, ggplot2::aes(x = .data$wavenumber, 
                                                     y = .data$original_signal, 
                                                     color = .data$Data)) + 
    ggplot2::labs(x = "Wavenumber (1/cm)", y = "Signal Intensity", 
                  title = "Spectra Visualisation") +
    ggplot2::geom_line(linewidth = 0.8) +
    ggplot2::theme_bw() +
    ggplot2::scale_color_manual(values=c("turquoise3", "grey30", "darkmagenta")) +
    ggplot2::scale_x_reverse()
  plot_spec
}


#' @export
baseline_stats <- function(spectrum, full_summary = FALSE, return_gam = FALSE) {
  
  df <- as.data.frame(spectrum)
  
  fit.gam <- gam(df$baseline ~ s(df$wavenumber), method = "REML")
  fit.summ <- summary(fit.gam)
  fit.summ$s.pv
  cat("------------------------------------------------\n")
  cat("---------------GAM Fitting Summary--------------\n")
  cat("------------------------------------------------\n")
  cat("Expected Degrees of Freedom: ", round(fit.summ$edf,4), "\n")
  cat("(EDF equivalent to number of basis functions) \n")
  cat("\n")
  cat("Adjusted R^2: ", round(fit.summ$r.sq,4), "\n")
  cat("Deviance Explained : ", round(fit.summ$dev.expl,4), "\n")
  cat("Smooth Term Significance p-value: ", round(fit.summ$s.pv,4), "\n")
  cat("------------------------------------------------\n")
  
  if (full_summary) {
    print(fit.summ)
  }
  
  pred <- predict(fit.gam)
  new_df <- data.frame(wavenumber = df$wavenumber, pred = pred)
  
  resid_df <- data.frame(Index = 1:length(pred), Residuals = fit.gam$residuals)
  
  model_plot <- ggplot2::ggplot() +
    ggplot2::geom_line(data = new_df, ggplot2::aes(x = .data$wavenumber, y = .data$pred, color = "Fitted GAM Baseline"), size = 1) +
    ggplot2::geom_point(data = df, ggplot2::aes(x = .data$wavenumber, y = .data$baseline, color = "Original Baseline"), size = 0.5 , shape = 4) +
    ggplot2::labs(x = "Wavenumber (1/cm)", y = "Signal Intensity",
                  title = "Visualisation of Baseline GAM Fitting") +
    ggplot2::theme_bw() +
    ggplot2::scale_color_manual(
      name = "Legend", 
      values = c("Original Baseline" = "blue", "Fitted GAM Baseline" = "red")) +
    ggplot2::scale_x_reverse()
  
  residual_plot <- ggplot2::ggplot() +
    ggplot2::geom_point(data = resid_df, ggplot2::aes(x = .data$Index, y = .data$Residuals)) +
    ggplot2::labs(title = "Visualisation of GAM Residuals") +
    ggplot2::theme_bw() +
    ggplot2::scale_x_reverse()
  
  grid.arrange(model_plot, residual_plot, nrow = 2) 
  
  if (return_gam) {
    return (fit.gam)
  }
}
