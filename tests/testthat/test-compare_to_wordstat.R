# compare testset and token list to wordstat
# compare z-score results to wordstat
#
test_that("Comparison to Wordstat-files is as expected", {
joined_results <- create_joined_results()
expect_vector(as.list(joined_results, size = 14247))
})

test_that("All tokens from Wordstat are found", {
joined_results <- create_joined_results()

lost_tokens <- joined_results %>%
  filter(is.na(z)) %>%
  count() %>%
  pull()
  expect_equal(lost_tokens, 0)
})

test_that("All tokens from Wordstat with z > 20 have z > 20", {
  joined_results <- create_joined_results()
  z20_ws <- joined_results %>%
    filter(z_wordstat >= 20)
  z20_r <- joined_results %>%
    filter(z >= 20 & z != 10000)
  z20 <- full_join(z20_r, z20_ws, by = c("feature", "project", "z_wordstat", "z"))

  token_overlap <- z20 %>%
    group_by(project) %>%
    summarise( all = length(feature),
               z = length(z)-sum(is.na(z)),
               z_wordstat = length(z_wordstat)-sum(is.na(z_wordstat))) %>%
    ungroup %>%
    mutate(diff = all - z,
           overlap = 100 - diff /all*100) %>%
    pull(overlap) %>%
    unique()
expect_equal(token_overlap, 100) # overlap for 10 test projects is 100%
  })

test_that("The threshold to identify all wordstat candidate terms is z > 20.1", {
joined_results <- create_joined_results()
  threshold <- joined_results %>%
  filter(z_wordstat >= 20 & !(is.na(z_wordstat))) %>%
  summarise(threshold = min(z)) %>%
  pull()

expect_true(21 > threshold & threshold > 20)
})

test_that("The amount of tokens with z > 20 is larger than in Wordstat", {
  joined_results <- create_joined_results()
  z20_ws <- joined_results %>%
    filter(z_wordstat >= 20)
  z20_r <- joined_results %>%
    filter(z >= 20 & z != 10000)
  z20 <- full_join(z20_r, z20_ws, by = c("feature", "project", "z_wordstat", "z"))

  result <- z20 %>%
    group_by(project) %>%
    filter(is.na(z_wordstat)) %>%
    ungroup %>%
    count() %>%
    pull()
  expect_equal(result, 0L)
})

test_that("No tokens from wordstat with z > 20 are lost", {
  joined_results <- create_joined_results()
  z20_ws <- joined_results %>%
    filter(z_wordstat >= 20)
  z20_r <- joined_results %>%
    filter(z >= 20 & z != 10000)
  z20 <- full_join(z20_r, z20_ws, by = c("feature", "project", "z_wordstat", "z"))

  result <- z20 %>%
    group_by(project) %>%
    filter(is.na(z)) %>%
    ungroup() %>%
    count() %>%
    pull()

  expect_equal(result, 0L)
})

test_that("Tokens, with no z-score in Wordstat either \n
          have a z-score of 10000, \nare a known erroneous token from wordstat,\n
          are additional 18 known tokens which do not appear in wordstat", {

wordstat <- readRDS(test_path("fixtures", "wordstat_list.Rds"))
wordstat <- wordstat %>%
  bind_rows() %>%
  select(feature, Z_Score,project) %>%
  rename(z_wordstat = Z_Score) %>%
  filter(is.na(z_wordstat))
wordstat$z_wordstat <- "Not in Population Set"

r_files <- list.files(test_path("fixtures/ris"), full.names = T)
r_names <- regmatches(r_files, gregexpr("(\\w|-)+(?=\\.)", r_files, perl = T))
results <- lapply(r_files, z_scores)
names(results) <- r_names
results<- lapply(results, function(x) {x[[c("freetext")]]})
names(results) <- NULL
results <- results %>%
  bind_rows() %>%
  select(feature,z, project) %>%
  filter(z == 10000)

missing_tokens <- left_join(wordstat, results, by =c("feature", "project")) %>%
  filter(is.na(z)) %>%
  pull(feature)

extra_tokens <-results %>%
left_join(wordstat, by =c("feature", "project")) %>%
  filter(is.na(z_wordstat)) %>%
  count() %>%
  pull()

affected_projects <- results %>%
  left_join(wordstat, by =c("feature", "project")) %>%
  filter(is.na(z_wordstat)) %>%
  summarise(projects = unique(project)) %>%
  pull(projects)
expect_equal(missing_tokens, "a")
expect_equal(extra_tokens, 18)
expect_equal(affected_projects, c("A21-67", "A21-82", "A22-10", "V21-06B"))
})

#
#
#all_tokens <- joined_results %>%
#  group_by(project) %>%
#  summarise( combined_tokens = length(feature),
#             tokens = length(z)-sum(is.na(z)),
#             tokens_wordstat = length(z_wordstat)-sum(is.na(z_wordstat))) %>%
#  ungroup()

# token_count %>%
#summarise(`Median Canditates Wordstat` = median(z_wordstat),
#          `SD (Wordstat)` = sd(z_wordstat),
#          `Median Canditates R` = median(z),
#          `SD (R)` = sd(z))
#
