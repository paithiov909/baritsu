test_that("linear_reg works", {
  ames <- modeldata::ames |>
    dplyr::select(Sale_Price, Lot_Area, Total_Bsmt_SF, First_Flr_SF)

  data_split <- rsample::initial_split(ames)
  ames_train <- rsample::training(data_split)
  ames_test <- rsample::testing(data_split)

  rec <-
    recipes::recipe(
      Sale_Price ~ .,
      data = ames_train
    ) |>
    recipes::step_impute_median(recipes::all_numeric_predictors()) |>
    recipes::step_scale(recipes::all_numeric_predictors()) |>
    recipes::step_center(recipes::all_numeric_predictors())

  out <-
    linear_regression(
      Sale_Price ~ .,
      data = ames_train,
    )
  expect_s3_class(out, "baritsu_lr")
  expect_equal(attr(out$fit, "type"), "LinearRegression")

  out <-
    linear_regression(
      Sale_Price ~ .,
      data = ames_train,
      mixture = 0.5
    )
  expect_s3_class(out, "baritsu_lr")
  expect_equal(attr(out$fit, "type"), "LARS")
})


test_that("multiplication works", {
  ames <- modeldata::ames |>
    dplyr::select(Sale_Price, Lot_Area, Total_Bsmt_SF, First_Flr_SF)

  data_split <- rsample::initial_split(ames)
  ames_train <- rsample::training(data_split)
  ames_test <- rsample::testing(data_split)

  rec <-
    recipes::recipe(
      Sale_Price ~ .,
      data = ames_train
    ) |>
    recipes::step_impute_median(recipes::all_numeric_predictors()) |>
    recipes::step_scale(recipes::all_numeric_predictors()) |>
    recipes::step_center(recipes::all_numeric_predictors())

  spec <- parsnip::linear_reg(
    mixture = 0.5
  ) |>
    parsnip::set_engine("baritsu") |>
    parsnip::set_mode("regression")

  out <- spec |>
    parsnip::fit(
      log(Sale_Price) ~ .,
      data = recipes::prep(rec) |> recipes::bake(new_data = NULL)
    ) |>
    parsnip::extract_fit_engine()
  expect_s3_class(out, "baritsu_lr")
  expect_equal(attr(out$fit, "type"), "LARS")

  wf <- workflows::workflow() |>
    workflows::add_recipe(rec) |>
    workflows::add_model(spec)

  lr_fit <- fit(wf, ames_train)
  expect_s3_class(out, "baritsu_lr")
  expect_equal(attr(out$fit, "type"), "LARS")

  # returns numeric column only.
  expect_s3_class(
    predict(lr_fit, ames_test),
    "tbl_df"
  )
})
