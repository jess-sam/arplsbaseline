
#' baseline
#'
#' Calculate baseline using the ARPLS method by sourcing an Rcpp function
#'
#' @param data Dataframe of wavenumbers with corresponding signal intensity, first column must contain wavenumbers and second column signal intensity.
#' @param lambda Regularisation term to control the smoothness of the baseline, default is 1e4, common values to use are in powers of 10, from 1e2 to 1e8. Larger values give smoother baselines.
#' @param start_mask Lower limit of wavenumbers to ignore in baseline algorithm
#' @param end_mask Upper limit of wavenumbers to ignore in baseline algorithm
#' @return Spectrum Object of custom Spectrum class
#' @examples
#' # example code
#' # create spectrum from built-in dataset
#' baseline(ham, lambda = 1e6)
#' # can leave out lambda to use default
#' baseline(strawberry)
#' # masking example
#' baseline(redwine, start_mask = 1400, end_mask = 1500)
#' @export 

baseline <- function(data, lambda = 1e4, start_mask = 0, end_mask = 0) {
  
  mask = FALSE
  
  if (missing(data)) {
    stop("Data argument cannot be empty")
  }
  
  if (!is.data.frame(data)){
    stop("Data must be in the form of a dataframe with 2 columns")
  }
  
  if(ncol(data) != 2) {
    stop("Dataframe must only have 2 columns")
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
    stop("Wavenumbers must not contain duplicates")
  }
  
  # removing NA 
  if(anyNA(x) | anyNA(y)){
    message("Samples with NA will be removed")
  }
  valid <- !(is.na(x) | is.na(y))
  x <- x[valid]
  y <- y[valid]
  
  if (all(y == 0)) {
    stop("Signal intensity values cannot be all 0")
  }
  
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
  
  alg_y <- y
  
  if (!missing(start_mask) & missing(end_mask) | missing(start_mask) & !missing(end_mask)) {
    message("One of the start or end limits for masking is missing, no masking will be used.")
  }
  
  if (!missing(start_mask) & !missing(end_mask)) {
    
    if (!is.numeric(start_mask) | !is.numeric(end_mask)) {
      message("At least one of the masking limits is not numeric, no masking will be used.")
      mask = FALSE
    }
    else if(start_mask > end_mask) {
      message("Starting wavenumber to mask should not be larger than the end wavenumber, no masking will be used.")
      mask = FALSE
    }
    else if (start_mask < min(x) | start_mask > max(x) | end_mask < min(x) | end_mask > max(x)) {
      message("At least one of the masking limits is out of the range of the presented wavenumbers, no masking will be used.")
      mask = FALSE
    }
    else {
      mask = TRUE
    }
  }

  if(mask){
    masked_indices <- which(x >= start_mask & x <= end_mask)
    alg_y <- y[-masked_indices]
  }

  if(length(alg_y) < 10) {
    stop("There must be at least 10 non-masked entries")
  }
  
  baseline_data <- tryCatch(
  {
    rcpp_baseline(alg_y, lambda, 1e-4)
  },
  error = function(e) {
    stop("Rcpp failed :( try again with another dataset: ", conditionMessage(e))
  }
)
  if (mask) {
    baseline_complete <- rep(0, length(y))      
    baseline_complete[masked_indices] <- 0        
    baseline_complete[-masked_indices] <- baseline_data 
    baseline_data <- baseline_complete
  }
  
  corrected <- y - baseline_data
  # vectors for consistency
  spec <- Spectrum(as.vector(baseline_data), x, y, as.vector(corrected))
  return(spec)
}