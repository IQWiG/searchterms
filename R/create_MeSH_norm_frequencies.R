create_MeSH_norm_frequencies <- function (reference_set) {
#  MeSH_Dictionary <- utils::read.csv2(paste0(here::here(),"/Data/mesh2022.csv"), header = F, col.names = c("MeSH"))
#  Qualifier_Dictionary <- data.frame(qualifier = readLines(paste0(
#   here::here(),"/Data/qualifier.txt")))

  population_MeSH <- prepare_MeSH_table(reference_set)

  population_headings <- MeSH_Dictionary %>%
    left_join(population_MeSH[["all_keywords"]], by = "MeSH") %>%
    rename(Norm.frequency = .data$frequency,
           Norm.docfreq = .data$docfreq) %>%
    mutate(N = sum(.data$Norm.frequency, na.rm = T),
           p = .data$Norm.frequency/.data$N)

  population_qualifier <- Qualifier_Dictionary %>%
    left_join(population_MeSH[["all_keywords"]], by = c("qualifier" = "MeSH")) %>%
    rename(Norm.frequency = .data$frequency,
           Norm.docfreq = .data$docfreq) %>%
    mutate(N = sum(.data$Norm.frequency, na.rm = T),
           p = .data$Norm.frequency/.data$N)

  result <- list("headings" = population_headings, "qualifier" = population_qualifier)

  return(result)
}
