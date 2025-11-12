# Prediction using mlpack via baritsu

Predicts with new data using a stored mlpack model.

## Usage

``` r
# S3 method for class 'baritsu_ab'
predict(object, newdata, type = c("both", "class", "prob"), ...)

# S3 method for class 'baritsu_dt'
predict(object, newdata, type = c("both", "class", "prob"), ...)

# S3 method for class 'baritsu_ht'
predict(object, newdata, ...)

# S3 method for class 'baritsu_blr'
predict(object, newdata, ...)

# S3 method for class 'baritsu_lr'
predict(object, newdata, ...)

# S3 method for class 'baritsu_lgr'
predict(object, newdata, type = c("both", "class", "prob"), ...)

# S3 method for class 'baritsu_prc'
predict(object, newdata, ...)

# S3 method for class 'baritsu_sr'
predict(object, newdata, type = c("both", "class", "prob"), ...)

# S3 method for class 'baritsu_nbc'
predict(object, newdata, type = c("both", "class", "prob"), ...)

# S3 method for class 'baritsu_rf'
predict(object, newdata, type = c("both", "class", "prob"), ...)

# S3 method for class 'baritsu_svm'
predict(object, newdata, type = c("both", "class", "prob"), ...)
```

## Arguments

- object:

  An object out of baritsu function.

- newdata:

  A data.frame.

- type:

  Type of prediction. One of "both", "class", or "prob".

- ...:

  Not used.

## Value

A tibble that contains the predictions and/or probabilities (and also
the standard deviations of the predictive distribution only for
`predict.baritsu_blr`).
