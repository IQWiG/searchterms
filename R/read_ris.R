read_ris <- function (x, tag_type = "ris")
{
  x_merge <- merge(x, tag_lookup(type = tag_type), by = "ris",
                   all.x = TRUE, all.y = FALSE)
  x_merge <- x_merge[order(x_merge$row_order), ]
  if (any(is.na(x_merge$bib))) {
    rows_tr <- which(is.na(x_merge$bib))
    x_merge$bib[rows_tr] <- x_merge$ris[rows_tr]
    if (all(is.na(x_merge$row_order))) {
      start_val <- 0
    }
    else {
      start_val <- max(x_merge$row_order, na.rm = TRUE)
    }
    x_merge$row_order[rows_tr] <- as.numeric(as.factor(x_merge$ris[rows_tr])) +
      start_val
  }
  year_check <- regexpr("^\\d{4}$", x_merge$text)
  if (any(year_check > 0)) {
    check_rows <- which(year_check > 0)
    year_strings <- as.numeric(x_merge$text[check_rows])
    if (any(x_merge$bib[check_rows] == "year", na.rm = TRUE)) {
      year_freq <- xtabs(~ref, data = x_merge[which(x_merge$bib ==
                                                      "year"), ])
      if (any(year_freq > 1)) {
        year_df <- x_merge[which(x_merge$bib == "year"),
        ]
        year_list <- split(nchar(year_df$text), year_df$ris)
        year_4 <- sqrt((4 - unlist(lapply(year_list,
                                          mean)))^2)
        incorrect_rows <- which(x_merge$ris != names(which.min(year_4)[1]) &
                                  x_merge$bib == "year")
        x_merge$bib[incorrect_rows] <- "year_additional"
      }
    }
    else {
      possible_rows <- which(year_strings > 0 & year_strings <=
                               as.numeric(format(Sys.Date(), "%Y")) + 1)
      tag_frequencies <- as.data.frame(xtabs(~x_merge$ris[check_rows[possible_rows]]),
                                       stringsAsFactors = FALSE)
      colnames(tag_frequencies) <- c("tag", "n")
      tag_frequencies$prop <- tag_frequencies$n/(max(x_merge$ref) +
                                                   1)
      if (any(tag_frequencies$prop > 0.9)) {
        year_tag <- tag_frequencies$tag[which.max(tag_frequencies$prop)]
        rows.tr <- which(x_merge$ris == year_tag)
        x_merge$bib[rows.tr] <- "year"
        x_merge$row_order[rows.tr] <- 3
      }
    }
  }
  if (any(x_merge$bib == "author")) {
    lookup.tags <- xtabs(~x_merge$ris[which(x_merge$bib ==
                                              "author")])
    if (length(lookup.tags) > 1) {
      replace_tags <- names(which(lookup.tags < max(lookup.tags)))
      replace_rows <- which(x_merge$ris %in% replace_tags)
      x_merge$bib[replace_rows] <- x_merge$ris[replace_rows]
      if (all(is.na(x_merge$row_order))) {
        start_val <- 0
      }
      else {
        start_val <- max(x_merge$row_order, na.rm = TRUE)
      }
      x_merge$row_order[replace_rows] <- start_val + as.numeric(as.factor(x_merge$ris[replace_rows]))
    }
  }
  x_split <- split(x_merge[c("bib", "ris", "text", "row_order")],
                   x_merge$ref)
  x_final <- lapply(x_split, function(a) {
    result <- split(a$text, a$bib)
    if (any(names(result) == "year")) {
      if (any(nchar(result$year) >= 4)) {
        year_check <- regexpr("\\d{4}", result$year)
        if (any(year_check > 0)) {
          result$year <- substr(x = result$year[which(year_check >
                                                        0)], start = year_check[1], stop = year_check[1] +
                                  3)
        }
        else {
          result$year <- ""
        }
      }
      else {
        result$year <- ""
      }
    }
    if (any(names(result) == "title")) {
      if (length(result$title) > 1) {
        if (result$title[1] == result$title[2]) {
          result$title <- result$title[1]
        }
        else {
          result$title <- paste(result$title, collapse = " ")
        }
      }
      result$title <- gsub("\\s+", " ", result$title)
      result$title <- sub("\\.$", "", result$title)
    }
    if (any(names(result) == "journal")) {
      unique_journals <- unique(result$journal)
      if (length(unique_journals) > 1) {
        unique_journals <- unique_journals[order(nchar(unique_journals),
                                                 decreasing = FALSE)]
        result$journal <- unique_journals[1]
        result$journal_secondary <- paste(unique_journals[c(2:length(unique_journals))],
                                          collapse = "; ")
      }
      else {
        result$journal <- unique_journals
      }
      result$journal <- gsub("  ", " ", result$journal)
      result$journal <- sub("\\.$", "", result$journal)
    }
    if (length(result$abstract > 1)) {
      result$abstract <- paste(result$abstract, collapse = " ")
      result$abstract <- gsub("\\s+", " ", result$abstract)
    }
    if (any(names(result) == "pages")) {
      if (length(result$pages) > 1) {
        result$pages <- paste(sort(result$pages), collapse = "-")
      }
    }
    entry_order <- unlist(lapply(names(result), function(b,
                                                         initial) {
      initial$row_order[which(a$bib == b)[1]]
    }, initial = a))
    final_result <- result[order(entry_order)]
    return(final_result)
  })
  names(x_final) <- generate_bibliographic_names(x_final)
  class(x_final) <- "bibliography"
  return(x_final)
}
