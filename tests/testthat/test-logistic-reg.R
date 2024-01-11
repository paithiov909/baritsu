penguins <- modeldata::penguins |>
  stats::na.omit()
data_split <- rsample::initial_split(penguins, strata = "sex")
penguins_train <- rsample::training(data_split)
penguins_test <- rsample::testing(data_split)
rec <-
  recipes::recipe(
    sex ~ bill_length_mm + bill_depth_mm + flipper_length_mm + body_mass_g,
    data = penguins_train
  ) |>
  recipes::step_impute_median(recipes::all_numeric_predictors())

test_that("logistic_reg fails when data contains NAs", {
  expect_error(
    linear_svm(
      sex ~ .,
      data = modeldata::penguins
    )
  )
})

test_that("logistic_reg fails when response is invalid", {
  testdat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = penguins_test)
  expect_error(
    linear_svm(
      sex ~ .,
      data = testdat |>
        dplyr::mutate(sex = as.numeric(sex))
    )
  )
})

test_that("logistic_reg works for x-y interface", {
  dat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = NULL)
  out <- logistic_regression(
    x = dplyr::select(dat, !"sex"),
    y = dplyr::select(dat,  "sex")
  )
  expect_s3_class(out, "baritsu_lgr")
})

test_that("logistic_reg works for formula interface", {
  dat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = NULL)
  out <- logistic_regression(
    sex ~ .,
    data = dat
  )
  expect_s3_class(out, "baritsu_lgr")
})

test_that("logistic_reg works with tidymodels", {
  spec <- parsnip::logistic_reg(
    penalty = 0.1
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
    parsnip::fit(sex ~ ., data = dat)
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
