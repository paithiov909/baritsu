#' Hoeffding trees
#'
#' A wrapper around [mlpack::hoeffding_tree()] that allows passing a formula.
#'
#' @seealso [mlpack::hoeffding_tree()] [predict.baritsu_ht()]
#'
#' @param formula A formula.
#' @param data A data.frame.
#' @param confidence_factor Confidence before splitting (between 0 and 1).
#' @param sample_size Number of passes to take over the dataset.
#' @param max_samples Maximum number of samples before splitting.
#' @param min_samples Minimum number of samples before splitting.
#' @param info_gain Logical.
#' If set, information gain is used
#' instead of Gini impurity for calculating Hoeffding bounds.
#' @param batch_mode Logical.
#' If true, samples will be considered in batch instead of as a stream.
#' This generally results in better trees
#' but at the cost of memory usage and runtime.
#' @param numeric_split_strategy
#' The splitting strategy to use for numeric features.
#' @param num_breaks If the "domingos" split strategy is used,
#' this specifies the number of bins for each numeric split.
#' @param observations_before_binning
#' If the "domingos" split strategy is used,
#' this specifies the number of samples observed before binning is performed.
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_ht}.
#' @export
hoeffding_trees <- function(
  formula = NULL,
  data = NULL,
  confidence_factor = 0.95, # confidence
  sample_size = 10, # passes
  max_samples = 5000,
  min_samples = 100,
  info_gain = FALSE,
  batch_mode = FALSE,
  numeric_split_strategy = c("binary", "domingos"),
  num_breaks = 10, # bins
  observations_before_binning = 100,
  x = NULL,
  y = NULL
) {
  numeric_split_strategy <-
    rlang::arg_match(numeric_split_strategy, c("binary", "domingos"))
  if (batch_mode && sample_size < 2) {
    rlang::warn(
      "`sample_size` must be at least 2 when `batch_mode` is TRUE. set to 2."
    )
    sample_size <- 2
  }

  data <- mold(formula, data, x, y)
  check_outcomes(data$outcomes)
  check_predictors(data$predictors)

  ht_model <-
    mlpack::hoeffding_tree(
      training = data$predictors,
      labels = data$outcomes,
      confidence = confidence_factor,
      passes = sample_size,
      max_samples = max_samples,
      min_samples = min_samples,
      info_gain = info_gain,
      batch_mode = batch_mode,
      numeric_split_strategy = numeric_split_strategy,
      bins = num_breaks,
      observations_before_binning = observations_before_binning
    )
  ht_model <-
    list(
      fit = ht_model$output_model,
      blueprint = data$blueprint
    )
  class(ht_model) <- c("baritsu_ht", class(ht_model))
  ht_model
}

#' @rdname predict.baritsu
#' @export
predict.baritsu_ht <- function(object, newdata, ...) {
  if (!is_exptr_of(object, "HoeffdingTreeModel")) {
    rlang::abort("stored model must be a 'HoeffdingTreeModel'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  check_predictors(newdata$predictors)
  pred <-
    mlpack::hoeffding_tree(
      input_model = object$fit,
      test = newdata$predictors
    )

  labs <- levels(object$blueprint$ptypes$outcomes[[1]])
  tibble::tibble(
    .pred_class = factor(
      pred$predictions[, 1],
      levels = seq_along(labs),
      labels = labs
    ),
    .probabilities = pred$probabilities[, 1]
  )
}
