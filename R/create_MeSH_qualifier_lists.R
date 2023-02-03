create_MeSH_qualifier_lists <- function(testset){

testset[["MeSH.Terms"]][["MeSH"]] <-  testset[["MeSH.Terms"]][["all_keywords"]] %>%
  filter(.data$MeSH %in% .env$popset[["MeSH.Terms"]][["MeSH"]]) %>%
  mutate(n = sum(frequency, na.rm = T))
testset[["MeSH.Terms"]][["qualifier"]]<- testset[["MeSH.Terms"]][["all_keywords"]] %>%
  filter(.data$MeSH %in% .env$popset[["qualifier"]][["qualifier"]])%>%
  mutate(n = sum(frequency, na.rm = T))

return(testset)
}
