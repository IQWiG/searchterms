adjacency <- function(corpus_data, skip) {
  corpus_data %>%
    quanteda::tokens(remove_punct = T, remove_symbols = T,padding = F) %>%
    quanteda::tokens_remove(quanteda::stopwords("en"), padding = T) %>%
    quanteda::tokens_ngrams(n = 2, skip = skip, concatenator = " ") %>%
    dfm %>%
    textstat_frequency()%>%
    select(feature, frequency) %>%
    mutate(ngram = skip+2)
#  return(skip)
}

summarise_adjacency <- function(){
  result <- vector("list", 4)

  for (i in seq_along(0:3)){
  skip <- i - 1
    result[[i]] <- adjacency(my_corpus, skip = skip)
  }
  #  full_join(df30, by = "feature", suffix = c("_2", "_3")) %>%
  #  full_join(df40, by = "feature") %>%
  #  full_join(df50, by = "feature", suffix = c("_4", "_5")) %>%
  #  mutate(frequency = rowSums(dplyr::across(c(frequency_2,frequency_3,frequency_4,frequency_5)), na.rm = T),
  #         ngram = paste(ngram_2,ngram_3,ngram_4, ngram_5),
  #         ngram = str_replace_all(ngram, pattern = "NA",replacement ="-")) %>%
  #  select(feature, frequency, ngram) %>%
  #  arrange(desc(frequency))
  #
}
