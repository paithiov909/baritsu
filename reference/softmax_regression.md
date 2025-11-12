# Softmax regression

A wrapper around
[`mlpack::softmax_regression()`](https://rdrr.io/pkg/mlpack/man/softmax_regression.html)
that allows passing a formula.

## Usage

``` r
softmax_regression(
  formula = NULL,
  data = NULL,
  penalty = 0.001,
  epochs = 400,
  no_intercept = FALSE,
  x = NULL,
  y = NULL
)
```

## Arguments

- formula:

  A formula.

- data:

  A data.frame.

- penalty:

  L2-regularization constant.

- epochs:

  Maximum number of iterations.

- no_intercept:

  Logical; passed to
  [`mlpack::softmax_regression()`](https://rdrr.io/pkg/mlpack/man/softmax_regression.html).

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_sr`.

## See also

[`mlpack::softmax_regression()`](https://rdrr.io/pkg/mlpack/man/softmax_regression.html)
[`predict.baritsu_sr()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
