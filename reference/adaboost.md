# AdaBoost

A wrapper around
[`mlpack::adaboost()`](https://rdrr.io/pkg/mlpack/man/adaboost.html)
that allows passing a formula.

## Usage

``` r
adaboost(
  formula = NULL,
  data = NULL,
  epochs = 1000,
  tolerance = 1e-10,
  weak_learner = c("decision_stump", "perceptron"),
  x = NULL,
  y = NULL
)
```

## Arguments

- formula:

  A formula.

- data:

  A data.frame.

- epochs:

  The maximum number of boosting iterations to be run (0 will run until
  convergence.)

- tolerance:

  The tolerance for change in values of the weighted error during
  training.

- weak_learner:

  Weak learner to use. Either "decision_stump" or "perceptron".

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_ab`.

## See also

[`mlpack::adaboost()`](https://rdrr.io/pkg/mlpack/man/adaboost.html)
[`predict.baritsu_ab()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
