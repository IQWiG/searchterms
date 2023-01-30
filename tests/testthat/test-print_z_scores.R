test_that("Output is correct", {
  temp <- z_scores(test_path("fixtures/ris", "I26.txt"))
  result <- print_z_scores(temp, "freetext")
  path <- withr::local_tempfile({write.csv2(result,
                                            paste0(".csv"),
                                            row.names = F,
                                            quote = F,
                                            fileEncoding = "UTF-16BE") # see for details: https://en.wikipedia.org/wiki/UTF-16#Byte-order_encoding_schemes})
  },
  pattern = "I26",
  fileext = ".csv")
  ## add expectation
})
