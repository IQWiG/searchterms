read_bibliography<- function (filename, return_df = TRUE)
{
  z <- tryCatch({
    scan(filename, sep = "\t", what = "character", quote = "",
         quiet = TRUE, blank.lines.skip = FALSE)
  }, warning = function(w) {
    stop("file import failed: data type not recognized by read_bibliography",
         call. = FALSE)
  }, error = function(e) {
    stop("file import failed: data type not recognized by read_bibliography",
         call. = FALSE)
  })
  Encoding(z) <- "UTF-8"
  nrows <- min(c(200, length(z)))
  zsub <- z[seq_len(nrows)]
  tag_type <- "ris"
  z_dframe <- prep_ris(z, detect_delimiter(zsub))
  if (any(z_dframe$ris == "PMID")) {
    result <- read_medline(z_dframe)
  }
  else {
    result <- read_ris(z_dframe, tag_type)
  }
  if (return_df) {
    result <- as.data.frame(result)
  }

  return(result)
}
