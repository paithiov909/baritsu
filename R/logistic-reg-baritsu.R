#' Logistic regression via baritsu
#'
#' [mlpack::logistic_regression()] is an implementation of
#' L2-regularized logistic regression for two-class classification.
#'
#' @details
#' For this engine, there is a single mode: classification
#'
#' ## Tuning Parameters
#'
#' This model has 1 tuning parameter:
#'
#' - `penalty`: Amount of regularization (type: double)
#'
#' @name details_logistic_reg_baritsu
#' @keywords internal
NULL

register_logistic_reg_baritsu <- function() {
  parsnip::set_model_engine("logistic_reg", "classification", "baritsu")
  parsnip::set_fit(
    model = "logistic_reg",
    eng = "baritsu",
    mode = "classification",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "logistic_regression"),
      defaults = list()
    )
  )
  parsnip::set_model_arg(
    model = "logistic_reg",
    eng = "baritsu",
    parsnip = "penalty",
    original = "penalty",
    func = list(pkg = "dials", fun = "penalty"),
    has_submodel = FALSE
  )
  parsnip::set_encoding(
    model = "logistic_reg",
    eng = "baritsu",
    mode = "classification",
    options = list(
      predictor_indicators = "traditional",
      compute_intercept = TRUE,
      remove_intercept = TRUE,
      allow_sparse_x = FALSE
    )
  )
  parsnip::set_pred(
    model = "logistic_reg",
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
    model = "logistic_reg",
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
  parsnip::set_dependency("logistic_reg", eng = "baritsu", pkg = "baritsu")
}
