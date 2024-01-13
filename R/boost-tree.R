#' AdaBoost
#'
#' A wrapper around [mlpack::adaboost()] that allows passing a formula.
#'
#' @seealso [mlpack::adaboost()] [predict.baritsu_ab()]
#'
#' @param formula A formula.
#' @param data A data.frame.
#' @param epochs The maximum number of boosting iterations
#' to be run (0 will run until convergence.)
#' @param tolerance
#' The tolerance for change in values of the weighted error during training.
#' @param weak_learner Weak learner to use.
#' Either "decision_stump" or "perceptron".
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_ab}.
#' @export
adaboost <- function(
  formula = NULL,
  data = NULL,
  epochs = 1000, # iterations
  tolerance = 1e-10,
  weak_learner = c("decision_stump", "perceptron"),
  x = NULL,
  y = NULL
) {
  weak_learner <-
    rlang::arg_match(weak_learner, c("decision_stump", "perceptron"))

  data <- mold(formula, data, x, y)
  check_outcomes(data$outcomes)
  check_predictors(data$predictors)

  ab_model <-
    mlpack::adaboost(
      training = data$predictors,
      labels = data$outcomes,
      iterations = epochs,
      tolerance = tolerance,
      weak_learner = weak_learner
    )
  ab_model <-
    list(
      fit = ab_model$output_model,
      blueprint = data$blueprint
    )
  class(ab_model) <- c("baritsu_ab", class(ab_model))
  ab_model
}

#' @rdname predict.baritsu
#' @export
predict.baritsu_ab <- function(
  object, newdata,
  type = c("both", "class", "prob"),
  ...
) {
  if (!is_exptr_of(object, "AdaBoostModel")) {
    rlang::abort("stored model must be an 'AdaBoostModel'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  check_predictors(newdata$predictors)
  pred <-
    mlpack::adaboost(
      input_model = object$fit,
      test = newdata$predictors
    )
  pred_to_tbl(
    pred,
    labs = levels(object$blueprint$ptypes$outcomes[[1]]),
    type = type
  )
}
