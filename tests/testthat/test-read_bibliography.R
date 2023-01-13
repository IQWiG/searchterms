test_that("population set was imported successfully", {
  path <- testthat::test_path(pattern = "fixtures", "test_pop.txt")
  expect_silent(read_bibliography(path, return_df = F))
})
