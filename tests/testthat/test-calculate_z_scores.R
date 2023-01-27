test_that("calculate_z_scores(), Z-scores sucessfully calculated", {
  testset <- readRDS(test_path("fixtures", "testset_MeSH_qualifier_lists.rds"))
  qualifier_table <- calculate_z_scores(testset[["MeSH.Terms"]][["qualifier"]],
                                        popset[["qualifier"]],
                                        key_popset = "qualifier")
  expect_vector(as.list(qualifier_table), size = 13)
})
