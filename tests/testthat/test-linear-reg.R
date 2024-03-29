ames <- modeldata::ames |>
  dplyr::slice_sample(n = 100) |>
  dplyr::select(Sale_Price, Lot_Area, Total_Bsmt_SF, First_Flr_SF)
data_split <- rsample::initial_split(ames)
ames_train <- rsample::training(data_split)
ames_test <- rsample::testing(data_split)
rec <-
  recipes::recipe(
    Sale_Price ~ .,
    data = ames_train
  )

test_that("linear_reg warns when lambda is not within [0, 1]", {
  expect_warning(
    linear_regression(
      Sale_Price ~ .,
      data = ames_train,
      lambda1 = -1
    )
  )
  expect_warning(
    linear_regression(
      Sale_Price ~ .,
      data = ames_train,
      lambda2 = Inf
    )
  )
})

test_that("linear_reg works for x-y interface", {
  out <-
    linear_regression(
      x = dplyr::select(ames_train, !"Sale_Price"),
      y = dplyr::select(ames_train,  "Sale_Price"),
      lambda1 = 0.0,
      lambda2 = 0.0
    )
  expect_s3_class(out, "baritsu_lr")
  out <-
    linear_regression(
      x = dplyr::select(ames_train, !"Sale_Price"),
      y = dplyr::select(ames_train,  "Sale_Price"),
      lambda1 = 0.5,
      lambda2 = 0.0
    )
  expect_s3_class(out, "baritsu_lr")
})

test_that("linear_reg works for formula interface", {
  out <-
    linear_regression(
      log(Sale_Price) ~ .,
      data = ames_train,
      lambda1 = 0.0,
      lambda2 = 0.0
    )
  expect_s3_class(out, "baritsu_lr")
  out <-
    linear_regression(
      log(Sale_Price) ~ .,
      data = ames_train,
      lambda1 = 0.5,
      lambda2 = 0.0
    )
  expect_s3_class(out, "baritsu_lr")
})

test_that("lars works", {
  spec <- lars(
    penalty_L1 = 0.0,
    penalty_L2 = 0.5
  ) |>
    parsnip::set_engine("baritsu") |>
    parsnip::set_mode("regression")
  dat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = NULL)
  testdat <- rec |>
    recipes::prep() |>
    recipes::bake(new_data = ames_test)

  out <- spec |>
    parsnip::fit(
      Sale_Price ~ .,
      data = dat
    )
  expect_true(inherits(out, "model_fit"))
  expect_s3_class(
    predict(workflows::extract_fit_engine(out), testdat),
    "tbl_df"
  )
  expect_s3_class(
    parsnip::augment(out, testdat),
    "tbl_df"
  )

  wf_fit <- workflows::workflow() |>
    workflows::add_recipe(rec) |>
    workflows::add_model(spec) |>
    fit(ames_train)
  expect_s3_class(wf_fit, "workflow")
  expect_equal(
    colnames(predict(wf_fit, ames_test)),
    ".pred"
  )
})
