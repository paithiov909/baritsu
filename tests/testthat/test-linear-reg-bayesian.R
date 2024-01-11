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

test_that("linear_reg_bayesian works for x-y interface", {
  out <-
    linear_regression_bayesian(
      x = dplyr::select(ames_train, !"Sale_Price"),
      y = dplyr::select(ames_train,  "Sale_Price"),
      center = TRUE,
      scale = TRUE
    )
  expect_s3_class(out, "baritsu_blr")
})

test_that("linear_reg_bayesian works for formula interface", {
  out <-
    linear_regression_bayesian(
      log(Sale_Price) ~ .,
      data = ames_train,
      center = TRUE,
      scale = TRUE
    )
  expect_s3_class(out, "baritsu_blr")
  pred <- predict(out, ames_test)
  expect_equal(colnames(pred), c(".pred", ".stds"))
})
