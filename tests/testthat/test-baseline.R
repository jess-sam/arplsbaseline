library(testthat)
library(arplsbaseline)

x <- c(1,2,3,NA,4,5,6,7,8,9,10,11,12,13,14,15)
y = c(2,64,NA,23,17,7,8,2,NA,9,43,14,8,14,18,7)
data <- data.frame(x,y)
strawberry <- arplsbaseline::strawberry

test_that("Incorrect data format throws an error", {
  expect_error(baseline(NA), "Data must be in the form of a dataframe with 2 columns")
  expect_error(baseline(c(2,3), "Data must be in the form of a dataframe with 2 columns"))
  expect_error(baseline(2), "Data must be in the form of a dataframe with 2 columns")
})

test_that("Dataframe has appropriate number of columns", {
  expect_error(baseline(cbind(strawberry, rep(1, nrow(strawberry)))), 
               "Dataframe must only have 2 columns")
})

test_that("NA values have been removed", {
  
  spec <- baseline(data) 
  expect_false(any(is.na(spec$x)))
  expect_false(any(is.na(spec$y)))
  expect_lt(length(spec$x), length(x))
  expect_lt(length(spec$y), length(y))
})

test_that("The function throws an error if data is not numeric", {
  data2 <- data.frame(x = c("test",1:10), y = 1:11)
  expect_error(baseline(data2), 
               "Both columns of dataframe must be numeric")
})

test_that("The function throws an error if the data does not have enough elements",{
  data4 <- data.frame(x = 1:9, y = 1:9)
  expect_error(baseline(data4), "There must be at least 10 non-NA elements in each column")})


test_that("Lambda incorrectly entered, gives a message is given that the default value is used", {
  expect_message(
    baseline(strawberry, c(1,2)),
    "Lambda must be a single numeric value between 1 and 1e10, default lambda of 1e4 will now be used"
  )
  
  expect_message(
    baseline(strawberry, NA),
    "Lambda must be a single numeric value between 1 and 1e10, default lambda of 1e4 will now be used"
  )
})

################################
#####Masking Functionality######
################################


test_that("Function gives a message for incorrect masking arguments", {
  expect_message(
    baseline(strawberry, start_mask = "", end_mask = 1500),
    "At least one of the masking limits is not numeric, no masking will be used."
  )
  
  expect_message(
    baseline(strawberry, start_mask = 1500, end_mask = ""),
    "At least one of the masking limits is not numeric, no masking will be used."
  )

  expect_message(
    baseline(strawberry, start_mask = 2, end_mask = 1500),
    "At least one of the masking limits is out of the range of the presented wavenumbers, no masking will be used."
  )
  
  expect_message(
    baseline(strawberry, start_mask = 1500, end_mask = 2),
    "Starting wavenumber to mask should not be larger than the end wavenumber, no masking will be used."
  )
  
  expect_message(
    baseline(strawberry, end_mask = 1500), 
    "One of the start or end limits for masking is missing, no masking will be used."
  )
  
  expect_message(
    baseline(strawberry, start_mask = 1500), 
    "One of the start or end limits for masking is missing, no masking will be used."
  )
})

test_that("Function returns an error if not enough non-masked entries", {
  expect_error(
    baseline(data.frame(1:10, 1:10), start_mask = 1, end_mask = 10), 
    "There must be at least 10 non-masked entries"
  )
  
  expect_error(
    baseline(data.frame(c(1:18,NA), rnorm(19)), start_mask = 1, end_mask = 10), 
    "There must be at least 10 non-masked entries"
  )
})


##################
###Edge Cases#####
##################

test_that("Empty baseline function throws an error", {
  expect_error(baseline(), "Data argument cannot be empty")
})

test_that("Function throws an error if signals are all 0", {
  data5 <- data.frame(x = 1:15, y = rep(0,15))
  expect_error(baseline(data5), "Signal intensity values cannot be all 0")
})

test_that("Function throws an error if wavenumbers are not unique", {
  data5 <- data.frame(x = rep(0,20), y = 1:20)
  expect_error(baseline(data5), "Wavenumbers must not contain duplicates")
})

test_that("Function returns an error for Rcpp if dataset gets past input checks but still fails", {
  expect_error(baseline(data.frame(c(1:20, NA), 1:21)), "Rcpp failed")
})
