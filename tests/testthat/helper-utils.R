#create_joined_results() to compare benchmark wordstat results and package results
create_joined_results <- function(){
r_files <- list.files(test_path("fixtures/ris"), full.names = T)
r_names <- regmatches(r_files, gregexpr("(\\w|-)+(?=\\.)", r_files, perl = T))
results <- lapply(r_files, z_scores)
names(results) <- r_names
results<- lapply(results, function(x) {x[[c("freetext")]]})
names(results) <- NULL
results <- results %>%
  dplyr::bind_rows() %>%
  dplyr::select(feature,z, project)

wordstat <- readRDS(test_path("fixtures", "wordstat_list.Rds"))
wordstat <- wordstat %>%
  dplyr::bind_rows() %>%
  dplyr::select(feature, Z_Score,project) %>%
  dplyr::rename(z_wordstat = Z_Score)

joined_results <- full_join(results, wordstat, by = c("feature", "project"))
}
