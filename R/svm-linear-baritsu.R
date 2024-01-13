#' L2-regularized support vector machine via baritsu
#'
#' [mlpack::linear_svm()] is an implementation of
#' linear SVM for multiclass classification.
#'
#' @details
#' For this engine, there is a single mode: classification
#'
#' ## Tuning Parameters
#'
#' This engine has 1 tuning parameter:
#'
#' - `margin`: Insensitivity Margin (type: double)
#'
#' @name details_svm_linear_baritsu
#' @keywords internal
NULL

register_svm_linear_baritsu <- function() {
  parsnip::set_model_engine("svm_linear", "classification", "baritsu")
  parsnip::set_fit(
    model = "svm_linear",
    eng = "baritsu",
    mode = "classification",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "linear_svm"),
      defaults = list(seed = rlang::expr(sample.int(10 ^ 5, 1)))
    )
  )
  parsnip::set_model_arg(
    model = "svm_linear",
    eng = "baritsu",
    parsnip = "margin",
    original = "margin",
    func = list(pkg = "dials", fun = "svm_margin"),
    has_submodel = FALSE
  )
  parsnip::set_encoding(
    model = "svm_linear",
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
    model = "svm_linear",
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
    model = "svm_linear",
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
  parsnip::set_dependency("svm_linear", "baritsu", "baritsu")
}
