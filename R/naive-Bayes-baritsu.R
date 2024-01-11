#' Naive Bayes models via baritsu
#'
#' [mlpack::nbc()] is an implementation of
#' a parametric Naive Bayes Classifier, used for classification.
#'
#' @details
#' For this engine, there is a single mode: classification
#'
#' ## Tuning Parameters
#'
#' This engine has no tuning parameters.
#'
#' @name details_naive_Bayes_baritsu
#' @keywords internal
NULL

register_naive_Bayes_baritsu <- function() { # nolint
  parsnip::set_model_engine("naive_Bayes", "classification", "baritsu")
  parsnip::set_fit(
    model = "naive_Bayes",
    eng = "baritsu",
    mode = "classification",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "naive_bayes"),
      defaults = list()
    )
  )
  parsnip::set_encoding(
    model = "naive_Bayes",
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
    model = "naive_Bayes",
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
    model = "naive_Bayes",
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
  parsnip::set_dependency("naive_Bayes", "baritsu", "baritsu")
}
