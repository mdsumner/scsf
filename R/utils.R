faster_as_tibble <- function(x) {
  if (is.matrix(x)) x <- split(as.vector(x), rep(seq_len(ncol(x)), each = nrow(x)))
  structure(x, row.names = seq_along(x[[1]]), class = c("tbl_df", "tbl", "data.frame"))
}
