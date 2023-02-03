#' Z score tables
#'
#' @param risfile a data frame containing a testset
#' @param risfile_population a dataframe containing a population set
#' @param load_popset logical, should internal population set be applied (default) or should a customized population set be calculated
#' @param dev_set logical, if testset should be randomly divided into a development and validation set select TRUE?
#' @param seed should be included, to reproduce a created development set from a previous session
#'
#' @returns a list
#' @export
#' @examples
#' path <- system.file("extdata", "example_ris.txt", package = "searchterms")
#' z_scores(path)
#'
z_scores <- function(risfile, risfile_population, load_popset = TRUE,dev_set = FALSE, seed = NULL){

  #load population set
  if(load_popset == F){
    popset <- create_popset(risfile_population)
  }
  # calculate frequency table for testset
  testset <- create_testset(risfile, dev_set = dev_set, seed = seed)
  testset <- create_MeSH_qualifier_lists(testset)


  zscore_freetext <- calculate_z_scores(testset[["freetext"]], popset[["freetext"]], key_testset = "feature", key_popset = "feature")
  zscore_MeSH <- calculate_z_scores(testset[["MeSH.Terms"]][["MeSH"]], popset[["MeSH.Terms"]], key_popset = "MeSH")
  zscore_qualifier <- calculate_z_scores(testset[["MeSH.Terms"]][["qualifier"]], popset[["qualifier"]], key_popset = "qualifier")

  #revtools::write_bibliography(testset[["validation_set"]],
  #                             filename = paste0(here::here(),
  #                                               "/Output/validation_set.ris")
  #                             , format = "ris")

  # überarbeiten
  result <- list("freetext" = zscore_freetext,
                 "MeSH" = zscore_MeSH,
                 "qualifier" = zscore_qualifier,
                 "all_keywords" = testset$MeSH.Terms$all_keywords,
                 "leftover_keywords" = testset$MeSH.Terms$Not_MeSH)
  return(result)
}
