# Decision trees

A wrapper around
[`mlpack::decision_tree()`](https://rdrr.io/pkg/mlpack/man/decision_tree.html)
that allows passing a formula.

## Usage

``` r
decision_trees(
  formula = NULL,
  data = NULL,
  tree_depth = 0,
  min_n = 20,
  minimum_gain_split = 1e-07,
  weights = NULL,
  x = NULL,
  y = NULL
)
```

## Arguments

- formula:

  A formula.

- data:

  A data.frame.

- tree_depth:

  Maximum depth of the tree.

- min_n:

  Minimum number of data points in a leaf.

- minimum_gain_split:

  Minimum gain required to split an internal node.

- weights:

  Weights for each observation.

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_dt`.

## Details

To prevent masking of
[`parsnip::decision_tree()`](https://parsnip.tidymodels.org/reference/decision_tree.html),
this function is named `decision_trees` (plural form!)

## See also

[`mlpack::decision_tree()`](https://rdrr.io/pkg/mlpack/man/decision_tree.html)
[`predict.baritsu_dt()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
