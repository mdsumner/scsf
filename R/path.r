
#' @importFrom tibble tibble
sc_atom <- function(x, ...) tibble::tibble(ncoords_= nrow(x), path_ = sc_uid())
sc_list <- function(x) dplyr::bind_rows(lapply(x, sc_atom))

## infix sugar for if (is.null)
"%||%" <- function(a, b) {
  if (is.null(a)) b else a
}

#' Common path forms. 
#' 
#' Paths. 
#' 
#' @param x simple features object
#' @param ... arguments to methods
#' @importFrom sc sc_path sc_uid
#' @importFrom sf st_geometry
#' @name sc_path
#' @export
#' @examples
#' library(scsf)
#' sf_dataset <- sf::st_sf(geometry = sf::st_sfc(sfzoo[[2]]), a = 1)
#' PATH(sf_dataset)
#' sc_path(sf::st_sfc(sfzoo))
sc_path.sf <- function(x, ...) {
  sc_path(sf::st_geometry(x), ...)
}

#' @param ids object id, one for each object in the `sfc`
#'
#' @importFrom dplyr bind_rows
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sf::st_sfc(sfzoo))
sc_path.sfc <- function(x, ids = NULL, ...) {
  x <- lapply(x, sc_path)
  if (!is.null(ids)) {
    stopifnot(length(ids) == length(x))
    x <- lapply(seq_along(x), function(a) dplyr::bind_cols(x[[a]], tibble::tibble(object_ = rep(ids[a], nrow(x[[a]])))))
  }
  dplyr::bind_rows(x)
}
#' @name sc_path
#' @export
#' @importFrom dplyr bind_rows mutate row_number
#' @examples
#' sc_path(sfzoo$multipolygon)
sc_path.MULTIPOLYGON <- function(x, ...) {
  dplyr::bind_rows(lapply(x, sc_list), .id = "island_") 
}
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$polygon)
sc_path.POLYGON <- function(x, ...) {
  sc_list(x)
}
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$linestring)
sc_path.LINESTRING <- sc_atom
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$multilinestring)
sc_path.MULTILINESTRING <- sc_path.POLYGON
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$point)
sc_path.POINT <- function(x, ...) sc_atom(matrix(x, nrow = 1L))
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$multipoint)
sc_path.MULTIPOINT <- function(x, ...) tibble::tibble(ncoords_ = 1, path_ = sc_uid(n = nrow(x)))
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$multipoint)
sc_path.GEOMETRYCOLLECTION <- function(x, ...) dplyr::bind_rows(lapply(x, sc_path), .id = "collection_")


## infix sugar for if (is.null)
"%||%" <- function(a, b) {
  if (is.null(a)) b else a
}
