# testset.rds
testset <- create_testset(test_path("fixtures/ris", "V21-06B.txt"))
saveRDS(testset, "tests/testthat/fixtures/testset.rds")

#testset_ref.rds
testset_ref <- read_bibliography(test_path("fixtures/ris", "S19-02.txt"), return_df = F)
saveRDS(testset_ref, "tests/testthat/fixtures/testset_ref.rds")

#testset_MeSH_qualifier_lists.rds
testset_MeSH <- create_testset(test_path("fixtures/ris", "I26.txt"))
testset_MeSH <- create_MeSH_qualifier_lists(testset)
saveRDS(testset_MeSH, "tests/testthat/fixtures/testset_MeSH_qualifier_lists.rds")
