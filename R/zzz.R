#' @noRd
.onLoad <- function(libname, pkgname) {
  register_boost_tree_baritsu()
  register_decision_tree_baritsu()
  register_hoeffding_tree_baritsu()
  register_lars_baritsu()
  register_logistic_reg_baritsu()
  register_mlp_baritsu()
  register_multinom_reg_baritsu()
  register_naive_Bayes_baritsu()
  register_rand_forest_baritsu()
  register_svm_linear_baritsu()
}
