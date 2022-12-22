test_that("population set was created successfully", {
  path <- testthat::test_path(pattern = "fixture", "test_pop.txt")
  expect_silent(create_popset(path))
})
