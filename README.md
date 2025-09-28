
# arplsbaseline Package

<!-- badges: start -->
<!-- badges: end -->

The goal of arplsbaseline is to provide a package which can be used with spectroscopic data, 
as to implement an algorithm from a scientific paper to calculate a baseline to these 
specific data and correct it.

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
and if R is not correctly pointing to these, then installation will definitely fail. This may require 
setting the environment using 
Sys.setenv(PKG_LIBS = "directory path where R’s DLLs are installed and find Rblas and Rlapack"). 

In my machine I use: Sys.setenv(PKG_LIBS = "-LC:/PROGRA ~ 1/R/R-45 ~ 1.1/bin/x64 -lRblas -lRlapack") but
this may change depending on where your own R directory is. 

If this GitHub installation does not work, downloading the .zip file from the GitHub website can unfortunately
give the same result, and requires you to set the system environment again. In general Windows is a bit of 
a pain about this but if everything is set up nicely on your machine, then it should work.

I also cannot guarantee 100% the GitHub installation will work with Linux or Mac users, since I don't have one,
but it does seem to be commonly known that it is mostly just Windows which does struggle with the installation of 
R packages that require BLAS/LAPACK.

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
