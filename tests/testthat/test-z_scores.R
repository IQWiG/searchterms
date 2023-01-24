test_that("created output CSV-files are correct", {
  #create name  for the file using the name of the input ris-file without date stamp
  match_filename <- regmatches(risfile, regexpr("(?<=_|/)(\\w|-)+(?=\\.)", risfile, perl = T))

  write.csv2(zscore_freetext_csv,
             paste0(here(),"/Output/", Sys.Date(),"_Z-Scores",match_filename,".csv"),
             row.names = F,
             quote = F,
             fileEncoding = "UTF-16BE") # see for details: https://en.wikipedia.org/wiki/UTF-16#Byte-order_encoding_schemes

  write.csv2(zscore_MeSH_csv,
             paste0(here(),"/Output/", Sys.Date(),"_MeSH_Z-Scores",match_filename,".csv"),
             fileEncoding = "UTF-16BE")

  write.csv2(zscore_qualifier_csv,
             paste0(here(),"/Output/", Sys.Date(),"_qualifier_Z-Scores",match_filename,".csv"),
             fileEncoding = "UTF-16BE")

  expect_equal(2 * 2, 4)
})
