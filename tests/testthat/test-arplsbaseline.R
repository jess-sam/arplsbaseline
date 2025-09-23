library(testthat)
library(arplsbaseline)
test_baseline <- function() {
  
  x <- c(1,2,3,NA,4,5,6,7,8,9,10,11,12,13,14,15)
  y = c(2,64,NA,23,17,7,8,2,NA,9,43,14,8,14,18,7)
  data <- data.frame(x,y)
  
  test_that("NA values have been removed", {
    
    spec <- baseline(data) 
    
    expect_false(any(is.na(spec$x)))
    expect_false(any(is.na(spec$y)))
    
    expect_lt(length(spec$x), length(x))
    expect_lt(length(spec$y), length(y))
  })
  
  test_that("The data should be numeric", {
    data2 <- data.frame(x = c("test",1:10), y = 1:11)
    expect_error(baseline(data2), 
                 "Both columns of dataframe must be numeric")
  })
  
  test_that("The data must have enough elements",{
    data3 <- data.frame(x = 1:9, y = 1:9)
    expect_error(baseline(data3), 
                 "There must be at least 10 non-NA elements in each column")})
  
  test_that("Lambda is a reasonable value", {
    expect_error(baseline(data, lambda = 0.2), 
                 "Lambda should not be less than 1")
  })
  
  test_that("Ratio is a reasonable value", {
    expect_error(baseline(data, ratio = 100), 
                 "Ratio should not be greater than 1")
  })
  
  test_that("The baseline function returns a Spectrum object", {
    spec <- baseline(data) 
    expect_s3_class(spec, "Spectrum")
  })
}

test_baseline()
