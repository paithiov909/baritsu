register_linear_reg_baritsu <- function() {
  parsnip::set_model_engine("linear_reg", "regression", "baritsu")
  parsnip::set_fit(
    model = "linear_reg",
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
    model = "linear_reg",
    eng = "baritsu",
    parsnip = "mixture",
    original = "mixture",
    func = list(pkg = "dials", fun = "mixture"),
    has_submodel = FALSE
  )
  parsnip::set_encoding(
    model = "linear_reg",
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
    model = "linear_reg",
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
  parsnip::set_dependency("linear_reg", eng = "baritsu", pkg = "baritsu")
}
