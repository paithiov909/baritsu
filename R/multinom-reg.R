#' Softmax regression
#'
#' A wrapper around [mlpack::softmax_regression()]
#' that allows passing a formula.
#'
#' @seealso [mlpack::softmax_regression()] [predict.baritsu_sr()]
#'
#' @param formula A formula.
#' @param data A data.frame.
#' @param penalty L2-regularization constant.
#' @param epochs Maximum number of iterations.
#' @param no_intercept Logical; passed to [mlpack::softmax_regression()].
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_sr}.
#' @export
softmax_regression <- function(
  formula = NULL,
  data = NULL,
  penalty = .001,
  epochs = 400,
  no_intercept = FALSE,
  x = NULL,
  y = NULL
) {
  data <- mold(formula, data, x, y)
  check_outcomes(data$outcomes)
  check_predictors(data$predictors)

  sr_model <-
    mlpack::softmax_regression(
      training = data$predictors,
      labels = data$outcomes,
      lambda = penalty,
      max_iterations = epochs,
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

#' @rdname predict.baritsu
#' @export
predict.baritsu_sr <- function(
  object, newdata,
  type = c("both", "class", "prob"),
  ...
) {
  if (!is_exptr_of(object, "SoftmaxRegression")) {
    rlang::abort("stored model must be a 'SoftmaxRegression'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  check_predictors(newdata$predictors)
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
