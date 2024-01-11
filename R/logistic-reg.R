#' L2-regularized logistic regression
#'
#' A wrapper around [mlpack::logistic_regression()]
#' that allows passing a formula.
#'
#' @seealso [mlpack::logistic_regression()] [predict.baritsu_lgr()]
#'
#' @param formula A formula.
#' @param data A data.frame.
#' @param penalty L2-regularization constant.
#' @param stop_iter Maximum number of iterations.
#' @param decision_boundary Decision boundary for prediction;
#' if the logistic function for a point is less than the boundary,
#' the class is taken to be 0; otherwise, the class is 1.
#' @param tolerance Convergence tolerance for optimizer.
#' @param optimizer Optimizer to use for training ("lbfgs" or "sgd").
#' @param batch_size Batch size for SGD.
#' @param learn_rate Step size for SGD optimizer.
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_lgr}.
#' @export
logistic_regression <- function(
  formula = NULL,
  data = NULL,
  penalty = 0.0001, # lambda
  stop_iter = 1000, # max_iterations
  decision_boundary = 0.5,
  tolerance = 1e-10,
  optimizer = c("lbfgs", "sgd"),
  batch_size = 64,
  learn_rate = 0.01, # step_size
  x = NULL,
  y = NULL
) {
  optimizer <- rlang::arg_match(optimizer, c("lbfgs", "sgd"))
  data <- mold(formula, data, x, y)
  if (ncol(data$outcomes) > 1) {
    # need to make sure outcomes are not multiple.
    rlang::abort(
      "outcomes consist of more than one column. verify LHS of formula."
    )
  }
  check_outcomes(data$outcomes)
  if (nlevels(data$outcomes[[1]]) > 2) {
    rlang::abort(
      "outcome consists of more than two classes."
    )
  }
  check_predictors(data$predictors)

  lgr_model <-
    mlpack::logistic_regression(
      training = data$predictors,
      labels = data$outcomes,
      lambda = penalty,
      max_iterations = stop_iter,
      decision_boundary = decision_boundary,
      tolerance = tolerance,
      optimizer = optimizer,
      batch_size = batch_size,
      step_size = learn_rate
    )
  lgr_model <-
    list(
      fit = lgr_model$output_model,
      blueprint = data$blueprint
    )
  class(lgr_model) <- c("baritsu_lgr", class(lgr_model))
  lgr_model
}

#' @rdname predict.baritsu
#' @export
predict.baritsu_lgr <- function(
  object, newdata,
  type = c("both", "class", "prob"),
  ...
) {
  if (!is_exptr_of(object, "LogisticRegression")) {
    rlang::abort("stored model must be a 'LogisticRegression'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  check_predictors(newdata$predictors)
  pred <-
    mlpack::logistic_regression(
      input_model = object$fit,
      test = newdata$predictors
    )
  pred_to_tbl(
    pred,
    labs = levels(object$blueprint$ptypes$outcomes[[1]]),
    type = type
  )
}
