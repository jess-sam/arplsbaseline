
#' baseline
#'
#' Calculate baseline using the ARPLS method by sourcing an Rcpp function
#'
#' @param data Dataframe of wavenumbers with signal intensity
#' @param lambda Regularisation term to control the smoothness of the baseline, default is 1e4
#' @return Spectrum Object of custom Spectrum class
#' @export 

baseline <- function(data, lambda = 1e4) {

  if (missing(data)) {
    stop("Data argument cannot be empty")
  }
  
  if (!is.data.frame(data)){
    stop("Data must be in the form of a dataframe")
  }
  
  if (!missing(lambda)) {
    
    if(length(lambda) > 1){
      message("Lambda must be a single numeric value between 1 and 1e10, default lambda of 1e4 will now be used")
      lambda <- 1e4
    }
    
    if(is.na(lambda) | lambda < 1 | lambda > 1e10) {
      message("Lambda must be a single numeric value between 1 and 1e10, default lambda of 1e4 will now be used")
      lambda <- 1e4
    }
  }
  
  x <- data[[1]]
  y <- data[[2]]
  
  if (!is.numeric(x) | (!is.numeric(y))) {
    stop("Both columns of dataframe must be numeric")
  }
  
  if(length(unique(x)) < length(x)){
    stop("Samples need more unique wavenumbers")
  }
  
  # removing NA 
  if(anyNA(x) | anyNA(y)){
    message("Samples with NA will be removed")
  }
  valid <- !(is.na(x) | is.na(y))
  x <- x[valid]
  y <- y[valid]
  
  if (length(x) < 10 | length(y) < 10) {
    stop("There must be at least 10 non-NA elements in each column")
  }
  
  if (length(x) > 7000) {
    ans <- readline("WARNING! Large dataset could potentially take more than 5 minutes to compute a baseline. Do you wish to continue? [Y/N]:")
    if(ans != "Y") {
      stop("Aborted by user")
    }
    message("Computation in process! Please wait patiently! :D")
  }
  
  if (all(y == 0)) {
    stop("Data cannot be all 0")
  }
  
  baseline_data <- tryCatch(
  {
    rcpp_baseline(y, lambda, 1e-4)
  },
  error = function(e) {
    stop("Rcpp failed :( try again with another dataset: ", conditionMessage(e))
  }
)
  corrected <- y - baseline_data
  # vectors for consistency
  spec <- Spectrum(as.vector(baseline_data), x, y, as.vector(corrected))
  return(spec)
}