test_that("random_forest fails", {
  penguins <- modeldata::penguins
  expect_error(
    random_forest(
      species ~ .,
      data = penguins
    )
  )
  expect_error(
    random_forest(
      species ~ .,
      data = penguins |>
        dplyr::mutate(species = as.numeric(species))
    )
  )
})

test_that("random_forest works", {
  penguins <- modeldata::penguins
  penguins <- stats::na.omit(penguins) # TODO: add dependency on stats or tidyr?

  data_split <- rsample::initial_split(penguins, strata = "species")
  penguins_train <- rsample::training(data_split)
  penguins_test <- rsample::testing(data_split)

  rec <-
    recipes::recipe(
      species ~ .,
      data = penguins_train
    )
  out <- random_forest(
    rec,
    data = penguins_train
  )
  expect_s3_class(out, "baritsu_rf")

  out <- random_forest(
    x = penguins_train[, 3:6],
    y = penguins_train[, "species"]
  )
  expect_s3_class(out, "baritsu_rf")


  out <- random_forest(
    species ~ .,
    data = penguins_train
  )
  expect_s3_class(out, "baritsu_rf")

  pred <- predict(out, penguins_test)
  expect_s3_class(pred, "tbl_df")
})

test_that("rand_forest parsnip engine works", {
  penguins <- modeldata::penguins

  data_split <- rsample::initial_split(penguins, strata = "species")
  penguins_train <- rsample::training(data_split)
  penguins_test <- rsample::testing(data_split)

  rec <-
    recipes::recipe(
      species ~ .,
      data = penguins_train
    ) |>
    recipes::step_impute_mode(recipes::all_nominal_predictors()) |>
    recipes::step_impute_median(recipes::all_numeric_predictors())

  spec <- parsnip::rand_forest(
    mtry = 3,
    trees = 10,
    min_n = 5
  ) |>
    parsnip::set_engine("baritsu") |>
    parsnip::set_mode("classification")

  out <- spec |>
    parsnip::fit(species ~ ., data = recipes::prep(rec) |> recipes::bake(new_data = NULL))

  expect_true(
    inherits(out, "model_fit"),
  )
  expect_s3_class(
    predict(workflows::extract_fit_engine(out), na.omit(penguins_test), type = "prob"),
    "tbl_df"
  )
  expect_s3_class(
    parsnip::augment(out, na.omit(penguins_test)),
    "tbl_df"
  )

  wf <- workflows::workflow() |>
    workflows::add_recipe(rec) |>
    workflows::add_model(spec)

  rf_fit <- fit(wf, penguins_train)
  expect_s3_class(rf_fit, "workflow")

  expect_s3_class(
    predict(rf_fit, penguins_test),
    "tbl_df"
  )
})
