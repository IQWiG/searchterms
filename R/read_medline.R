read_medline <- function (x)
{
  x_merge <- merge(x, tag_lookup(type = "medline"), by = "ris",
                   all.x = TRUE, all.y = FALSE)
  x_merge <- x_merge[order(x_merge$row_order), ]
  x_split <- split(x_merge[c("bib", "text")], x_merge$ref)
  x_final <- lapply(x_split, function(a) {
    result <- split(a$text, a$bib)
    if (any(names(result) == "abstract")) {
      result$abstract <- paste(result$abstract, collapse = " ")
    }
    if (any(names(result) == "title")) {
      if (length(result$title) > 1) {
        result$title <- paste(result$title, collapse = " ")
      }
    }
    if (any(names(result) == "term_other")) {
      names(result)[which(names(result) == "term_other")] <- "keywords"
    }
    if (any(names(result) == "date_published")) {
      result$year <- substr(result$date_published, start = 1,
                            stop = 4)
    }
    if (any(names(result) == "article_id")) {
      doi_check <- grepl("doi", result$article_id)
      if (any(doi_check)) {
        result$doi <- strsplit(result$article_id[which(doi_check)],
                               " ")[[1]][1]
      }
    }
    return(result)
  })
  names(x_final) <- unlist(lapply(x_final, function(a) {
    a$pubmed_id
  }))
  class(x_final) <- "bibliography"
  return(x_final)
}
