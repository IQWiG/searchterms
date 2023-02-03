test_that("prepare_MeSH_table() creates a named list", {
  testset_ref <- readRDS(test_path("fixtures", "testset_ref.RDS"))
  testset_MeSH <- prepare_MeSH_table(testset_ref)
  expect_named(testset_MeSH, c("all_keywords", "MeSH_with_qualifier"))
})

#add test for references directly imported from PubMed
