penguins <- modeldata::penguins
data_split <- rsample::initial_split(penguins, strata = "species")
penguins_train <- rsample::training(data_split)
penguins_test <- rsample::testing(data_split)
rec <-
  recipes::recipe(
    species ~ .,
    data = penguins_train
  ) |>
  recipes::step_impute_median(recipes::all_numeric_predictors()) |>
  recipes::step_impute_mode(recipes::all_nominal_predictors())

test_that("decition_trees fails when data contains NAs", {
  expect_error(
    decision_trees(
      species ~ .,
      data = penguins
    )
  )
})

test_that("decision_trees fails or warns when response is invalid", {
  testdat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = penguins_test)
  expect_error(
    decision_trees(
      species ~ .,
      data = testdat |>
        dplyr::mutate(species = as.numeric(species))
    )
  )
  expect_warning(
    decision_trees(
      species + sex ~ .,
      data = testdat
    )
  )
})

test_that("decision_trees works for recipe", {
  out <- decision_trees(
    rec,
    data = NULL
  )
  expect_s3_class(out, "baritsu_dt")
  testdat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = penguins_test)
  pred <- predict(out, testdat)
  expect_s3_class(pred, "tbl_df")
  expect_equal(colnames(pred), c(".pred_class", ".probabilities"))
})

test_that("decision_trees works for x-y interface", {
  dat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = NULL)
  out <- decision_trees(
    x = dat[, 3:6],
    y = dat[, "species"]
  )
  expect_s3_class(out, "baritsu_dt")
})

test_that("decision_trees works for formula interface", {
  dat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = NULL)
  out <- decision_trees(
    species ~ .,
    data = dat
  )
  expect_s3_class(out, "baritsu_dt")
})

test_that("decision_trees works with tidymodels", {
  spec <- parsnip::decision_tree(
    tree_depth = 0,
    min_n = 5
  ) |>
    parsnip::set_engine("baritsu") |>
    parsnip::set_mode("classification")
  dat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = NULL)
  testdat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = penguins_test)

  out <- spec |>
    parsnip::fit(species ~ ., data = dat)
  expect_true(inherits(out, "model_fit"))
  expect_s3_class(
    predict(workflows::extract_fit_engine(out), testdat, type = "class"),
    "tbl_df"
  )
  expect_s3_class(
    predict(workflows::extract_fit_engine(out), testdat, type = "prob"),
    "tbl_df"
  )
  expect_s3_class(
    parsnip::augment(out, testdat),
    "tbl_df"
  )

  wf_fit <- workflows::workflow() |>
    workflows::add_recipe(rec) |>
    workflows::add_model(spec) |>
    fit(penguins_train)
  expect_s3_class(wf_fit, "workflow")
  out <- predict(wf_fit, penguins_test)
  expect_s3_class(out, "tbl_df")

  spec <- parsnip::decision_tree(
    tree_depth = 0,
    min_n = 50
  ) |>
    parsnip::set_engine("baritsu") |>
    parsnip::set_mode("classification")
  wf_fit <- workflows::workflow() |>
    workflows::add_recipe(rec) |>
    workflows::add_model(spec) |>
    fit(penguins_train)
  expect_true(!identical(out, predict(wf_fit, penguins_test)))
})
