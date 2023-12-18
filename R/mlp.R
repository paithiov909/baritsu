#' Single level neural network
#'
#' A wrapper around [mlpack::perceptron()]
#' that allows passing a formula.
#'
#' @seealso [mlpack::perceptron()]
#'
#' @param formula A formula.
#' Alternatively, a recipe object can be passed for this argument.
#' If a recipe is passed, \code{data} is ignored.
#' @param data A data.frame.
#' @param epochs Maximum number of iterations.
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_prc}.
#' @export
perceptron <- function(
  formula = NULL,
  data = NULL,
  epochs = 100, # max_iterations
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

  prc_model <-
    mlpack::perceptron(
      training = data$predictors,
      labels = data$outcomes,
      max_iterations = epochs
    )
  prc_model <- list(
    fit = prc_model$output_model,
    blueprint = data$blueprint
  )
  class(prc_model) <- c("baritsu_prc", class(prc_model))
  prc_model
}

#' Perceptron prediction
#'
#' Predicts with new data using a perceptron model.
#'
#' @param object An object of class \code{baritsu_prc}.
#' @param newdata A data.frame.
#' @param type Type of prediction (this model only returns predicted class).
#' @returns A tibble that contains predicted class.
#' @export
predict.baritsu_prc <- function(object, newdata, type = "class") {
  type <- rlang::arg_match(type, "class")
  if (!is_exptr_of(object, "PerceptronModel")) {
    rlang::abort("stored model must be a 'PerceptronModel'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  check_predictors(newdata$predictors)
  pred <-
    mlpack::perceptron(
      input_model = object$fit,
      test = newdata$predictors
    )
  # this model only returns predicted class
  labs <- levels(object$blueprint$ptypes$outcomes[[1]])
  tibble::tibble(
    .pred_class = factor(
      pred$predictions[, 1],
      levels = seq_along(labs),
      labels = labs
    )
  )
}
