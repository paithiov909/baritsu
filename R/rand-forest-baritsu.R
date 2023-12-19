#' Random forests via baritsu
#'
#' [mlpack::random_forest()] is an implementation of
#' the standard random forest algorithm
#' by Leo Breiman for classification.
#'
#' @details
#' For this engine, there is a single mode: classification
#'
#' ## Tuning Parameters
#'
#' This model has 3 tuning parameters:
#'
#' - `mtry`: Randomly Selected Predictors (type: integer)
#' - `trees`: Trees (type: integer)
#' - `min_n`: Minimal Node Size (type: integer)
#'
#' @name details_rand_forest_baritsu
#' @keywords internal
NULL

register_rand_forest_baritsu <- function() {
  parsnip::set_model_engine("rand_forest", "classification", "baritsu")
  parsnip::set_fit(
    model = "rand_forest",
    eng = "baritsu",
    mode = "classification",
    value = list(
      interface = "data.frame",
      data = c(x = "x", y = "y"),
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "random_forest"),
      defaults = list(seed = rlang::expr(sample.int(10 ^ 5, 1)))
    )
  )
  parsnip::set_model_arg(
    model = "rand_forest",
    eng = "baritsu",
    parsnip = "mtry",
    original = "mtry",
    func = list(pkg = "dials", fun = "mtry"),
    has_submodel = FALSE
  )
  parsnip::set_model_arg(
    model = "rand_forest",
    eng = "baritsu",
    parsnip = "trees",
    original = "trees",
    func = list(pkg = "dials", fun = "trees"),
    has_submodel = FALSE
  )
  parsnip::set_model_arg(
    model = "rand_forest",
    eng = "baritsu",
    parsnip = "min_n",
    original = "min_n",
    func = list(pkg = "dials", fun = "min_n"),
    has_submodel = FALSE
  )
  parsnip::set_encoding(
    model = "rand_forest",
    eng = "baritsu",
    mode = "classification",
    options = list(
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )
  parsnip::set_pred(
    model = "rand_forest",
    eng = "baritsu",
    mode = "classification",
    type = "class",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args =
        list(
          object = rlang::expr(object$fit), # nolint
          newdata = rlang::expr(new_data), # nolint
          type = "class"
        )
    )
  )
  parsnip::set_pred(
    model = "rand_forest",
    eng = "baritsu",
    mode = "classification",
    type = "prob",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args =
        list(
          object = rlang::expr(object$fit), # nolint
          newdata = rlang::expr(new_data), # nolint
          type = "prob"
        )
    )
  )
  parsnip::set_dependency("rand_forest", eng = "baritsu", pkg = "baritsu")
}
