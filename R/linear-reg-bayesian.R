#' Bayesian linear regression
#'
#' A wrapper around [mlpack::bayesian_linear_regression()] that allows
#' passing a formula.
#'
#' @seealso [mlpack::bayesian_linear_regression()] [predict.baritsu_blr()]
#'
#' @param formula A formula.
#' @param data A data.frame.
#' @param center Logical;
#' if enabled, centers the data and fits the intercept.
#' @param scale Logical;
#' if enabled, scales each feature by their standard deviations.
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_blr}.
#' @export
linear_regression_bayesian <- function(
  formula = NULL,
  data = NULL,
  center = FALSE,
  scale = FALSE,
  x = NULL,
  y = NULL
) {
  data <- mold(formula, data, x, y)
  if (!all_finite(data$outcomes)) {
    rlang::abort("outcomes can contain finite numerics only.")
  }
  check_predictors(data$predictors)

  blr_model <-
    mlpack::bayesian_linear_regression(
      input = data$predictors,
      responses = data$outcomes,
      center = center,
      scale = scale
    )
  blr_model <-
    list(
      fit = blr_model$output_model,
      blueprint = data$blueprint
    )
  class(blr_model) <- c("baritsu_blr", class(blr_model))
  blr_model
}

#' @rdname predict.baritsu
#' @export
predict.baritsu_blr <- function(object, newdata, ...) {
  if (!is_exptr_of(object, "BayesianLinearRegression")) {
    rlang::abort("stored model must be a 'BayesianLinearRegression'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  check_predictors(newdata$predictors)
  pred <-
    mlpack::bayesian_linear_regression(
      input_model = object$fit,
      test = newdata$predictors
    )
  tibble::tibble(
    .pred = as.double(pred[["predictions"]]),
    .stds = as.double(pred[["stds"]])
  )
}
