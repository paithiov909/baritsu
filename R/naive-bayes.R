#' Parametric Naive Bayes Classifier
#'
#' A wrapper around [mlpack::nbc()] that allows passing a formula.
#'
#' @param formula A formula.
#' Alternatively, a recipe object can be passed for this argument.
#' If a recipe is passed, \code{data} is ignored.
#' @param data A data.frame.
#' @param incremental_variance Logical; passed to [mlpack::nbc()].
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_nbc}.
#' @export
naive_bayes <- function(
  formula = NULL,
  data = NULL,
  incremental_variance = FALSE,
  x = NULL,
  y = NULL
) {
  data <- mold(formula, data, x, y)
  check_predictors(data$predictors)
  check_outcomes(data$outcomes)

  nbc_model <-
    mlpack::nbc(
      training = data$predictors,
      labels = data$outcomes,
      incremental_variance = incremental_variance
    )
  nbc_model <-
    list(
      fit = nbc_model$output_model,
      blueprint = data$blueprint
    )
  class(nbc_model) <- c("baritsu_nbc", class(nbc_model))
  nbc_model
}

#' Naive Bayes Classifier prediction
#'
#' Predicts with new data using a Naive Bayes Classifier model.
#'
#' @param object An object of class \code{baritsu_nbc}.
#' @param newdata A data.frame.
#' @param type Type of prediction. One of "both", "class", or "prob".
#' @param ... Not used.
#' @returns A tibble that contains the predicted values and/or probabilities.
#' @export
predict.baritsu_nbc <- function(
  object, newdata,
  type = c("both", "class", "prob"),
  ...
) {
  type <- rlang::arg_match(type, c("both", "class", "prob"))
  if (!is_exptr_of(object, "NBCModel")) {
    rlang::abort("stored model must be a 'NBCModel'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  check_predictors(newdata$predictors)
  pred <-
    mlpack::nbc(
      input_model = object$fit,
      test = newdata$predictors
    )
  pred_to_tbl(
    pred,
    labs = levels(object$blueprint$ptypes$outcomes[[1]]),
    type = type
  )
}
