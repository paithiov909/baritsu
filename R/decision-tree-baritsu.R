#' Decision trees via baritsu
#'
#' [mlpack::decision_tree()] is an implementation of
#' an ID3-style decision tree for classification,
#' which supports categorical data.
#'
#' @details
#' For this engine, there is a single mode: classification
#'
#' ## Tuning Parameters
#'
#' This model has 2 tuning parameters:
#'
#' - `tree_depth`: Tree depth (type: integer)
#' - `min_n`: Minimal Node Size (type: integer)
#'
#' ## Preprocessing requirements
#'
#' Factor/categorical predictors need to be converted to numeric values
#' (e.g., dummy or indicator variables) for this engine.
#' When using the formula method via \code{\link[=fit.model_spec]{fit()}},
#' parsnip will convert factor columns to indicators.
#'
#' @name details_decision_tree_baritsu
#' @keywords internal
register_decision_tree_baritsu <- function() {
  parsnip::set_model_engine("decision_tree", "classification", "baritsu")
  parsnip::set_fit(
    model = "decision_tree",
    eng = "baritsu",
    mode = "classification",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "decision_trees"),
      defaults = list(
        minimum_gain_split = 1e-7
      )
    )
  )
  parsnip::set_model_arg(
    model = "decision_tree",
    eng = "baritsu",
    parsnip = "tree_depth",
    original = "tree_depth",
    func = list(pkg = "dials", fun = "tree_depth"),
    has_submodel = FALSE
  )
  parsnip::set_model_arg(
    model = "decision_tree",
    eng = "baritsu",
    parsnip = "min_n",
    original = "min_n",
    func = list(pkg = "dials", fun = "min_n"),
    has_submodel = FALSE
  )
  parsnip::set_encoding(
    model = "decision_tree",
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
    model = "decision_tree",
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
    model = "decision_tree",
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
  parsnip::set_dependency("decision_tree", eng = "baritsu", pkg = "baritsu")
}
