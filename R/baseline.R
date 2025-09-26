
#' baseline
#'
#' Calculate baseline using the arpls method by sourcing an Rcpp function
#'
#' @param data Dataframe of frequencies/wavenumbers with signal intensity
#' @param lambda Regularisation term to control the smoothness of the baseline, default is 1e4
#' @param ratio Value to control stopping condition, default is 1e-4
#' @param start_mask Lower limit of wavenumbers to ignore in baseline algorithm
#' @param end_mask Upper limit of wavenumbers to ignore in baseline algorithm
#' @return Spectrum Object of custom Spectrum class
#' @export 

baseline <- function(data, lambda = 1e4, ratio = 1e-4, 
                     start_mask = 0, end_mask = 0) {
  
  mask = FALSE
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
  
  if(length(x) < 10) {
    stop("There must be at least 10 non-NA elements in each column")
  }
  
  alg_y <- y
  
  if (start_mask > 0 & end_mask > 0) {
    mask = TRUE
    masked_indices <- which(x >= start_mask & x <= end_mask)
    alg_y <- y[-masked_indices]
  
    if(length(alg_y) < 10) {
      stop("There must be at least 10 non-masked entries")
    }
  }
  
  if(!missing(lambda) & lambda < 1) {
    stop("Lambda should not be less than 1")
  }
  
  if(!missing(ratio) & ratio > 1) {
    stop("Ratio should not be greater than 1")
  }

  baseline_data <- rcpp_baseline(alg_y, lambda, ratio)

  if (mask) {
    baseline_complete<- rep(0, length(y))      
    baseline_complete[masked_indices] <- 0        
    baseline_complete[-masked_indices] <- baseline_data 
    baseline_data <- baseline_complete
  }
  
  corrected <- y - baseline_data
  
  spec <- Spectrum(baseline_data, x, y, corrected)
  return(spec)
}