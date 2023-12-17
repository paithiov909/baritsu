#' Multinomial regression via baritsu
#'
#' [mlpack::softmax_regression()] is an implementation of
#' a softmax regression, a generalization of logistic regression
#' to the multiclass case, which has support for L2 regularization.
#'
#' @details
#' For this engine, there is a single mode: classification
#'
#' ## Tuning Parameters
#'
#' This model has 1 tuning parameters:
#'
#' - `penalty`: Amount of Regularization (type: double)
#'
#' @name details_multinom_reg_baritsu
#' @keywords internal
register_multinom_reg_baritsu <- function() {
  parsnip::set_model_engine("multinom_reg", "classification", "baritsu")
  parsnip::set_fit(
    model = "multinom_reg",
    eng = "baritsu",
    mode = "classification",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "softmax_regression"),
      defaults = list()
    )
  )
  parsnip::set_model_arg(
    model = "multinom_reg",
    eng = "baritsu",
    parsnip = "penalty",
    original = "penalty",
    func = list(pkg = "dials", fun = "penalty"),
    has_submodel = FALSE
  )
  parsnip::set_encoding(
    model = "multinom_reg",
    eng = "baritsu",
    mode = "classification",
    options = list(
      predictor_indicators = "traditional",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )
  parsnip::set_pred(
    model = "multinom_reg",
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
    model = "multinom_reg",
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
}
