#' Z-Score tables with German column names ready for exporting
#'
#' @param z_scores_object an object created with z_scores()
#' @param terms the terms to be exported, can be either "freetext", "MeSH" or "qualifier"
#'
#' @returns a data frame
#' @export
#'
#' @examples
#' ris <- c("TY  - JOUR",
#'          "AU  - Kapp",
#'          "TI  - Titles",
#'          "PY  - 2023",
#'          "JOUR  - IQWiG Journal",
#'          "KW  - Systematic Reviews as Topic",
#'          "ER  -")
#'
#' tmp <- tempfile(fileext = ".txt")
#' writeLines(ris, tmp)
#' data <- z_scores(tmp)
# print_z_scores(data, terms = "freetext")
print_z_scores <- function(z_scores_object, terms){ # terms can be "freetext" OR "MeSH" or "qualifier"
  stopifnot("Terms not `freetext` or `MeSh` or `qualifier`" = terms %in% c("freetext","MeSH","qualifier"))
  if(terms == "freetext"){
    z_scores_object[[eval(terms)]] %>%
      select("feature", "frequency", "docfreq", "E", "z", "approx_criteria") %>%
      rename("Wort" = .data$feature,
             `Anzahl Referenzen` = .data$docfreq,
             "Wortfrequenz" = .data$frequency,
             `Erwartete Frequenz` =.data$ E,
             "Z-Score" = .data$z,
             `Approximationskriterium zutreffend?` = .data$approx_criteria)
  }else if(terms == "MeSH"){
    z_scores_object[[eval(terms)]] %>%
      select("MeSH", "frequency", "E", "z", "approx_criteria") %>%
      rename( "Frequenz" = .data$frequency,
              `Erwartete Frequenz` = .data$E,
              "Z-Score" = .data$z,
              `Approximationskriterium zutreffend?` = .data$approx_criteria)
  }else if(terms == "qualifier"){
    z_scores_object[[eval(terms)]] %>%
      select("MeSH", "frequency", "E", "z", "approx_criteria") %>%
      rename( "Frequenz" = .data$frequency,
              `Erwartete Frequenz` = .data$E,
              "Z-Score" = .data$z,
              `Approximationskriterium zutreffend?` = .data$approx_criteria)
  } else {"Something went wrong! with print_z_scores()"}
}
