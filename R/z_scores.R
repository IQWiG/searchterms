#' Z score tables
#'
#' @param risfile a data frame containing a testset
#' @param risfile_population a dataframe containing a population set
#' @param vocabulary defining the controlled vocabulary used, currently only "MeSH" avaibable for the package
#' @param load_popset logical, should internal population set be applied (default) or should a customized population set be calculated
#' @param MeSH logical, deprecated currently only TRUE available
#' @param dev_set logical, if testset should be randomly divided into a development and validation set select TRUE?
#' @param seed should be included, to reproduce a created development set from a previous session
#'
#' @returns a list
z_scores <- function(risfile, risfile_population, vocabulary = "MeSH", load_popset = TRUE, MeSH = TRUE, dev_set = FALSE, seed = NULL){

  #load population set
  if(load_popset == F){
    popset <- create_popset(risfile_population, vocabulary = vocabulary)
  }
  # calculate frequency table for testset
  testset <- create_testset(risfile, dev_set = dev_set, vocabulary = vocabulary, seed = seed)

  testset[["MeSH.Terms"]][["qualifier"]]<- testset[["MeSH.Terms"]][["all_keywords"]] %>%
    filter(MeSH %in% popset[["qualifier"]][["qualifier"]])%>%
    mutate(n = sum(frequency, na.rm = T))

  testset[["MeSH.Terms"]][["MeSH"]] <-  testset[["MeSH.Terms"]][["all_keywords"]] %>%
    filter(MeSH %in% popset[["MeSH.Terms"]][["MeSH"]]) %>%
    mutate(n = sum(frequency, na.rm = T))

  zscore_freetext <- calculate_z_scores(testset[["freetext"]], popset[["freetext"]], key = "feature")
  zscore_MeSH <- calculate_z_scores(testset[["MeSH.Terms"]][["MeSH"]], popset[["MeSH.Terms"]], key = "MeSH")
  zscore_qualifier <- calculate_z_scores(testset[["MeSH.Terms"]][["qualifier"]], popset[["qualifier"]], key = c("MeSH" ="qualifier"))

  zscore_freetext_csv <- zscore_freetext %>%
    select(feature, frequency, docfreq, E, z, approx_criteria) %>%
    rename("Wort" = feature,
           `Anzahl Referenzen` = docfreq,
           "Wortfrequenz" = frequency,
           `erwartete frequenz` = E,
           "Z-Score" = z,
           `Approximationskriterium zutreffend?` = approx_criteria)
  zscore_MeSH_csv <- zscore_MeSH %>%
    select(all_of(vocabulary), frequency, E, z, approx_criteria) %>%
    rename( "frequenz" = frequency,
            `erwartete frequenz` = E,
            "Z-Score" = z,
            `Approximationskriterium zutreffend?` = approx_criteria)

  zscore_qualifier_csv <- zscore_qualifier %>%
    select(qualifier, frequency, E, z, approx_criteria) %>%
    rename( "frequenz" = frequency,
            `erwartete frequenz` = E,
            "Z-Score" = z,
            `Approximationskriterium zutreffend?` = approx_criteria)

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
