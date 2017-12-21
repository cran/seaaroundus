context("regionmap")

test_that("regionmap works", {
  skip_on_cran()

  tt <- suppressWarnings(regionmap(region = "eez", id = 76))

  expect_is(tt, "gg")
  expect_is(tt$layers, "list")
  expect_equal(tt$labels$x, "long")
  expect_equal(tt$labels$y, "lat")
})

test_that("regionmap fails well", {
  skip_on_cran()

  expect_error(regionmap(), "argument \"region\" is missing")
  expect_error(regionmap(id = 76), "argument \"region\" is missing")
  expect_error(regionmap(45), "Open failed")
})
