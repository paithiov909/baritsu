#' L2-regularized support vector machine
#'
#' A wrapper around [mlpack::linear_svm()] that allows passing a formula.
#'
#' @seealso [mlpack::linear_svm()] [predict.baritsu_svm()]
#'
#' @param formula A formula.
#' @param data A data.frame.
#' @param margin Margin of difference between correct class and other classes.
#' @param penalty L2-regularization constant.
#' @param epochs Maximum iterations for optimizer (0 indicates no limit).
#' This argument is passed as `max_iterations`, not as `epochs`
#' for [mlpack::linear_svm()].
#' @param no_intercept Logical; passed to [mlpack::linear_svm()].
#' @param tolerance Convergence tolerance for optimizer.
#' @param optimizer Optimizer to use for training ("lbfgs" or "psgd").
#' @param stop_iter Maximum number of full epochs over dataset for parallel SGD.
#' @param learn_rate Step size for parallel SGD optimizer.
#' in which data points are visited for parallel SGD.
#' @param shuffle Logical; if true, doesn't shuffle the order.
#' @param seed Random seed. If 0, `std::time(NULL)` is used internally.
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_svm}.
#' @export
linear_svm <- function(
  formula = NULL,
  data = NULL,
  margin = 1.0, # delta
  penalty = 0.0001, # lambda
  epochs = 1000, # max_iterations
  no_intercept = FALSE,
  tolerance = 1e-10,
  optimizer = c("lbfgs", "psgd"),
  stop_iter = 50, # epochs
  learn_rate = 0.01, # step_size
  shuffle = FALSE,
  seed = 0,
  x = NULL,
  y = NULL
) {
  optimizer <- rlang::arg_match(optimizer, c("lbfgs", "psgd"))
  data <- mold(formula, data, x, y)
  check_outcomes(data$outcomes)
  check_predictors(data$predictors)

  svm_model <-
    mlpack::linear_svm(
      training = data$predictors,
      labels = data$outcomes,
      delta = margin,
      lambda = penalty,
      max_iterations = epochs,
      no_intercept = no_intercept,
      tolerance = tolerance,
      optimizer = optimizer,
      epochs = stop_iter,
      shuffle = shuffle,
      step_size = learn_rate,
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
