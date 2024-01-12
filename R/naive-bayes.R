#' Parametric naive Bayes classifier
#'
#' A wrapper around [mlpack::nbc()] that allows passing a formula.
#'
#' @seealso [mlpack::nbc()] [predict.baritsu_nbc()]
#'
#' @param formula A formula.
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
  check_outcomes(data$outcomes)
  check_predictors(data$predictors)

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

#' @rdname predict.baritsu
#' @export
predict.baritsu_nbc <- function(
  object, newdata,
  type = c("both", "class", "prob"),
  ...
) {
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
