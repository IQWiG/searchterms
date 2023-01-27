#test_that("created output CSV-files are correct", {
  #create name  for the file using the name of the input ris-file without date stamp
#  match_filename <- regmatches(risfile, regexpr("(?<=_|/)(\\w|-)+(?=\\.)", risfile, perl = T))

  #z_scores(...)
  #withr output-path
  #compare to inital csv files
#  write.csv2(zscore_freetext_csv,
#            paste0(".csv"),
#             row.names = F,
#             quote = F,
#             fileEncoding = "UTF-16BE") # see for details: https://en.wikipedia.org/wiki/UTF-16#Byte-order_encoding_schemes

#  write.csv2(zscore_MeSH_csv,
#             paste0(".csv"),
#             fileEncoding = "UTF-16BE")

#  write.csv2(zscore_qualifier_csv,
#             paste0(".csv"),
#             fileEncoding = "UTF-16BE")

#  expect_equal()
#})

test_that("All tokens from Wordstat are found", {

})

test_that("All tokens from Wordstat with Z-score >20 are have a Z-score >20", {

})

test_that("The amount of tokens with Z-score >20 is larger than in Wordstat", {

})

#PRÜFEN
test_that("Z-scores are calculated", {.
  z_scores(test_path("fixtures/ris", "D22-01.txt"))
  ## add expectation
  })

test_that("Comparison to Wordstat-files is as expected", {
  r_files <- list.files(test_path("fixtures/ris"), full.names = T)
  r_names <- regmatches(r_files, gregexpr("(\\w|-)+(?=\\.)", r_files, perl = T))
  results <- lapply(r_files, z_scores)
  names(results) <- r_names
  # add expectation
})

#wrap analysis in tests

#z20_r <- lapply(results, function(x) {x[[c("freetext")]]})
#names(z20_r) <- NULL
#
##1.	Wie viele Tokens Überschneiden sich bei z>20?
#z20_r <- z20_r %>%
#  bind_rows() %>%
#  select(feature,z, project) %>%
#  filter(z>=20)
#
#z20_ws <- wordstat_list %>%
#  bind_rows() %>%
#  select(feature, Z_Score,project) %>%
#  filter(Z_Score >= 20)
#
#z20 <- full_join(z20_r, z20_ws, by = c("feature", "project"))
#
#token_count <- z20 %>%
#  group_by(project) %>%
#  summarise( all = length(Z_Score),
#             z = length(z)-sum(is.na(z)),
#             Z_Score = length(Z_Score)-sum(is.na(Z_Score))) %>%
#  ungroup
#
#token_count %>%
#  mutate(diff = all - z,
#         overlap = 100 - diff /all*100)
#
#token_count %>%
#  summarise(`Mittlere Anzahl Canditates` = mean(Z_Score),
#            sd = sd(Z_Score))
#
##  2.	Welche Tokens gehen verloren?
#z20 %>%
#  group_by(project) %>%
#  filter(is.na(z))
#
##  3.	Auf welchen Z-Wert muss ich erweitern, um alle Tokens aus Wordstat zu haben?
#z20 %>%
#  filter(is.na(z)) %>%
#  summarise(threshold = max(Z_Score))
#
#
##  4.	Wie viel Überschuss? (z-Wert <20 in Wordstat) in kommt dazu?
#z20 %>%
#  group_by(project) %>%
#  count %>%
#  ungroup %>%
#  summarise( `Mittlere Anzahl Canditates` = mean(n))
#
#z20 %>%
#  group_by(project) %>%
#  filter(is.na(Z_Score)) %>%
#  count() %>%
#  ungroup %>%
#  summarise(`Mittlere Anzahl zusätzlicher Terms`= mean(n),
#            sd = sd(n),
#            min = min(n),
#            max = max(n))
#
