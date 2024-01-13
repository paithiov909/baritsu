#' AdaBoost via baritsu
#'
#' [mlpack::adaboost()] is an implementation of
#' the AdaBoost.MH (Adaptive Boosting) algorithm for classification.
#'
#' @details
#' For this engine, there is a single mode: classification
#'
#' ## Tuning Parameters
#'
#' This model has no tuning parameters.
#'
#' @name details_boost_tree_baritsu
#' @keywords internal
NULL

register_boost_tree_baritsu <- function() {
  parsnip::set_model_engine("boost_tree", "classification", "baritsu")
  parsnip::set_fit(
    model = "boost_tree",
    eng = "baritsu",
    mode = "classification",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "adaboost"),
      defaults = list()
    )
  )
  parsnip::set_encoding(
    model = "boost_tree",
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
    model = "boost_tree",
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
    model = "boost_tree",
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
  parsnip::set_dependency("boost_tree", "baritsu", "baritsu")
}
