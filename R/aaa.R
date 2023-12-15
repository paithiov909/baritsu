utils::globalVariables(c("object", "new_data"))

#' Stop if data contains any NAs
#' @noRd
stop_if_any_na <- function(data) {
  if (is.null(data) || anyNA(data)) {
    rlang::abort("predictors cannot contain NAs.")
  }
  return(invisible(FALSE))
}

#' Check type of a mlpack model
#'
#' Checks model type to prevent passing an invalid external pointer
#' to mlpack call.
#'
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

mold <- function(formula = NULL, data = NULL, x = NULL, y = NULL) {
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
  } else {
    hardhat::mold(
      x, y
    )
  }
}

pred_to_tbl <- function(pred, labs) {
  tibble::tibble(
    .pred_class = factor(pred$predictions[, 1], labels = labs),
    probabilities = tibble::as_tibble(
      pred$probabilities,
      .name_repair = ~ paste0(".pred_", labs)
    )
  )
}
