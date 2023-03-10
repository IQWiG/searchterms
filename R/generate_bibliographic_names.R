generate_bibliographic_names <- function (x)
{
  nonunique_names <- unlist(lapply(x, function(a) {
    name_vector <- rep("", 3)
    if (any(names(a) == "author")) {
      name_vector[1] <- strsplit(a$author[1], ",")[[1]][1]
    }
    if (any(names(a) == "year")) {
      name_vector[2] <- a$year[1]
    }
    if (any(names(a) == "journal")) {
      journal_info <- strsplit(a$journal, " ")[[1]]
      name_vector[3] <- paste(substr(journal_info, 1, min(nchar(journal_info),
                                                          4)), collapse = "")
    }
    name_vector <- name_vector[which(name_vector != "")]
    if (length(name_vector) == 0) {
      return("ref")
    }
    else {
      return(paste(name_vector, collapse = "_"))
    }
  }))
  if (any(nonunique_names == "ref")) {
    rows_tr <- which(nonunique_names == "ref")
    nonunique_names[rows_tr] <- create_index("ref", length(rows_tr))
  }
  if (length(unique(nonunique_names)) < length(nonunique_names)) {
    nonunique_names <- make.unique(nonunique_names, sep = "_")
  }
  return(nonunique_names)
}

create_index <- function (string, n, sep = "_")
{
  if (missing(string)) {
    string <- "V"
  }
  if (missing(n)) {
    stop("n is missing from create_index with no default")
  }
  if (n < 1) {
    stop("n must be > 0 for create_index to function")
  }
  if (length(n) > 1) {
    n <- length(n)
  }
  size <- log10(n) + 1
  vector <- seq_len(n)
  return(paste(string, formatC(vector, width = size, format = "d",
                               flag = 0), sep = sep))
}
