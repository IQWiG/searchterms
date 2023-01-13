#' PubMed MeSH Headings 2022
#'
#' A comprehensive list of the MeSH headings as data.frame
#'
#'
#' @format ## `MeSH Dictionary`
#' A data frame with 3094 rows and 1 column:
#' \describe{
#'   \item{MeSH}{MeSH Heading}
#' }
#' @source <https://www.nlm.nih.gov/databases/download/mesh.html>
"MeSH_Dictionary"

#' PubMed random population set
#'
#' A random sample of PubMed references drawn from random PMIDs (range 1000 - 36000000),
#' search date: April 1st 2022.
#'
#'
#' @format ## `Population Set 2022`
#' A list of 3 data frames
#' \describe{
#'   freetext  :Classes ‘frequency’, ‘textstat’ and 'data.frame':	66014 obs. of  6 variables:
#'   \describe{
#'     \item{feature}{character, single word token/term}
#'     \item{Norm.frequency}{numeric, absolute frequency of each token/term in population set}
#'     \item{Norm.rank}{numeric, rank of token/term in population set}
#'     \item{Norm.docfreq}{numeric, absolute document frequency of each token/term in population set}
#'     \item{N}{numeric, total frequency of all token/terms in population set}
#'     \item{p}{p-value of binomial test of Norm.frequency}
#'     }
#'   MeSH.Terms:'data.frame':	30194 obs. of  5 variables:
#'   \describe{
#'     \item{MeSH}{character, MeSH heading title style case}
#'     \item{Norm.docfreq}{numeric, absolute document frequency of each MeSH heading in population set}
#'     \item{Norm.frequency}{numeric, absolute frequency of each MeSH heading in population set}
#'     \item{N}{numeric, total frequency of all MeSH headings in population set}
#'     \item{p}{numeric, p-value of binomial test of Norm.frequency}
#'     }
#'   qualifier :'data.frame':	76 obs. of  5 variables:
#'   \describe{
#'     \item{qualifier}{character, MeSH qualifier all lower case}
#'     \item{Norm.docfreq}{numeric, absolute document frequency of each MeSH qualifier in population set}
#'     \item{Norm.frequency}{numeric, absolute frequency of each MeSH qualifier in population set}
#'     \item{N}{numeric, total frequency of all MeSH qualifiers in population set}
#'     \item{p}{numeric, p-value of binomial test of Norm.frequency}
#'     }
#' }
#' @source <https://www.pubmed.com>
"popset"

#' PubMed Qualifier 2022
#'
#' A comprehensive list of the MeSH qualifier as data.frame
#'
#'
#' @format ## `Qualifier Dictionary`
#' A data frame with 76 rows and 1 column:
#' \describe{
#'   \item{qualifier}{MeSH qualifier}
#' }
#' @source <https://www.nlm.nih.gov/databases/download/mesh.html>
"Qualifier_Dictionary"
