# Random forests

A wrapper around
[`mlpack::random_forest()`](https://rdrr.io/pkg/mlpack/man/random_forest.html)
that allows passing a formula.

## Usage

``` r
random_forest(
  formula = NULL,
  data = NULL,
  mtry = 0,
  trees = 10,
  min_n = 1,
  maximum_depth = 0,
  minimum_gain_split = 0,
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

- mtry:

  Subspace dimension. If 0, autoselects the square root of data
  dimensionality.

- trees:

  Number of trees.

- min_n:

  Minimum number of data points in a leaf.

- maximum_depth:

  Maximum depth of the tree.

- minimum_gain_split:

  Minimum gain required to split an internal node.

- seed:

  Random seed. If 0, `std::time(NULL)` is used internally.

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_rf`.

## See also

[`mlpack::random_forest()`](https://rdrr.io/pkg/mlpack/man/random_forest.html)
[`predict.baritsu_rf()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
