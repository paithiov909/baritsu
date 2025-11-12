# Bayesian linear regression

A wrapper around
[`mlpack::bayesian_linear_regression()`](https://rdrr.io/pkg/mlpack/man/bayesian_linear_regression.html)
that allows passing a formula.

## Usage

``` r
linear_regression_bayesian(
  formula = NULL,
  data = NULL,
  center = FALSE,
  scale = FALSE,
  x = NULL,
  y = NULL
)
```

## Arguments

- formula:

  A formula.

- data:

  A data.frame.

- center:

  Logical; if enabled, centers the data and fits the intercept.

- scale:

  Logical; if enabled, scales each feature by their standard deviations.

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_blr`.

## See also

[`mlpack::bayesian_linear_regression()`](https://rdrr.io/pkg/mlpack/man/bayesian_linear_regression.html)
[`predict.baritsu_blr()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
