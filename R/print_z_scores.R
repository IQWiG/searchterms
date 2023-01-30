#' Z-Score tables with German column names ready for exporting
#'
#' @param z_scores_object an object created with z_scores()
#' @param terms the terms to be exported, can be either "freetext", "MeSH" or "qualifier"
#'
#' @returns a data frame
#' @export
#'
#' @examples
print_z_scores <- function(z_scores_object, terms){ # terms can be "freetext" OR "MeSH" or "qualifier"
  stopifnot("Terms not `freetext` or `MeSh` or `qualifier`" = terms %in% c("freetext","MeSH","qualifier"))
  if(terms == "freetext"){
    z_scores_object[[eval(terms)]] %>%
      select(feature, frequency, docfreq, E, z, approx_criteria) %>%
      rename("Wort" = feature,
             `Anzahl Referenzen` = docfreq,
             "Wortfrequenz" = frequency,
             `Erwartete Frequenz` = E,
             "Z-Score" = z,
             `Approximationskriterium zutreffend?` = approx_criteria)
  }else if(terms == "MeSH"){
    z_scores_object[[eval(terms)]] %>%
      select(frequency, E, z, approx_criteria) %>%
      rename( "Frequenz" = frequency,
              `Erwartete Frequenz` = E,
              "Z-Score" = z,
              `Approximationskriterium zutreffend?` = approx_criteria)
  }else if(terms == "qualifier"){
    z_scores_object[[eval(terms)]] %>%
      select(MeSH, frequency, E, z, approx_criteria) %>%
      rename( "Frequenz" = frequency,
              `Erwartete Frequenz` = E,
              "Z-Score" = z,
              `Approximationskriterium zutreffend?` = approx_criteria)
  } else {"Something went wrong! with print_z_scores()"}
}
