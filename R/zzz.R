#' @noRd
.onLoad <- function(libname, pkgname) {
  register_decision_tree_baritsu()
  register_linear_reg_baritsu()
  register_rand_forest_baritsu()
}
