
<!-- README.md is generated from README.Rmd. Please edit that file -->

# baritsu

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/baritsu)](https://CRAN.R-project.org/package=baritsu)
<!-- badges: end -->

The main goal of baritsu is to implement wrappers around
[mlpack](https://www.mlpack.org/doc/stable/r_documentation.html) that
allows formula as their argument. Also, baritsu provides parsnip engines
of those wrappers, so they can be used with tidymodels workflows.

## Installation

You can install the development version of baritsu from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("paithiov909/baritsu")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
require(tidymodels)
#>  要求されたパッケージ tidymodels をロード中です
#> ── Attaching packages ────────────────────────────────────── tidymodels 1.1.1 ──
#> ✔ broom        1.0.5     ✔ rsample      1.2.0
#> ✔ dials        1.2.0     ✔ tibble       3.2.1
#> ✔ dplyr        1.1.4     ✔ tidyr        1.3.0
#> ✔ ggplot2      3.4.4     ✔ tune         1.1.2
#> ✔ infer        1.0.5     ✔ workflows    1.1.3
#> ✔ modeldata    1.2.0     ✔ workflowsets 1.0.1
#> ✔ purrr        1.0.2     ✔ yardstick    1.2.0
#> ✔ recipes      1.0.8
#> ── Conflicts ───────────────────────────────────────── tidymodels_conflicts() ──
#> ✖ purrr::discard() masks scales::discard()
#> ✖ dplyr::filter()  masks stats::filter()
#> ✖ purrr::is_null() masks testthat::is_null()
#> ✖ dplyr::lag()     masks stats::lag()
#> ✖ tidyr::matches() masks rsample::matches(), dplyr::matches(), testthat::matches()
#> ✖ recipes::step()  masks stats::step()
#> • Use suppressPackageStartupMessages() to eliminate package startup messages

penguins <- modeldata::penguins

data_split <- initial_split(penguins, strata = "species")
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
#>     x = missing_arg(), y = missing_arg(), tree_depth = 0, min_n = 5, 
#>     minimum_gain_split = 1e-07)

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
