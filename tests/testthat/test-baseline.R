library(testthat)
library(arplsbaseline)

x <- c(1,2,3,NA,4,5,6,7,8,9,10,11,12,13,14,15)
y = c(2,64,NA,23,17,7,8,2,NA,9,43,14,8,14,18,7)
data <- data.frame(x,y)
strawberry <- arplsbaseline::strawberry

test_that("Incorrect data format throws an error", {
  expect_error(baseline(NA), "Data must be in the form of a dataframe")
  expect_error(baseline(c(2,3), "Data must be in the form of a dataframe"))
  expect_error(baseline(2), "Data must be in the form of a dataframe")
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
    regexp = "Lambda must be a single numeric value"
  )
  
  expect_message(
    baseline(strawberry, NA),
    regexp = "Lambda must be a single numeric value"
  )
})

##################
###Edge Cases#####
##################

test_that("Empty baseline function throws an error", {
  expect_error(baseline(), "Data argument cannot be empty")
})

test_that("Function throws an error if signals are all 0", {
  data5 <- data.frame(x = 1:11, y = rep(0,11))
  expect_error(baseline(data5), "Data cannot be all 0")
})

test_that("Function throws an error if there are not enough wavenumbers", {
  data5 <- data.frame(x = rep(0,20), y = 1:20)
  expect_error(baseline(data5), "Samples need more unique wavenumbers")
})