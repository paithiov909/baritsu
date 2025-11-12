# Linear regression

A wrapper around
[`mlpack::linear_regression()`](https://rdrr.io/pkg/mlpack/man/linear_regression.html)
and [`mlpack::lars()`](https://rdrr.io/pkg/mlpack/man/lars.html) that
allows passing a formula.

## Usage

``` r
linear_regression(
  formula = NULL,
  data = NULL,
  lambda1 = 0,
  lambda2 = 0,
  no_intercept = FALSE,
  no_normalize = FALSE,
  use_cholesky = FALSE,
  x = NULL,
  y = NULL
)
```

## Arguments

- formula:

  A formula.

- data:

  A data.frame.

- lambda1:

  Regularization parameter for L1-norm penalty.

- lambda2:

  Regularization parameter for L2-norm penalty.

- no_intercept:

  Logical; passed to
  [`mlpack::lars()`](https://rdrr.io/pkg/mlpack/man/lars.html).

- no_normalize:

  Logical; passed to
  [`mlpack::lars()`](https://rdrr.io/pkg/mlpack/man/lars.html).

- use_cholesky:

  Logical; passed to
  [`mlpack::lars()`](https://rdrr.io/pkg/mlpack/man/lars.html).

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_lr`.

## Details

When the lambda1 is 0, this function fallbacks to
[`mlpack::linear_regression()`](https://rdrr.io/pkg/mlpack/man/linear_regression.html)
for performance.

## See also

[`mlpack::linear_regression()`](https://rdrr.io/pkg/mlpack/man/linear_regression.html)
[`mlpack::lars()`](https://rdrr.io/pkg/mlpack/man/lars.html)
[`predict.baritsu_lr()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
