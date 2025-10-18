---
bibliography: references.bib
---

# arplsbaseline Package

<!-- badges: start -->

<!-- badges: end -->

The aim for arplsbaseline is to provide a package which can be used with spectral data, as to implement an algorithm from a scientific paper to calculate a baseline to these specific data and correct it. This baseline correction method which uses asymmetrically reweighted penalised least squares, @baek2015, is commonly used with FTIR obtained spectra, which map the signal intensity of each particular wavenumber.

## Installation

You can install the arplsbaseline package built with tests and vignettes from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
# if not already installed

remotes::install_github("jess-sam/arplsbaseline/tree/final_version", 
                        build_vignettes = TRUE, 
                        INSTALL_opts = c("--install-tests"))
```

## Testing

Running the developer unit tests as a quick check that the package works can be done by:

``` r
# install.packages("testthat")
# if not already installed

testthat::test_package("arplsbaseline", "tap")
```

Full specifications of what can be tested and how, are given in the test plan which can be accessed through a pdf document, found through this link to be used within Github: [Test Plan](inst/docs/test_plan.pdf).

## Usage

There is a vignette that can be called, which gives full instructions on how to use the package. To access this, the following command can be called:

``` r
browseVignettes(package = "arplsbaseline")
```

# References
