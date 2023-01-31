# compare testset and token list to wordstat
# compare z-score results to wordstat
#
test_that("Comparison to Wordstat-files is as expected", {
  r_files <- list.files(test_path("fixtures/ris"), full.names = T)
  r_names <- regmatches(r_files, gregexpr("(\\w|-)+(?=\\.)", r_files, perl = T))
  results <- lapply(r_files, z_scores)
  names(results) <- r_names
  # add expectation
})


test_that("All tokens from Wordstat are found", {
joined_results <- create_joined_results()

all_tokens <- joined_results %>%
    group_by(project) %>%
    summarise( combined_tokens = length(feature),
               tokens = length(z)-sum(is.na(z)),
               tokens_wordstat = length(z_wordstat)-sum(is.na(z_wordstat))) %>%
    ungroup
  # add expectation
})

test_that("All tokens from Wordstat with Z-score >20 are have a Z-score >20", {
  joined_results <- create_joined_results()
  z20_ws <- joined_results %>%
    dplyr::filter(z_wordstat >= 20)
  z20_r <- joined_results %>%
    dplyr::filter(z >= 20)
  z20 <- dplyr::full_join(z20_r, z20_ws, by = c("feature", "project", "z_wordstat", "z"))

  token_count <- z20 %>%
    group_by(project) %>%
    summarise( all = length(feature),
               z = length(z)-sum(is.na(z)),
               z_wordstat = length(z_wordstat)-sum(is.na(z_wordstat))) %>%
    ungroup %>%
    mutate(diff = all - z,
           overlap = 100 - diff /all*100)

  token_count %>%
    summarise(`Median Canditates Wordstat` = median(z_wordstat),
              `SD (Wordstat)` = sd(z_wordstat),
              `Median Canditates R` = median(z),
              `SD (R)` = sd(z))
# add expectation
  })

test_that("The amount of tokens with Z-score >20 is larger than in Wordstat", {

})


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
