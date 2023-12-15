#' @noRd
add_rand_forest_baritsu <- function() {
  parsnip::set_model_engine("rand_forest", "classification", "baritsu")
  parsnip::set_fit(
    model = "rand_forest",
    eng = "baritsu",
    mode = "classification",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "random_forest"),
      defaults = list(
        maximum_depth = 0,
        minimum_gain_split = 0
      )
    )
  )
  parsnip::set_encoding(
    model = "rand_forest",
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
          object = rlang::expr(object$fit),
          newdata = rlang::expr(new_data),
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
          object = rlang::expr(object$fit),
          newdata = rlang::expr(new_data),
          type = "prob"
        )
    )
  )
  parsnip::set_dependency("rand_forest", eng = "baritsu", pkg = "baritsu")
}
