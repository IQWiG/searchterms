test_that("population set was imported successfully", {
  path <- test_path(pattern = "fixtures", "test_pop.txt")
  expect_silent(read_bibliography(path, return_df = F))
})

test_that("testset was imported successfully", {
  path <- test_path(pattern = "fixtures/ris", "A22-10.txt")
  expect_silent(read_bibliography(path, return_df = F))
})
