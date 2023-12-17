#' Softmax regression
#'
#' A wrapper around [mlpack::softmax_regression()]
#' that allows passing a formula.
#'
#' @seealso [mlpack::softmax_regression()]
#'
#' @param formula A formula.
#' Alternatively, a recipe object can be passed for this argument.
#' If a recipe is passed, \code{data} is ignored.
#' @param data A data.frame.
#' @param penalty L2-regularization constant.
#' @param stop_iter Maximum number of iterations.
#' @param no_intercept Logical; passed to [mlpack::softmax_regression()].
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_sr}.
#' @export
softmax_regression <- function(
  formula = NULL,
  data = NULL,
  penalty = .001,
  stop_iter = 400,
  no_intercept = FALSE,
  x = NULL,
  y = NULL
) {
  data <- mold(formula, data, x, y)
  if (ncol(data$outcomes) > 1) {
    # need to make sure outcomes are not multiple.
    rlang::abort(
      "outcomes consist of more than one column. verify LHS of formula."
    )
  }
  check_predictors(data$predictors)
  check_outcomes(data$outcomes)

  sr_model <-
    mlpack::softmax_regression(
      training = data$predictors,
      labels = data$outcomes,
      lambda = penalty,
      max_iterations = stop_iter,
      no_intercept = no_intercept,
      number_of_classes = nlevels(data$outcomes[[1]])
    )
  sr_model <-
    list(
      fit = sr_model$output_model,
      blueprint = data$blueprint
    )
  class(sr_model) <- c("baritsu_sr", class(sr_model))
  sr_model
}

#' Softmax regression prediction
#'
#' Predicts with new data using a softmax regression model.
#'
#' @param object An object of class \code{baritsu_sr}.
#' @param newdata A data.frame.
#' @param type Type of prediction. One of "both", "class", or "prob".
#' @returns A tibble that contains the predicted values and/or probabilities.
#' @export
predict.baritsu_sr <- function(
  object, newdata,
  type = c("both", "class", "prob")
) {
  type <- rlang::arg_match(type, c("both", "class", "prob"))
  if (!is_exptr_of(object, "SoftmaxRegression")) {
    rlang::abort("stored model must be a 'SoftmaxRegression'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  pred <-
    mlpack::softmax_regression(
      input_model = object$fit,
      test = newdata$predictors
    )
  pred_to_tbl(
    pred,
    labs = levels(object$blueprint$ptypes$outcomes[[1]]),
    type = type
  )
}
