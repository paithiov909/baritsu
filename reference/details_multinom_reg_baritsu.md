# Multinomial regression via baritsu

[`mlpack::softmax_regression()`](https://rdrr.io/pkg/mlpack/man/softmax_regression.html)
is an implementation of a softmax regression, a generalization of
logistic regression to the multiclass case, which has support for L2
regularization.

## Details

For this engine, there is a single mode: classification

### Tuning Parameters

This model has 1 tuning parameter:

- `penalty`: Amount of Regularization (type: double)
