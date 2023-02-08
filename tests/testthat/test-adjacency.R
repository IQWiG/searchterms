test_that("adjacency creates a data frame", {
  test_corpus <- readRDS(test_path("fixtures", "testset.rds"))$text_corpus
  result <- summarise_adjacency(test_corpus)
  expect_named(result, c("feature", "frequency", "ngram_2", "ngram_3", "ngram_4", "ngram_5"))
  expect_true(nrow(result) > 0 )
})
