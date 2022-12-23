#' Process raw Endnote ris file with PubMed data into population norm set
#'
#' @param risfile a RIS file produced with Endnote
#' @param vocabulary the name of the controlled vocabularay, usually "MeSH"
#'
#' @return a list of objects
#' @export create_popset
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom dplyr select
#' @importFrom rlang set_names
#' @examples # import a risfile
#' \dontrun{
#' create_popset(expected.ris)
#' }

create_popset <- function(risfile, vocabulary){
  popset_ref <- read_bibliography(risfile, return_df = F)
  popset_df <- create_corpus(popset_ref)
  popset_df <- prepare_freq_table(popset_df)
  popset_df <- popset_df %>%
    select(!(group)) %>%
    rename(Norm.frequency = frequency,
           Norm.docfreq = docfreq,
           Norm.rank = rank,
           N = n) %>%
    mutate(p = Norm.frequency/N)

  popset_MeSH <- create_MeSH_norm_frequencies(popset_ref)
  popset <- list("freetext" = popset_df, "MeSH.Terms" = popset_MeSH[["headings"]], "qualifier" = popset_MeSH[["qualifier"]])
  if(vocabulary != "MeSH"){
    set_names(my.list["MeSH.Terms"], paste0(vocabulary,".Terms"))
  }
  return(popset)
}
