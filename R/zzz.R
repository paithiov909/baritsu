#' @noRd
.onLoad <- function(libname, pkgname) {
  register_decision_tree_baritsu()
  register_linear_reg_baritsu()
  register_mlp_baritsu()
  register_multinom_reg_baritsu()
  register_naive_Bayes_baritsu()
  register_rand_forest_baritsu()
}

# TODO: check translated models out of specs
# TODO: readme, badge
# TODO: pkgdown
# TODO: check workflow
