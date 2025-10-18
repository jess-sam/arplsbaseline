library(testthat)
library(arplsbaseline)

strawberry <- arplsbaseline::strawberry
spec <- baseline(strawberry, 1e7)

test_that("The baseline function returns a Spectrum object", {
  expect_s3_class(spec, "Spectrum")
})

test_that("Each element from spectrum is a vector", {
  expect_vector(spec$baseline)
  expect_vector(spec$wavenumber)
  expect_vector(spec$original_signal)
  expect_vector(spec$corrected_signal)
})

test_that("Each vector is the same length", {
  expect_equal(length(spec$wavenumber), length(spec$original_signal))
  expect_equal(length(spec$original_signal), length(spec$baseline))
  expect_equal(length(spec$baseline), length(spec$corrected_signal))
})

test_that("Spectrum can convert to dataframe", {
  expect_true(is.data.frame(as.data.frame(spec)))
})

test_that("Summary methods give outputs", {
  expect_output(print(spec))
  expect_output(summary(spec))
})

test_that("GAM method give outputs", {
  expect_output(baseline_gam(spec))
  
  model <- baseline_gam(spec,  return_gam = TRUE)
  expect_s3_class(model, "gam")
})

test_that("Incorrect GAM method inputs give informative errors", {
  expect_error(baseline_gam(spec, full_summary = NA),
               "full_summary and return_gam arguments can only be TRUE or FALSE")
  expect_error(baseline_gam(spec, return_gam = NA),
               "full_summary and return_gam arguments can only be TRUE or FALSE")
  expect_error(baseline_gam(spec,  full_summary = 1),
               "full_summary and return_gam arguments can only be TRUE or FALSE")
  expect_error(baseline_gam(spec,  return_gam = 1),
               "full_summary and return_gam arguments can only be TRUE or FALSE")
  })
