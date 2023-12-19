#' Decision trees
#'
#' A wrapper around [mlpack::decision_tree()] that allows passing a formula.
#'
#' @details
#' To prevent masking of [parsnip::decision_tree()],
#' this function is named `decision_trees` (plural form!)
#'
#' @seealso [mlpack::decision_tree()] [predict.baritsu_dt()]
#'
#' @param formula A formula.
#' Alternatively, a recipe object can be passed for this argument.
#' If a recipe is passed, \code{data} is ignored.
#' @param data A data.frame.
#' @param tree_depth Maximum depth of the tree.
#' @param min_n Minimum number of data points in a leaf.
#' @param minimum_gain_split Minimum gain required to split an internal node.
#' @param weights Weights for each observation.
#' @param x Design matrix.
#' @param y Response matrix.
#' @returns An object of class \code{baritsu_dt}.
#' @export
decision_trees <- function(
  formula = NULL,
  data = NULL,
  tree_depth = 0, # maximum_depth
  min_n = 20, # minimum_leaf_size
  minimum_gain_split = 1e-7,
  weights = NULL,
  x = NULL,
  y = NULL
) {
  data <- mold(formula, data, x, y)
  check_predictors(data$predictors)
  check_outcomes(data$outcomes)

  if (is.null(weights)) {
    weights <- tibble::tibble(
      case_wts = rep(1, nrow(data$predictors))
    )
  }
  dt_model <-
    mlpack::decision_tree(
      training = data$predictors,
      labels = data$outcomes,
      maximum_depth = tree_depth,
      minimum_leaf_size = min_n,
      minimum_gain_split = minimum_gain_split,
      weights = weights
    )
  dt_model <-
    list(
      fit = dt_model$output_model,
      blueprint = data$blueprint
    )
  class(dt_model) <- c("baritsu_dt", class(dt_model))
  dt_model
}

#' @rdname predict.baritsu
#' @export
predict.baritsu_dt <- function(
  object, newdata,
  type = c("both", "class", "prob"),
  ...
) {
  type <- rlang::arg_match(type, c("both", "class", "prob"))
  if (!is_exptr_of(object, "DecisionTreeModel")) {
    rlang::abort("stored model must be a 'DecisionTreeModel'.")
  }
  newdata <-
    hardhat::forge(
      newdata,
      blueprint = object$blueprint
    )
  check_predictors(newdata$predictors)
  pred <-
    mlpack::decision_tree(
      input_model = object$fit,
      test = newdata$predictors
    )
  pred_to_tbl(
    pred,
    labs = levels(object$blueprint$ptypes$outcomes[[1]]),
    type = type
  )
}
