#' Prediction using mlpack via baritsu
#'
#' Predicts with new data using a stored mlpack model.
#'
#' @param object An object out of baritsu function.
#' @param newdata A data.frame.
#' @param type Type of prediction. One of "both", "class", or "prob".
#' @param ... Not used.
#' @returns A tibble that contains the predictions and/or probabilities
#' (and also the standard deviations of the predictive distribution
#' only for \code{predict.baritsu_blr}).
#' @name predict.baritsu
#' @keywords internal
NULL
