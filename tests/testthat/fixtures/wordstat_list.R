#Import z-score tables

import_wordstats <- function(csv2){
  zscore_wordstat <- read.csv2(csv2,
                               header = FALSE,
                               skip = 1,
                               colClasses = c("character",
                                              "integer",
                                              rep("NULL",3),
                                              "integer",
                                              rep("NULL",2),
                                              "double",
                                              rep("NULL",1),
                                              "double",
                                              "NULL"),
                               col.names = c("feature",
                                             "frequency",
                                             rep("NULL",3),
                                             "docfreq",
                                             rep("NULL",2),
                                             "E",
                                             "NULL",
                                             "Z_Score",
                                             "NULL"),
                                 #encoding = "utf-8" #some special characters (like french accents) cause trouble in csv-files created by Excel, e.g.import_wordstats(wordstat_files[4])[1031,]
  )
  # change tokens to lower case
  zscore_wordstat$feature <- tolower(zscore_wordstat$feature)

  ##attach project name per row
  project_name <- gregexpr("(?<=/)(\\w|-)+(?=\\.)", csv2, perl = T)
  project_name <- regmatches(csv2 , project_name)
  zscore_wordstat$project <- unlist(project_name)

  return(zscore_wordstat)
}

#import all wordstat_files and create a list
wordstat_files <- list.files(paste0( "C:/Users/kapp/Desktop/GA22-02/5-Evaluation/Code/Data/Frequencies/Wordstat/"
  ),pattern = "*.csv", full.names = T)

wordstat_list <- sapply(wordstat_files,import_wordstats, simplify = F, USE.NAMES =T)
wordstat_names <- gregexpr("(?<=/)(\\w|-)+(?=\\.)", wordstat_files, perl = T)
names(wordstat_list) <- regmatches(wordstat_files,wordstat_names)
saveRDS(wordstat_list, "tests/testthat/fixtures/wordstat_list.rds")
