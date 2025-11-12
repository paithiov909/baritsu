# Parametric naive Bayes classifier

A wrapper around
[`mlpack::nbc()`](https://rdrr.io/pkg/mlpack/man/nbc.html) that allows
passing a formula.

## Usage

``` r
naive_bayes(
  formula = NULL,
  data = NULL,
  incremental_variance = FALSE,
  x = NULL,
  y = NULL
)
```

## Arguments

- formula:

  A formula.

- data:

  A data.frame.

- incremental_variance:

  Logical; passed to
  [`mlpack::nbc()`](https://rdrr.io/pkg/mlpack/man/nbc.html).

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_nbc`.

## See also

[`mlpack::nbc()`](https://rdrr.io/pkg/mlpack/man/nbc.html)
[`predict.baritsu_nbc()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
