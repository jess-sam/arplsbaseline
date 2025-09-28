library(testthat)
library(arplsbaseline)

strawberry <- arplsbaseline::strawberry
spec <- baseline(strawberry, 1e7)

test_that("The baseline function returns a Spectrum object", {
  expect_s3_class(spec, "Spectrum")
})

test_that("Each element from spectrum is a vector", {
  expect_vector(spec$baseline)
  expect_vector(spec$x)
  expect_vector(spec$y)
  expect_vector(spec$corrected)
})

test_that("Each vector is the same length", {
  expect_equal(length(spec$x), length(spec$y))
  expect_equal(length(spec$y), length(spec$baseline))
  expect_equal(length(spec$baseline), length(spec$corrected))
})

test_that("Spectrum can convert to dataframe", {
  expect_true(is.data.frame(as.data.frame(spec)))
})

test_that("Summary methods give outputs", {
  expect_output(print(spec))
  expect_output(summary(spec))
})