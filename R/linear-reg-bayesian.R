#' Bayesian linear regression
#'
#' A wrapper around [mlpack::bayesian_linear_regression()] that enables
#' formula interface.
#'
#' @seealso [mlpack::bayesian_linear_regression()]
#'
#' @param formula A formula.
#' Alternatively, a recipe object can be passed for this argument.
#' If a recipe is passed, \code{data} is ignored.
#' @param data A data.frame.
#' @param center Logical;
#' if enabled, centers the data and fit the intercept.
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
  # NA check is not necessary.
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

#' Bayesian linear regression prediction
#'
#' Predicts with new data using a Bayesian linear regression model.
#'
#' @param object An object of class \code{baritsu_blr}.
#' @param newdata A data.frame.
#' @returns A tibble that contains the predicted values
#' and the standard deviations of the predictive distribution.
#' @export
predict.baritsu_blr <- function(object, newdata) {
  if (!check_exptr_type(object, "BayesianLinearRegression")) {
    rlang::abort("stored model must be a 'BayesianLinearRegression'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
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