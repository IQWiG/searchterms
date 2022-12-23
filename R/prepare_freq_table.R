
prepare_freq_table <- function(corpus_ref, devSet = FALSE, project_name = FALSE){

  # remove all special characters
  # see also:    https://de.wikipedia.org/wiki/Liste_der_Unicode-Eigenschaften
  # punctuation: remove all characters in the Unicode "Punctuation" [P] class⁠
  # symbols:     all characters in the Unicode "Symbol" ⁠[S]⁠ class
  # hyphens:     if FALSE, do not split words that are connected by hyphenation and hyphenation-like characters in between words, e.g. "self-aware" becomes c("self", "-", "aware")
  # numbers:     remove tokens that consist only of numbers, but not words that start with digits, e.g. ⁠2day⁠

  dfm_ref <- quanteda::dfm(quanteda::tokens(corpus_ref, remove_punct = T, split_hyphens = T, remove_symbols = T, remove_numbers = T))
  freq_ref <- quanteda.textstats::textstat_frequency(dfm_ref)
  freq_ref <- freq_ref %>%
    mutate(n = sum(frequency,na.rm=T))

  # attach project name per row

  if (project_name){

    project_name <- gregexpr("(?<=/)(\\w|-)+(?=\\.)", risfile, perl = T)
    project_name <- regmatches(risfile,project_name)
    freq_ref$project <- unlist(project_name)
  }
  return(freq_ref)
}
