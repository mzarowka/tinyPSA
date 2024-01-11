
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tinyPSA

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/beckman.coulter)](https://CRAN.R-project.org/package=tinyPSA)

<!-- badges: end -->

The goal of tinyPSA is to make it easier to process large amounts of csv
data files produced from Particle Size Analysis output using Shiny
interface. Fit specifically for The Sedimentary Records of Environmental
Change Laboratory, Northern Arizona University.

## Installation

You can install the development version of tinyPSA from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("mzarowka/tinyPSA")
```

There are three main functions:

- `tpsa_read()` - for reading multiple csv files.

- `tpsa_gstat_populate()` for populating GRADISTAT.

- `tpsa_gstat_read()` for cleaning GRADISTAT output.

And a helper shiny dashboard

``` r
tinyPSA::tpsa_app()
```
