# Single level neural network

A wrapper around
[`mlpack::perceptron()`](https://rdrr.io/pkg/mlpack/man/perceptron.html)
that allows passing a formula.

## Usage

``` r
perceptron(formula = NULL, data = NULL, epochs = 100, x = NULL, y = NULL)
```

## Arguments

- formula:

  A formula.

- data:

  A data.frame.

- epochs:

  Maximum number of iterations.

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_prc`.

## See also

[`mlpack::perceptron()`](https://rdrr.io/pkg/mlpack/man/perceptron.html)
[`predict.baritsu_prc()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
