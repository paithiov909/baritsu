#' Single level neural network via baritsu
#'
#' [mlpack::perceptron()] is an implementation of a perceptron,
#' which is a single level neural network.
#'
#' @details
#' For this engine, there is a single mode: classification
#'
#' ## Tuning Parameters
#'
#' This model has 1 tuning parameter:
#'
#' - `epochs`: Maximum number of iterations (type: integer)
#'
#' @name details_mlp_baritsu
#' @keywords internal
NULL

register_mlp_baritsu <- function() {
  parsnip::set_model_engine("mlp", "classification", "baritsu")
  parsnip::set_fit(
    model = "mlp",
    eng = "baritsu",
    mode = "classification",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "perceptron"),
      defaults = list()
    )
  )
  parsnip::set_model_arg(
    model = "mlp",
    eng = "baritsu",
    parsnip = "epochs",
    original = "epochs",
    func = list(pkg = "dials", fun = "epochs"),
    has_submodel = FALSE
  )
  parsnip::set_encoding(
    model = "mlp",
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
    model = "mlp",
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
          newdata = rlang::expr(new_data) # nolint
        )
    )
  )
}
