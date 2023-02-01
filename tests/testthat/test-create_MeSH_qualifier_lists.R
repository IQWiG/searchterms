test_that("create_MeSH_qualifier_lists(),
          Creating normalized vocabulary lists (MeSH and qualifier) of the testset was sucessful", {
            testset <- readRDS(test_path("fixtures", "testset.rds"))
            testset <- create_MeSH_qualifier_lists(testset)
            expect_named(testset$MeSH.Terms, c("all_keywords", "MeSH_with_qualifier", "MeSH", "qualifier"))
})
