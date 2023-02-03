prepare_MeSH_table <- function (reference_set) {

  # Select all keywords and flatten lists for data wrangling
  list_MeSH_complete <- reference_set %>%
    map(pluck, "keywords")

  list_MeSH_freq <- list_MeSH_complete %>%
    map(gsub, pattern = "(\\s)*\\*", replacement = "") %>%
    map(str_split, pattern = "/")

  #create frequency of all normalized keywords in dataset
  df_MeSH <- list_MeSH_freq %>%
    map(flatten_chr) %>%
    map(function(x){as.data.frame(table(x, dnn=(list = "MeSH")),
                                     responseName = "frequency",
                                     stringsAsFactors = F)})%>%
    bind_rows(.id = "reference") %>%
    group_by(.data$MeSH) %>%
    summarise(docfreq = n(),
              frequency = sum(.data$frequency)) %>%
    arrange(desc(.data$docfreq))%>%
    ungroup()

  #create frequencies of heading/subheading combinations

  df_MeSH_long <- list_MeSH_freq %>%
    map_depth(.depth = 2,function(x){list(x[1], x[-1])}) %>%
    map_depth(.depth = 2,function(x) {paste0(x[[1]],"/",x[[2]])}) %>%
    map(flatten_chr)%>%
    map(function(x){as.data.frame(table(x, dnn=(list = "MeSH_qualifier")),
                                     responseName = "frequency",
                                     stringsAsFactors = F)}) %>%
    bind_rows(.id = "reference") %>%
    group_by(.data$MeSH_qualifier) %>%
    summarise(docfreq = n(),
              frequency = sum(.data$frequency)) %>%
    arrange(desc(.data$docfreq)) %>%
    ungroup()

  #create frequency of all starred keywords in dataset
  df_MeSH_starred <- list_MeSH_complete %>%
    map(str_split, pattern = "/") %>%
    map(flatten_chr) %>%
    map(grep, pattern= "\\*.*", value = T) %>%
    map(function(x){as.data.frame(table(x, dnn=(list = "MeSH_starred")),
                                     responseName = "frequency",
                                     stringsAsFactors = F)}) %>%
    bind_rows(.id = "reference")
    if(exists("df_MeSH_starred$MeSH_starred")){
      df_MeSH_starred <- df_MeSH_starred %>%
        group_by(.data$MeSH_starred) %>%
        summarise(docfreq = n(),
                  frequency = sum(.data$frequency)) %>%
        arrange(desc(.data$docfreq))%>%
        ungroup()
      result <- list("all_keywords" = df_MeSH, "MeSH_with_qualifier" = df_MeSH_long, "MeSH_starred" = df_MeSH_starred)
    }else{
      result <- list("all_keywords" = df_MeSH, "MeSH_with_qualifier" = df_MeSH_long)
      }
  return(result)
}
