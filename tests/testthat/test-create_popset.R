test_that("population set was created successfully", {
  path <- testthat::test_path(pattern = "fixtures", "test_pop.txt")
  expect_silent(create_popset(path))
})
