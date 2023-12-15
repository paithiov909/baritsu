# TODO: Document me!

#' @export
linear_regression <- function(
  formula = NULL,
  data = NULL,
  mixture = 0,
  no_intercept = FALSE,
  no_normalize = FALSE,
  use_cholesky = FALSE,
  x = NULL,
  y = NULL
) {
  data <- mold(formula, data, x, y)

  if (anyNA(data$predictors)) {
    rlang::abort("predictors cannot contain NAs.")
  }
  if (!all(mixture >= 0, mixture <= 1)) {
    rlang::warn("mixture should be a number between 0 and 1; set to 0.")
    mixture <- 0
  }
  # mixture=0 should be a ridge regression,
  # so, when mixture=0, will be lambda1=0 and lambda2>0
  lambda1 <- as.double(mixture) # for ridge
  lambda2 <- as.double(1.0 - lambda1) # for lasso

  if (lambda1 == 0.0) {
    lr_model <-
      mlpack::linear_regression(
        training = data$predictors,
        training_responses = data$outcomes,
        lambda = lambda1
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

#' Predict for linear_reg
#' @export
predict.baritsu_lr <- function(object, newdata) {
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  # check model type to prevent passing an invalid external pointer
  # to mlpack call.
  model_type <- attr(object$fit, "type")
  if (model_type == "LinearRegression") {
    pred <-
      mlpack::linear_regression(
        input_model = object$fit,
        test = newdata$predictors
      )
  } else if (model_type == "LARS") {
    pred <-
      mlpack::lars(
        input_model = object$fit,
        test = newdata$predictors
      )
  } else {
    rlang::abort("stored model must be 'LinearRegression' or 'LARS'.")
  }
  tibble::tibble(
    .pred = as.double(pred[["output_predictions"]]),
  )
}
