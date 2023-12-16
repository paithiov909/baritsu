#' @importFrom generics refit
#' @keywords internal
"_PACKAGE"

utils::globalVariables(c("object", "new_data"))

#' Detect any infinite values
#' @noRd
any_inf <- function(data) {
  any(apply(data, 2, function(col) sum(is.infinite(col)) > 0))
}

#' Stop if data contains any NAs or infinite values
#' @noRd
stop_if_any_na <- function(data) {
  if (is.null(data) || anyNA(data) || any_inf(data)) {
    rlang::abort("predictors cannot contain NAs or infinite values.")
  }
  return(invisible(FALSE))
}

#' Check outcomes
#' @noRd
check_outcomes <- function(outcomes) {
  if (ncol(outcomes) > 1) {
    rlang::warn(
      "outcomes consist of more than one column. verify LHS of formula."
    )
  }
  if (!is.factor(outcomes[[1]])) {
    # labels are coerced to integers for classification
    rlang::abort("outcomes must be a factor.")
  }
  return(invisible(FALSE))
}

#' Check type of a mlpack model
#'
#' Checks model type to prevent passing an invalid external pointer
#' to mlpack call.
#' @noRd
check_exptr_type <- function(object, type) {
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

mold <- function(
  formula, data, x, y
) {
  if (!is.null(formula)) {
    if (inherits(formula, "recipe")) {
      data <- formula |>
        recipes::prep() |>
        recipes::bake(new_data = NULL)
    }
    hardhat::mold(
      formula,
      data = data
    )
  } else if (!is.null(x) && !is.null(y)) {
    hardhat::mold(
      x, y
    )
  } else {
    missing_arg()
  }
}

pred_to_tbl <- function(pred, labs, type) {
  out <-
    tibble::tibble(
      .pred_class = factor(pred$predictions[, 1], labels = labs),
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
