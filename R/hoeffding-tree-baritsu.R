#' Hoeffding trees via baritsu
#'
#' @description
#' `hoeffding_tree()` defines a Hoeffding tree model.
#'
#' @details
#' For this model, there is a single mode: classification
#'
#' ## Tuning Parameters
#'
#' This model has 2 tuning parameters:
#'
#' - `confidence_factor`: Confidence before splitting (type: double)
#' - `sample_size`: Number of passes to take over the dataset (type: int)
#'
#' @seealso [hoeffding_trees()]
#'
#' @param mode A single character string for the type of model.
#' The only possible value for this model is "classification".
#' @param engine A single character string specifying what computational engine
#' to use for fitting.
#' @param confidence_factor Confidence before splitting.
#' @param sample_size Number of passes to take over the dataset.
#' @rdname details_hoeffding_tree_baritsu
#' @aliases details_hoeffding_tree_baritsu
#' @export
#' @keywords internal
hoeffding_tree <- function(
  mode = "classification",
  engine = "baritsu",
  confidence_factor = NULL,
  sample_size = NULL
) {
  if (mode != "classification") {
    rlang::abort("`mode` should be 'classification'")
  }
  args <- list(
    confidence_factor = rlang::enquo(confidence_factor),
    sample_size = rlang::enquo(sample_size)
  )
  parsnip::new_model_spec(
    "hoeffding_tree",
    args = args,
    eng_args = NULL,
    mode = mode,
    user_specified_mode = !missing(mode),
    method = NULL,
    engine = engine,
    user_specified_engine = !missing(engine)
  )
}

#' @method update hoeffding_tree
#' @export
update.hoeffding_tree <- function(
  object,
  parameters = NULL,
  confidence_factor = NULL,
  sample_size = NULL,
  fresh = FALSE,
  ...
) {
  args <- list(
    confidence_factor = rlang::enquo(confidence_factor),
    sample_size = rlang::enquo(sample_size)
  )
  parsnip::update_spec(
    object = object,
    parameters = parameters,
    args_enquo_list = args,
    fresh = fresh,
    cls = "hoeffding_tree",
    ...
  )
}

#' @export
tunable.hoeffding_tree <- function(x, ...) {
  NextMethod()
}

register_hoeffding_tree_baritsu <- function() { # nolint
  parsnip::set_new_model("hoeffding_tree")
  parsnip::set_model_mode("hoeffding_tree", "classification")
  parsnip::set_model_engine("hoeffding_tree", "classification", "baritsu")
  parsnip::set_fit(
    model = "hoeffding_tree",
    eng = "baritsu",
    mode = "classification",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "x", "y"),
      func = c(pkg = "baritsu", fun = "hoeffding_trees"),
      defaults = list(batch_mode = FALSE)
    )
  )
  parsnip::set_model_arg(
    model = "hoeffding_tree",
    eng = "baritsu",
    parsnip = "confidence_factor",
    original = "confidence_factor",
    func = list(
      pkg = "dials", fun = "confidence_factor"
    ),
    has_submodel = FALSE
  )
  parsnip::set_model_arg(
    model = "hoeffding_tree",
    eng = "baritsu",
    parsnip = "sample_size",
    original = "sample_size",
    func = list(
      pkg = "dials", fun = "sample_size"
    ),
    has_submodel = FALSE
  )
  parsnip::set_encoding(
    model = "hoeffding_tree",
    eng = "baritsu",
    mode = "classification",
    options = list(
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )
  parsnip::set_pred(
    model = "hoeffding_tree",
    eng = "baritsu",
    mode = "classification",
    type = "class",
    value = list(
      pre = NULL,
      post = function(results, object) {
        results[, 1]
      },
      func = c(fun = "predict"),
      args =
        list(
          object = rlang::expr(object$fit), # nolint
          newdata = rlang::expr(new_data) # nolint
        )
    )
  )
}
