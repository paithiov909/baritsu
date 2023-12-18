#' Linear regression
#'
#' A wrapper around [mlpack::linear_regression()] and [mlpack::lars()]
#' that allows passing a formula.
#'
#' @details
#' When the mixture is 0, this function
#' fallbacks to [mlpack::linear_regression()] for performance.
#'
#' @seealso [mlpack::linear_regression()] [mlpack::lars()]
#'
#' @param formula A formula.
#' Alternatively, a recipe object can be passed for this argument.
#' If a recipe is passed, \code{data} is ignored.
#' @param data A data.frame.
#' @param mixture Regularization parameter within `[0, 1]` (default: 1.0)
#' This value will be passed to lambda1 (for l1-norm penalty) as is,
#' and `1.0 - mixture` will be passed to lambda2 (for l2-norm penalty).
#' @param no_intercept Logical; passed to [mlpack::lars()].
#' @param no_normalize Logical; passed to [mlpack::lars()].
#' @param use_cholesky Logical; passed to [mlpack::lars()].
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_lr}.
#' @export
linear_regression <- function(
  formula = NULL,
  data = NULL,
  mixture = 1.0,
  no_intercept = FALSE,
  no_normalize = FALSE,
  use_cholesky = FALSE,
  x = NULL,
  y = NULL
) {
  data <- mold(formula, data, x, y)
  # NA check is not necessary.
  if (any(mixture < 0, mixture > 1)) {
    rlang::warn("mixture should be a number between 0 and 1; set to 0.")
    mixture <- 0.0
  }
  # `mixture=1` corresponds to a pure lasso
  lambda1 <- as.double(mixture) # for lasso
  lambda2 <- as.double(1.0 - lambda1) # for ridge

  if (lambda1 == 0.0) {
    lr_model <-
      mlpack::linear_regression(
        training = data$predictors,
        training_responses = data$outcomes,
        lambda = lambda2
      )
  } else {
    lr_model <-
      mlpack::lars(
        input = data$predictors,
        responses = data$outcomes,
        lambda1 = lambda1,
        lambda2 = lambda2,
        no_intercept = no_intercept,
        no_normalize = no_normalize,
        use_cholesky = use_cholesky
      )
  }
  lr_model <-
    list(
      fit = lr_model$output_model,
      blueprint = data$blueprint
    )
  class(lr_model) <- c("baritsu_lr", class(lr_model))
  lr_model
}

#' Linear regression prediction
#'
#' Predicts with new data using a linear regression model.
#'
#' @param object An object of class \code{baritsu_lr}.
#' @param newdata A data.frame.
#' @returns A tibble that contains the predicted values.
#' @export
predict.baritsu_lr <- function(object, newdata) {
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  if (is_exptr_of(object, "LinearRegression")) {
    pred <-
      mlpack::linear_regression(
        input_model = object$fit,
        test = newdata$predictors
      )
  } else if (is_exptr_of(object, "LARS")) {
    pred <-
      mlpack::lars(
        input_model = object$fit,
        test = newdata$predictors
      )
  } else {
    rlang::abort("stored model must be a 'LinearRegression' or a 'LARS'.")
  }
  tibble::tibble(
    .pred = as.double(pred[["output_predictions"]])
  )
}
