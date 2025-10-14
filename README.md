
# arplsbaseline Package

<!-- badges: start -->
<!-- badges: end -->

The goal of arplsbaseline is to provide a package which can be used with spectroscopic data, 
as to implement an algorithm from a scientific paper to calculate a baseline to these 
specific data and correct it. This ARPLS method is commonly used with FTIR obtained spectra, 
which map the signal intensity of each particular wavenumber. 

Note: throughout the package, I use the term wavenumber quite interchangeably with the variable x, as well as 
the term signal, or signal intensity, interchangeably with the variable y. 

## Installation

You can install the arplsbaseline package built with tests and vignettes 
from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
# if not already installed

remotes::install_github("jess-sam/arplsbaseline", 
                        build_vignettes = TRUE, 
                        INSTALL_opts = c("--install-tests"))
```

### IMPORTANT NOTE FOR WINDOWS USERS!

This package requires BLAS/LAPACK because it requires RcppArmadillo for linear algebra computations
and if R is not correctly pointing to these, then installation will definitely fail. If the above command fails, 
this may require setting the environment using 
Sys.setenv(PKG_LIBS = "directory path where R’s DLLs are installed and find Rblas and Rlapack"). 

In my machine I use: Sys.setenv(PKG_LIBS = "-LC:/PROGRA ~ 1/R/R-45 ~ 1.1/bin/x64 -lRblas -lRlapack") but
this may change depending on where your own R directory is. 

If this GitHub installation does not work, downloading the .zip file from the GitHub website can unfortunately
give the same result, and requires you to set the system environment again. In general Windows is a bit of 
a pain about this but if everything is set up nicely on your machine, then it should work.

I am fairly certain that it is mostly just Windows which does struggle with the installation of 
R packages that require BLAS/LAPACK because Windows does not have a compiler. 

## Testing

Running the developer unit tests as a quick check that the package works can be done by: 

```r
# install.packages("testthat")
# if not already installed

testthat::test_package("arplsbaseline", "tap")
```

Full specifications of what is being tested and how, are given in the test plan 
which can be accessed through a pdf document, found through this link to be used within Github: 
[Test Plan](inst/docs/test_plan.pdf).

Checking working functionality of the package can be done by following step-by-step, the examples 
given in the vignette and making sure this gives the same output.

## Usage

There is a vignette that can be called, which gives examples on how to use the package.
To access this, the following command can be called:

```r
browseVignettes(package = "arplsbaseline")
```
