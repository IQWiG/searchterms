prep_ris <- function (z, delimiter)
{
  tags <- regexpr("^([[:upper:]]{2,4}|[[:upper:]]{1}[[:digit:]]{1})\\s{0,}-{0,2}\\s{0,}",
                  perl = TRUE, z)
  z_dframe <- data.frame(text = z, row = seq_along(z), match_length = attr(tags,
                                                                           "match.length"), stringsAsFactors = FALSE)
  z_list <- split(z_dframe, z_dframe$match_length)
  z_list <- lapply(z_list, function(a) {
    n <- a$match_length[1]
    if (n < 0) {
      result <- data.frame(ris = "", text = a$text, row_order = a$row,
                           stringsAsFactors = FALSE)
    }
    else {
      result <- data.frame(ris = sub("\\s{0,}-\\s{0,}|^\\s+|\\s+$",
                                     "", substr(a$text, 1, n)), text = gsub("^\\s+|\\s+$",
                                                                            "", substr(a$text, n + 1, nchar(a$text))), row_order = a$row,
                           stringsAsFactors = FALSE)
    }
    return(result)
  })
  z_dframe <- do.call(rbind, z_list)
  z_dframe <- z_dframe[order(z_dframe$row), ]
  if (delimiter == "character") {
    z_dframe$ris[which(unlist(lapply(strsplit(z, ""), function(a) {
      length(unique(a)) == 1 & length(a > 6)
    })))] <- "ER"
  }
  if (delimiter == "space") {
    z_dframe$ris[which(z_dframe$ris == "" & z_dframe$text ==
                         "")] <- "ER"
    z_rollsum <- rollingsum(z_dframe$ris == "ER")
    if (any(z_rollsum > 1)) {
      z_dframe <- z_dframe[which(z_rollsum <= 1), ]
    }
  }
  if (delimiter == "endrow") {
    z_dframe$ref <- c(0, cumsum(z_dframe$ris == "ER")[seq_len(nrow(z_dframe) -
                                                                1)])
    start_tags <- unlist(lapply(split(z_dframe$ris, z_dframe$ref),
                                function(a) {
                                  a[which(a != "")[1]]
                                }))
    start_tag <- names(which.max(xtabs(~start_tags)))
    row_df <- data.frame(start = which(z_dframe$ris == start_tag),
                         end = which(z_dframe$ris == "ER"))
    z_list <- apply(row_df, 1, function(a) {
      c(a[1]:a[2])
    })
    z_list <- lapply(z_list, function(a, lookup) {
      lookup[a, ]
    }, lookup = z_dframe)
    z_dframe <- as.data.frame(do.call(rbind, z_list))
  }
  z_dframe$ref <- c(0, cumsum(z_dframe$ris == "ER")[seq_len(nrow(z_dframe) -
                                                              1)])
  z_dframe <- z_dframe[which(z_dframe$text != ""), ]
  z_dframe <- z_dframe[which(z_dframe$ris != "ER"), ]
  z_dframe$text <- trimws(z_dframe$text)
  z_split <- split(z_dframe, z_dframe$ref)
  z_split <- lapply(z_split, function(a) {
    if (a$ris[1] == "") {
      a$ris[1] <- "ZZ"
    }
    accum_ris <- Reduce(c, a$ris, accumulate = TRUE)
    a$ris <- unlist(lapply(accum_ris, function(b) {
      good_vals <- which(b != "")
      b[good_vals[length(good_vals)]]
    }))
    return(a)
  })
  z_dframe <- as.data.frame(do.call(rbind, z_split))
  return(z_dframe)
}


detect_delimiter <- function (x)
{
  if (any(grepl("^ER", x))) {
    delimiter <- "endrow"
  }
  else {
    char_list <- strsplit(x, "")
    char_break_test <- unlist(lapply(char_list, function(a) {
      length(unique(a)) == 1 & length(a > 6)
    }))
    if (any(char_break_test)) {
      delimiter <- "character"
    }
    else {
      space_break_check <- unlist(lapply(char_list, function(a) {
        all(a == "" | a == " ")
      }))
      if (any(space_break_check)) {
        delimiter <- "space"
      }
      else {
        stop("import failed: unknown reference delimiter")
      }
    }
  }
  return(delimiter)
}

rollingsum <- function (a, n = 2L)
{
  tail(cumsum(a) - cumsum(c(rep(0, n), head(a, -n))), -n +
         1)
}
