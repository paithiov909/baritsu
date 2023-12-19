#' L2-regularized support vector machine
#'
#' A wrapper around [mlpack::linear_svm()] that allows passing a formula.
#'
#' @seealso [mlpack::linear_svm()] [predict.baritsu_svm()]
#'
#' @param formula A formula.
#' Alternatively, a recipe object can be passed for this argument.
#' If a recipe is passed, \code{data} is ignored.
#' @param data A data.frame.
#' @param margin Margin of difference between correct class and other classes.
#' @param penalty L2-regularization constant.
#' @param stop_iter Maximum iterations for optimizer (0 indicates no limit).
#' @param no_intercept Logical; passed to [mlpack::linear_svm()].
#' @param tolerance Convergence tolerance for optimizer.
#' @param optimizer Optimizer to use for training ("lbfgs" or "psgd").
#' @param epochs Maximum number of full epochs over dataset for parallel SGD.
#' @param shuffle Logical; if true, doesn't shuffle the order
#' in which data points are visited for parallel SGD.
#' @param step_size Step size for parallel SGD optimizer.
#' @param seed Random seed. If 0, `std::time(NULL)` is used internally.
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_svm}.
#' @export
linear_svm <- function(
  formula = NULL,
  data = NULL,
  margin = 1.0, # delta
  penalty = 1.0, # lambda
  stop_iter = 1000, # max_iterations
  no_intercept = FALSE,
  tolerance = 1e-10,
  optimizer = c("lbfgs", "psgd"),
  epochs = 50,
  shuffle = FALSE,
  step_size = 0.01,
  seed = 0,
  x = NULL,
  y = NULL
) {
  optimizer <- rlang::arg_match(optimizer, c("lbfgs", "psgd"))
  data <- mold(formula, data, x, y)
  if (ncol(data$outcomes) > 1) {
    # need to make sure outcomes are not multiple.
    rlang::abort(
      "outcomes consist of more than one column. verify LHS of formula."
    )
  }
  check_predictors(data$predictors)
  check_outcomes(data$outcomes)

  svm_model <-
    mlpack::linear_svm(
      training = data$predictors,
      labels = data$outcomes,
      delta = margin,
      lambda = penalty,
      max_iterations = stop_iter,
      no_intercept = no_intercept,
      tolerance = tolerance,
      optimizer = optimizer,
      epochs = epochs,
      shuffle = shuffle,
      step_size = step_size,
      seed = seed,
      num_classes = nlevels(data$outcomes[[1]])
    )
  svm_model <-
    list(
      fit = svm_model$output_model,
      blueprint = data$blueprint
    )
  class(svm_model) <- c("baritsu_svm", class(svm_model))
  svm_model
}

#' @rdname predict.baritsu
#' @export
predict.baritsu_svm <- function(
  object, newdata,
  type = c("both", "class", "prob"),
  ...
) {
  if (!is_exptr_of(object, "LinearSVMModel")) {
    rlang::abort("stored model must be a 'LinearSVMModel'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  check_predictors(newdata$predictors)
  pred <-
    mlpack::linear_svm(
      input_model = object$fit,
      test = newdata$predictors
    )
  pred_to_tbl(
    pred,
    labs = levels(object$blueprint$ptypes$outcomes[[1]]),
    type = type
  )
}
