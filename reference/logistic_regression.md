# L2-regularized logistic regression

A wrapper around
[`mlpack::logistic_regression()`](https://rdrr.io/pkg/mlpack/man/logistic_regression.html)
that allows passing a formula.

## Usage

``` r
logistic_regression(
  formula = NULL,
  data = NULL,
  penalty = 1e-04,
  epochs = 1000,
  decision_boundary = 0.5,
  tolerance = 1e-10,
  optimizer = c("lbfgs", "sgd"),
  batch_size = 64,
  learn_rate = 0.01,
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

- decision_boundary:

  Decision boundary for prediction; if the logistic function for a point
  is less than the boundary, the class is taken to be 0; otherwise, the
  class is 1.

- tolerance:

  Convergence tolerance for optimizer.

- optimizer:

  Optimizer to use for training ("lbfgs" or "sgd").

- batch_size:

  Batch size for SGD.

- learn_rate:

  Step size for SGD optimizer.

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_lgr`.

## See also

[`mlpack::logistic_regression()`](https://rdrr.io/pkg/mlpack/man/logistic_regression.html)
[`predict.baritsu_lgr()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
