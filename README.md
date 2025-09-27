
# arplsbaseline Package

<!-- badges: start -->
<!-- badges: end -->

The goal of arplsbaseline is to provide a package which can be used with spectroscopic data, 
as to implement an algorithm to calculate a baseline to these specific data and correct it.

## Installation

You can install the development version of arplsbaseline built with tests and vignettes 
from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("jess-sam/arplsbaseline", 
                        build_vignettes = TRUE, 
                        INSTALL_opts = c("--install-tests"))
```

## Testing

A full test plan can be found by accessing the html document, 
found in the directory: [Test Plan HTML](inst/docs/test_plan.html).
Within R, this can be accessed by using the following commands:

``` r
html_path <- system.file("docs", "test_plan.html", package = "arplsbaseline")
browseURL(html_path)
```
Full instructions about how testing the package are included in this test plan. 