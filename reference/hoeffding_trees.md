# Hoeffding trees

A wrapper around
[`mlpack::hoeffding_tree()`](https://rdrr.io/pkg/mlpack/man/hoeffding_tree.html)
that allows passing a formula.

## Usage

``` r
hoeffding_trees(
  formula = NULL,
  data = NULL,
  confidence_factor = 0.95,
  sample_size = 10,
  max_samples = 5000,
  min_samples = 100,
  info_gain = FALSE,
  batch_mode = FALSE,
  numeric_split_strategy = c("binary", "domingos"),
  num_breaks = 10,
  observations_before_binning = 100,
  x = NULL,
  y = NULL
)
```

## Arguments

- formula:

  A formula.

- data:

  A data.frame.

- confidence_factor:

  Confidence before splitting (between 0 and 1).

- sample_size:

  Number of passes to take over the dataset.

- max_samples:

  Maximum number of samples before splitting.

- min_samples:

  Minimum number of samples before splitting.

- info_gain:

  Logical. If set, information gain is used instead of Gini impurity for
  calculating Hoeffding bounds.

- batch_mode:

  Logical. If true, samples will be considered in batch instead of as a
  stream. This generally results in better trees but at the cost of
  memory usage and runtime.

- numeric_split_strategy:

  The splitting strategy to use for numeric features.

- num_breaks:

  If the "domingos" split strategy is used, this specifies the number of
  bins for each numeric split.

- observations_before_binning:

  If the "domingos" split strategy is used, this specifies the number of
  samples observed before binning is performed.

- x:

  Design matrix.

- y:

  Response matrix.

## Value

An object of class `baritsu_ht`.

## See also

[`mlpack::hoeffding_tree()`](https://rdrr.io/pkg/mlpack/man/hoeffding_tree.html)
[`predict.baritsu_ht()`](https://paithiov909.github.io/baritsu/reference/predict.baritsu.md)
