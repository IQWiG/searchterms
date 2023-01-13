test_that("create PMID as character vectors if validationset_ref = FALSE", {
  expected_risfile <- readRDS(test_path("fixtures","expected_risfile.rds"))
  expect_vector(return_pmids(expected_risfile)$testset, ptype = character(), size = length(expected_risfile))
})

