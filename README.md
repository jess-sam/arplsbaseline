
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

## Testing

Running the developer unit tests as a quick check that the package works can be done by: 

```r
# install.packages("testthat")
# if not already installed

testthat::test_package("arplsbaseline", "tap")
```

Full specifications of what is being tested and how  are given in the test plan 
which can be accessed through a pdf document, found through this link to be used within Github: 
[Test Plan](inst/docs/test_plan.pdf).

Within R, this plan can be accessed by using the following commands:

``` r
rmd_path <- system.file("docs", "test_plan.Rmd", package = "arplsbaseline")
rmarkdown::render(rmd_path)
```