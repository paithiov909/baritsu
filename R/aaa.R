#' @import parsnip
#' @importFrom utils globalVariables
#' @importFrom generics refit
#' @keywords internal
"_PACKAGE"

utils::globalVariables(c("object", "new_data"))

#' Check if data contains only finite values
#'
#' When factors are passed to `is.finite`,
#' they are implicitly treated as integers.
#' So, this function does not check for factors.
#' @noRd
all_finite <- function(data) {
  all(unlist(lapply(data, function(col) all(is.finite(col)))))
}

#' Stop if predictors are not finite values
#' @noRd
check_predictors <- function(data) {
  if (is.null(data) || !all_finite(data)) {
    rlang::abort("predictors can contain finite numerics only.")
  }
  return(invisible(FALSE))
}

#' Check if data contains only factors
#'
#' Labels must be 1-origin indexed for mlpack.
#' Factors are coerced to integers, starting from 1.
#' @noRd
all_factors <- function(data) {
  all(unlist(lapply(data, is.factor)))
}

#' Stop if outcome is not a factor
#' @noRd
check_outcomes <- function(outcomes) {
  if (ncol(outcomes) > 1) {
    rlang::warn(
      "outcomes consist of more than one column. verify LHS of formula."
    )
  }
  if (!all_factors(outcomes)) {
    rlang::abort("outcomes must be factors.")
  }
  return(invisible(FALSE))
}

#' Check type of a mlpack model
#'
#' Checks model type to prevent passing an invalid external pointer
#' to mlpack call.
#' @noRd
is_exptr_of <- function(object, type) {
  if (is.null(object$fit)) {
    return(FALSE)
  }
  model_type <- attr(object$fit, "type")
  ifelse(
    model_type == type,
    TRUE,
    FALSE
  )
}

mold <- function(formula, data, x, y) {
  if (!is.null(formula)) {
    if (inherits(formula, "recipe")) {
      data <- formula |>
        recipes::prep() |>
        recipes::bake(new_data = NULL)
    }
    hardhat::mold(formula, data)
  } else if (!is.null(x) && !is.null(y)) {
    hardhat::mold(x, y)
  } else {
    rlang::abort("either 'formula' or 'x' and 'y' must be specified.")
  }
}

pred_to_tbl <- function(pred, labs, type) {
  out <-
    tibble::tibble(
      .pred_class = factor(
        pred$predictions[, 1],
        levels = labs,
        labels = labs
      ),
      .probabilities = tibble::as_tibble(
        pred$probabilities,
        .name_repair = ~ paste0(".pred_", labs)
      )
    )
  switch(type,
    both = out,
    class = out[".pred_class"],
    prob = out[[".probabilities"]] # needs unnest
  )
}
