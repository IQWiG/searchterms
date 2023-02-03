#' Process raw Endnote ris file with PubMed data into population norm set
#'
#' @param risfile a RIS file produced with Endnote
#'
#' @returns popset a list of objects
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom dplyr select
#' @importFrom rlang set_names

create_popset <- function(risfile){
  popset_ref <- read_bibliography(risfile, return_df = F)
  popset_df <- create_corpus(popset_ref)
  popset_df <- prepare_freq_table(popset_df)
  popset_df <- popset_df %>%
    select(!(.data$group)) %>%
    rename(Norm.frequency = .data$frequency,
           Norm.docfreq = .data$docfreq,
           Norm.rank = .data$rank,
           N = .data$n) %>%
    mutate(p = .data$Norm.frequency/.data$N)

  popset_MeSH <- create_MeSH_norm_frequencies(popset_ref)
  popset <- list("freetext" = popset_df, "MeSH.Terms" = popset_MeSH[["headings"]], "qualifier" = popset_MeSH[["qualifier"]])

  return(popset)
}
