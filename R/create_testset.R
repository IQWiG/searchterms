create_testset <- function(risfile, dev_set = FALSE, project_name = TRUE, seed = NULL) {
  #!!!!!!!!!!!! PRÜFEN###############################

  testset_ref <- read_bibliography(risfile, return_df = F)

  if (dev_set){
    #### create a development set of two thirds of the testset
    all_ref <- testset_ref
    if(is.null(seed)){
      ## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!update randomisation
      seed <- sample.int(.Machine$integer.max, 1L)
    }
    random_references <- with_seed(seed, sample(length(all_ref),
                                                round((length(all_ref)*2)/3)))

    validation_references <- setdiff(seq(all_ref), random_references)

    validationset_ref <- all_ref[validation_references]
    testset_ref <- all_ref[random_references]
    validation_set <- TRUE

  }else{
    validationset_ref <- NULL
    validation_set <- FALSE
  }

  pmids <- return_pmids(testset_ref,
                        validationset_ref = validationset_ref,
                        validation_set = validation_set)

  testset_corpus <- create_corpus(testset_ref)
  testset_df <- prepare_freq_table(testset_corpus)
  testset_MeSH <- prepare_MeSH_table(testset_ref)


  # attach project name per row
  if (project_name){
    project_names <- gregexpr("(?<=/|\\\\)(\\w|-)+(?=\\.)", risfile, perl = T)
    project_names <- regmatches(risfile,project_names)
    testset_df$project <- unlist(project_names)
    testset_MeSH[["all_keywords"]]$project <- unlist(project_names)
  }

  if(dev_set){
    testset <- list ("freetext" = testset_df,
                     "MeSH.Terms" = testset_MeSH,
                     "PMIDS" = pmids,
                     "reference.list" = all_ref, # return list of all references not only development set
                     "development_set" = testset_ref,
                     "validation_set" = validationset_ref,
                     "text_corpus" = testset_corpus,
                     "seed" = seed) #

  }else{
    testset <- list ("freetext" = testset_df,
                     "MeSH.Terms" = testset_MeSH,
                     "PMIDS" = pmids,
                     "reference.list" = testset_ref,
                     "text_corpus" = testset_corpus)
  }
  return(testset)
}
