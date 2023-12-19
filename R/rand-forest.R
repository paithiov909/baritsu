#' Random forests
#'
#' A wrapper around [mlpack::random_forest()] that allows passing a formula.
#'
#' @seealso [mlpack::random_forest()] [predict.baritsu_rf()]
#'
#' @param formula A formula.
#' Alternatively, a recipe object can be passed for this argument.
#' If a recipe is passed, \code{data} is ignored.
#' @param data A data.frame.
#' @param mtry Subspace dimension.
#' If 0, autoselects the square root of data dimensionality.
#' @param trees Number of trees.
#' @param min_n Minimum number of data points in a leaf.
#' @param maximum_depth Maximum depth of the tree.
#' @param minimum_gain_split Minimum gain required to split an internal node.
#' @param seed Random seed. If 0, `std::time(NULL)` is used internally.
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_rf}.
#' @export
random_forest <- function(
  formula = NULL,
  data = NULL,
  mtry = 0, # subspace_dim
  trees = 10, # num_trees
  min_n = 1, # minimum_leaf_size
  maximum_depth = 0,
  minimum_gain_split = 0,
  seed = 0,
  x = NULL,
  y = NULL
) {
  data <- mold(formula, data, x, y)
  check_predictors(data$predictors)
  check_outcomes(data$outcomes)

  rf_model <-
    mlpack::random_forest(
      training = data$predictors,
      labels = data$outcomes,
      maximum_depth = maximum_depth,
      minimum_gain_split = minimum_gain_split,
      minimum_leaf_size = min_n,
      num_trees = trees,
      subspace_dim = mtry,
      seed = seed
    )
  rf_model <-
    list(
      fit = rf_model$output_model,
      blueprint = data$blueprint
    )
  class(rf_model) <- c("baritsu_rf", class(rf_model))
  rf_model
}

#' @export
refit.baritsu_rf <- function(object, ...) {
  object # TODO: deal with `warm_start`
}

#' @rdname predict.baritsu
#' @export
predict.baritsu_rf <- function(
  object, newdata,
  type = c("both", "class", "prob"),
  ...
) {
  type <- rlang::arg_match(type, c("both", "class", "prob"))
  if (!is_exptr_of(object, "RandomForestModel")) {
    rlang::abort("stored model must be a 'RandomForestModel'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  check_predictors(newdata$predictors)
  pred <-
    mlpack::random_forest(
      input_model = object$fit,
      test = newdata$predictors
    )
  pred_to_tbl(
    pred,
    labs = levels(object$blueprint$ptypes$outcomes[[1]]),
    type = type
  )
}
