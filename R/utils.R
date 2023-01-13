return_pmids <- function(testset_ref, validationset_ref = NULL, validation_set = FALSE){

  testset_pmids<- testset_ref %>%
    map(.,pluck, "accession") %>%
    flatten_chr

  if(validation_set){
    validation_set_pmids <- validationset_ref %>%
      map(.,pluck, "accession") %>%
      flatten_chr

    result <- list("development_set"= testset_pmids,
                   "validation_set" = validation_set_pmids)
  }else{
    result <- list("testset" = testset_pmids)
  }
  return(result)
}
calculate_z_scores <- function (testset, popset, key) {
  z_table <- testset %>%
    left_join(popset, by = key)%>%
    mutate(#n = sum(frequency, na.rm = T),
      E = n*p,
      var = E*(1-p),
      z = (frequency - E)/sqrt(var),
      approx_criteria = var >= 9) %>%
    arrange(desc(z))

  #change z-Score for Values, that are not in population Set to 10000
  z_table$z <-z_table$z %>% replace_na(10000)

  return(z_table)
}
