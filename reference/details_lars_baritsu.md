# Least angle regression

`lars()` defines a model that can predict numeric values from predictors
using
[`linear_regression()`](https://paithiov909.github.io/baritsu/reference/linear_regression.md),
a wrapper of
[`mlpack::lars()`](https://rdrr.io/pkg/mlpack/man/lars.html).

[`mlpack::lars()`](https://rdrr.io/pkg/mlpack/man/lars.html) is an
implementation of Least Angle Regression (Stagewise/laSso), also known
as LARS.

## Usage

``` r
lars(
  mode = "regression",
  engine = "baritsu",
  penalty_L1 = NULL,
  penalty_L2 = NULL
)
```

## Arguments

- mode:

  A single character string for the type of model. The only possible
  value for this model is "regression".

- engine:

  A single character string specifying what computational engine to use
  for fitting.

- penalty_L1:

  Regularization parameter for L1-norm penalty.

- penalty_L2:

  Regularization parameter for L2-norm penalty.

## Details

For this model, there is a single mode: regression

### Tuning Parameters

This model has 2 tuning parameters:

- `penalty_L1` Amount of regularization for Lasso Penalty (type: double)

- `penalty_L2` Amount of regularization for Ridge Penalty (type: double)

## See also

[`linear_regression()`](https://paithiov909.github.io/baritsu/reference/linear_regression.md)
