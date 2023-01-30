# test formal correctness of testset object
test_that("create_testset(), creates as named list of objects", {
  testset <- create_testset(test_path("fixtures/ris", "V21-06B.txt"))
  expect_named(testset, c("freetext","MeSH.Terms", "PMIDS", "reference.list", "text_corpus"))
})
