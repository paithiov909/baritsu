# Random forests via baritsu

[`mlpack::random_forest()`](https://rdrr.io/pkg/mlpack/man/random_forest.html)
is an implementation of the standard random forest algorithm by Leo
Breiman for classification.

## Details

For this engine, there is a single mode: classification

### Tuning Parameters

This model has 3 tuning parameters:

- `mtry`: Randomly Selected Predictors (type: integer)

- `trees`: Trees (type: integer)

- `min_n`: Minimal Node Size (type: integer)
