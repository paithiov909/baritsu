# Decision trees via baritsu

[`mlpack::decision_tree()`](https://rdrr.io/pkg/mlpack/man/decision_tree.html)
is an implementation of an ID3-style decision tree for classification,
which supports categorical data.

## Details

For this engine, there is a single mode: classification

### Tuning Parameters

This model has 2 tuning parameters:

- `tree_depth`: Tree depth (type: integer)

- `min_n`: Minimal Node Size (type: integer)
