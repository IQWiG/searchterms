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
