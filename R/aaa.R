utils::globalVariables(c("object", "new_data"))

#' @noRd
mold <- function(formula = NULL, data = NULL, x = NULL, y = NULL) {
  if (!is.null(formula)) {
    data <- if (inherits(formula, "recipe")) formula$template else data
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

#' @noRd
pred_to_tbl <- function(pred, labs) {
  tibble::tibble(
    .pred_class = factor(pred$predictions[, 1], labels = labs),
    probabilities = tibble::as_tibble(
      pred$probabilities,
      .name_repair = ~ paste0(".pred_", labs)
    )
  )
}
