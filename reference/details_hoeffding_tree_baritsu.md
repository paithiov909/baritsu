# Hoeffding trees via baritsu

`hoeffding_tree()` defines a Hoeffding tree model.

## Usage

``` r
hoeffding_tree(
  mode = "classification",
  engine = "baritsu",
  confidence_factor = NULL,
  sample_size = NULL
)
```

## Arguments

- mode:

  A single character string for the type of model. The only possible
  value for this model is "classification".

- engine:

  A single character string specifying what computational engine to use
  for fitting.

- confidence_factor:

  Confidence before splitting.

- sample_size:

  Number of passes to take over the dataset.

## Details

For this model, there is a single mode: classification

### Tuning Parameters

This model has 2 tuning parameters:

- `confidence_factor`: Confidence before splitting (type: double)

- `sample_size`: Number of passes to take over the dataset (type: int)

## See also

[`hoeffding_trees()`](https://paithiov909.github.io/baritsu/reference/hoeffding_trees.md)
