#' Least angle regression
#'
#' @description
#' `lars()` defines a model that can predict numeric values from
#' predictors using a wrapper of [mlpack::lars()].
#'
#' [mlpack::lars()] is an implementation of Least Angle Regression
#' (Stagewise/laSso), also known as LARS.
#'
#' @details
#' For this model, there is a single mode: regression
#'
#' ## Tuning Parameters
#'
#' This model has 2 tuning parameters:
#'
#' - `lambda1` Amount of regularization for Lasso Penalty (type: double)
#' - `lambda2` Amount of regularization for Ridge Penalty (type: double)
#'
#' @param mode A single character string for the type of model.
#' The only possible value for this model is "regression".
#' @param engine A single character string specifying what computational engine
#' to use for fitting.
#' @param lambda1 Regularization parameter for L1-norm penalty.
#' @param lambda2 Regularization parameter for L2-norm penalty.
#' @rdname details_lars_baritsu
#' @aliases lars
#' @export
lars <- function(
  mode = "regression",
  engine = "baritsu",
  lambda1 = NULL,
  lambda2 = NULL
) {
  if (mode != "regression") {
    rlang::abort("`mode` should be 'regression'")
  }
  # Capture the arguments in quosures
  args <- list(
    lambda1 = rlang::enquo(lambda1),
    lambda2 = rlang::enquo(lambda2)
  )
  parsnip::new_model_spec(
    "lars",
    args = args,
    eng_args = NULL,
    mode = mode,
    user_specified_mode = !missing(mode),
    method = NULL,
    engine = engine,
    user_specified_engine = !missing(engine)
  )
}

#' @rdname details_lars_baritsu
#' @method update lars
#' @export
update.lars <- function(
  object,
  parameters = NULL,
  lambda1 = NULL,
  lambda2 = NULL,
  fresh = FALSE,
  ...
) {
  args <- list(
    lambda1 = rlang::enquo(lambda1),
    lambda2 = rlang::enquo(lambda2)
  )
  parsnip::update_spec(
    object = object,
    parameters = parameters,
    args_enquo_list = args,
    fresh = fresh,
    cls = "lars",
    ...
  )
}

#' @export
tunable.lars <- function(x, ...) {
  tibble::tibble(
    name = c(
      "lambda1",
      "lambda2"
    ),
    call_info = list(
      list(pkg = "dials", fun = "penalty_L1", range = c(0, 1)),
      list(pkg = "dials", fun = "penalty_L2", range = c(0, 1))
    ),
    source = "model_spec",
    component = "lars",
    component_id = "main"
  )
}

register_lars_baritsu <- function() {
  parsnip::set_new_model("lars")
  parsnip::set_model_mode("lars", "regression")
  parsnip::set_model_engine("lars", "regression", "baritsu")
  parsnip::set_fit(
    model = "lars",
    eng = "baritsu",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "linear_regression"),
      defaults = list(
        no_intercept = FALSE,
        no_normalize = FALSE,
        use_cholesky = FALSE
      )
    )
  )
  parsnip::set_model_arg(
    model = "lars",
    eng = "baritsu",
    parsnip = "lambda1",
    original = "lambda1",
    func = list(pkg = "dials", fun = "penalty_L1"),
    has_submodel = FALSE
  )
  parsnip::set_model_arg(
    model = "lars",
    eng = "baritsu",
    parsnip = "lambda2",
    original = "lambda2",
    func = list(pkg = "dials", fun = "penalty_L2"),
    has_submodel = FALSE
  )
  parsnip::set_encoding(
    model = "lars",
    eng = "baritsu",
    mode = "regression",
    options = list(
      predictor_indicators = "traditional",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )
  parsnip::set_pred(
    model = "lars",
    eng = "baritsu",
    mode = "regression",
    type = "numeric",
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
  parsnip::set_dependency("lars", "baritsu", "baritsu")
}
