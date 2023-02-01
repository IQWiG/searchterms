test_that("create PMID as character vectors if validation_set = FALSE", {
  expected_risfile <- readRDS(test_path("fixtures","testset_ref.rds"))
  expect_vector(return_pmids(expected_risfile)$testset, ptype = character(), size = length(expected_risfile))
})

