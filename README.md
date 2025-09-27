
# arplsbaseline Package

<!-- badges: start -->
<!-- badges: end -->

The goal of arplsbaseline is to provide a package which can be used with spectroscopic data, 
as to implement an algorithm to calculate a baseline to these specific data and correct it.

## Installation

You can install the arplsbaseline package built with tests and vignettes 
from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("jess-sam/arplsbaseline", 
                        build_vignettes = TRUE, 
                        INSTALL_opts = c("--install-tests"))
```

## Testing

Running the developer unit tests as a quick check that the package works can be done by: 

```r
testthat::test_dir(
  system.file("tests", package = "arplsbaseline"),
  reporter = "summary")
```

To properly test the entire package with user input data, full instructions of how to do
this are given in the test plan which can be accessed through a pdf document, 
found through this directory: [Test Plan](inst/docs/test_plan.pdf).

Within R, this plan can be accessed by using the following commands:

``` r
rmd_path <- system.file("docs", "tutorial.Rmd", package = "arplsbaseline")
rmarkdown::render(rmd_path)
```

The test plan describes situations that need to be tested and commands which will test this. 