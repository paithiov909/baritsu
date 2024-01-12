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

test_that("random_forest fails when data contains NAs", {
  expect_error(
    random_forest(
      species ~ .,
      data = penguins
    )
  )
})

test_that("random_forest fails when response is invalid", {
  testdat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = penguins_test)
  expect_error(
    random_forest(
      species ~ .,
      data = testdat |>
        dplyr::mutate(species = as.numeric(species))
    )
  )
  expect_error(
    random_forest(
      species + sex ~ .,
      data = testdat
    )
  )
})

test_that("random_forest works for x-y interface", {
  dat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = NULL)
  out <- random_forest(
    x = dplyr::select(dat, !"species"),
    y = dplyr::select(dat,  "species")
  )
  expect_s3_class(out, "baritsu_rf")
})

test_that("random_forest works for formula interface", {
  dat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = NULL)
  out <- random_forest(
    species ~ .,
    data = dat
  )
  expect_s3_class(out, "baritsu_rf")
})

test_that("rand_forest works with tidymodels", {
  spec <- parsnip::rand_forest(
    mtry = 3,
    trees = 10,
    min_n = 5
  ) |>
    parsnip::set_engine("baritsu") |>
    parsnip::set_mode("classification") |>
    parsnip::set_args(seed = 123)
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
})
