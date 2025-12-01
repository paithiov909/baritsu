
<!-- README.md is generated from README.Rmd. Please edit that file -->

# baritsu

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/paithiov909/baritsu/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/paithiov909/baritsu/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/paithiov909/baritsu/branch/main/graph/badge.svg?token=LWH2AFDEMY)](https://app.codecov.io/gh/paithiov909/baritsu)
<!-- badges: end -->

The main goal of baritsu is to implement wrappers for
[mlpack](https://www.mlpack.org/doc/stable/r_documentation.html) that
allows formula as their argument. Also, baritsu provides
[parsnip](https://parsnip.tidymodels.org/) engines of those wrappers, so
they can be used with [tidymodels](https://www.tidymodels.org/)
workflows.

## Installation

You can install the development version of baritsu from
[GitHub](https://github.com/) with:

``` r
remotes::install_github("paithiov909/baritsu")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
suppressPackageStartupMessages({
  require(tidymodels)
  require(baritsu)
})

data("penguins", package = "modeldata")

set.seed(1218)
data_split <- initial_split(penguins, strata = species)
penguins_train <- training(data_split)
penguins_test <- testing(data_split)

rec <-
  recipe(
    species ~ .,
    data = penguins_train
  ) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors())

spec <-
  decision_tree(
    tree_depth = 0,
    min_n = 5
  ) |>
  set_engine("baritsu") |>
  set_mode("classification")

translate(spec)
#> Decision Tree Model Specification (classification)
#> 
#> Main Arguments:
#>   tree_depth = 0
#>   min_n = 5
#> 
#> Computational engine: baritsu 
#> 
#> Model fit template:
#> baritsu::decision_trees(formula = missing_arg(), data = missing_arg(), 
#>     x = missing_arg(), y = missing_arg(), tree_depth = 0, min_n = 5)

wf_fit <- workflow() |>
  add_recipe(rec) |>
  add_model(spec) |>
  fit(penguins_train)

pred <- augment(wf_fit, penguins_test) |>
  dplyr::select(species, .pred_class)

pred
#> # A tibble: 86 × 2
#>    species .pred_class
#>    <fct>   <fct>      
#>  1 Adelie  Adelie     
#>  2 Adelie  Adelie     
#>  3 Adelie  Adelie     
#>  4 Adelie  Adelie     
#>  5 Adelie  Adelie     
#>  6 Adelie  Adelie     
#>  7 Adelie  Adelie     
#>  8 Adelie  Adelie     
#>  9 Adelie  Adelie     
#> 10 Adelie  Adelie     
#> # ℹ 76 more rows

f_meas(pred, truth = species, estimate = .pred_class)
#> # A tibble: 1 × 3
#>   .metric .estimator .estimate
#>   <chr>   <chr>          <dbl>
#> 1 f_meas  macro          0.957
```
