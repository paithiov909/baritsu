# L2-regularized support vector machine

A wrapper around
[`mlpack::linear_svm()`](https://rdrr.io/pkg/mlpack/man/linear_svm.html)
that allows passing a formula.

## Usage

``` r
linear_svm(
  formula = NULL,
  data = NULL,
  margin = 1,
  penalty = 1e-04,
  epochs = 1000,
  no_intercept = FALSE,
  tolerance = 1e-10,
  optimizer = c("lbfgs", "psgd"),
  stop_iter = 50,
  learn_rate = 0.01,
  shuffle = FALSE,
  seed = 0,
  x = NULL,
  y = NULL
)
```

## Arguments

- formula:

  A formula.

- data:

  A data.frame.

- margin:

  Margin of difference between correct class and other classes.

- penalty:

  L2-regularization constant.

- epochs:

  Maximum iterations for optimizer (0 indicates no limit). This argument
  is passed as `max_iterations`, not as `epochs` for
  [`mlpack::linear_svm()`](https://rdrr.io/pkg/mlpack/man/linear_svm.html).

- no_intercept:

  Logical; passed to
  [`mlpack::linear_svm()`](https://rdrr.io/pkg/mlpack/man/linear_svm.html).

- tolerance:

  Convergence tolerance for optimizer.

- optimizer:

  Optimizer to use for training ("lbfgs" or "psgd").

- stop_iter:

  Maximum number of full epochs over dataset for parallel SGD.

- learn_rate:

  Step size for parallel SGD optimizer. in which data points are visited
  for parallel SGD.

- shuffle:

  Logical; if true, doesn't shuffle the order.

- seed:

  Random seed. If 0, `std::time(NULL)` is used internally.

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_svm`.

## See also

[`mlpack::linear_svm()`](https://rdrr.io/pkg/mlpack/man/linear_svm.html)
[`predict.baritsu_svm()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
