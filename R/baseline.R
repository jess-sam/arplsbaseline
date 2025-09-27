
#' baseline
#'
#' Calculate baseline using the ARPLS method by sourcing an Rcpp function
#'
#' @param data Dataframe of frequencies/wavenumbers with signal intensity
#' @param lambda Regularisation term to control the smoothness of the baseline, default is 1e4
#' @return Spectrum Object of custom Spectrum class
#' @export 

baseline <- function(data, lambda = 1e4) {
  
  # @param ratio Value to control stopping condition, default is 1e-4
  x <- data[[1]]
  y <- data[[2]]
  
  if (length(x) != length(y)) {
    stop("Column dimensions of the data must be the same")
  }
  
  if (!is.numeric(x) | (!is.numeric(y))) {
    stop("Both columns of dataframe must be numeric")
  }
  
  # removing NA 
  valid <- !(is.na(x) | is.na(y))
  x <- x[valid]
  y <- y[valid]
  
  if(length(x) < 10 | length(y) < 10) {
    stop("There must be at least 10 non-NA elements in each column")
  }
  
  if(!missing(lambda) & lambda < 1) {
    stop("Lambda should not be less than 1")
  }
  
  if(!missing(lambda) & lambda > 1e10) {
    stop("Lambda should be a smaller value")
  }
  
#  if(!missing(ratio) & ratio > 1) {
#    stop("Ratio should not be greater than 1")
#  }
  
  baseline_data <- rcpp_baseline(y, lambda, 1e-4) # ratio
  corrected <- y - baseline_data
  # vectors for consistency
  spec <- Spectrum(as.vector(baseline_data), x, y, as.vector(corrected))
  return(spec)
}