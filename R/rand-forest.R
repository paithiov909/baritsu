#' Random forest
#'
#' A wrapper around [mlpack::random_forest()] that enables formula interface.
#'
#' @seealso [mlpack::random_forest()]
#'
#' @param formula A formula.
#' Alternatively, a recipe object can be passed for this argument.
#' If a recipe is passed, \code{data} is ignored.
#' @param data A data.frame.
#' @param maximum_depth Maximum depth of the tree.
#' @param minimum_gain_split Minimum gain required to split an internal node.
#' @param min_n Minimum number of data points in a leaf.
#' @param trees Number of trees.
#' @param mtry Subspace dimension.
#' @param seed Random seed.
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_rf}.
#' @export
random_forest <- function(
  formula = NULL,
  data = NULL,
  maximum_depth = 0,
  minimum_gain_split = 0,
  min_n = 1, # minimum_leaf_size
  trees = 10, # num_trees
  mtry = 0, # subspace_dim
  seed = 0,
  x = NULL,
  y = NULL
) {
  data <- mold(formula, data, x, y)
  if (anyNA(data$predictors)) {
    rlang::abort("predictors cannot contain NAs.")
  }
  if (!is.factor(data$outcomes[[1]])) {
    rlang::abort("outcomes must be a factor.")
  }

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
resume.baritsu_rf <- function(object) {
  object # TODO: deal with `warm_start`
}

#' Predict for rand_forest
#' @export
predict.baritsu_rf <- function(object, newdata, type = c("both", "class", "prob")) {
  type <- rlang::arg_match(type, c("both", "class", "prob"))
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  pred <-
    mlpack::random_forest(
      input_model = object$fit,
      test = newdata$predictors
    )
  out <- pred_to_tbl(pred, levels(object$blueprint$ptypes$outcomes[[1]]))

  if (!type %in% c("class", "prob")) {
    return(out)
  }
  if (type == "prob") {
    out[["probabilities"]]
  } else {
    out[".pred_class"]
  }
}
