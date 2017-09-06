
#' @importFrom purrr map_df
sc_atom <- function(x, ...) faster_as_tibble(list(ncoords_= nrow(x), path = sc_uid()))
sc_list <- function(x) {
  dplyr::bind_rows(lapply(x, sc_atom))
}
#sc_atom <- function(x, ...) UseMethod("sc_atom")
#sc_atom.matrix <- function(x, ...) cbind(nrow(x), ncol(x))
#sc_atom.list <- function(x, ...) lapply(x, sc_atom)
#sc_atom_mat <- function(x, ...) nrow(x)
#sc_list_mat <- function(x) unlist(lapply(x, sc_atom_mat))

#' Common path forms. 
#' 
#' Paths. 
#' 
#' @param x simple features object
#' @param ... arguments to methods
#' @importFrom sc sc_path sc_uid
#' @name sc_path
#' @export
#' @export sc_path
#' @examples
#' library(scsf)
#' #sf_dataset <- sf::st_sf(geometry = sf::st_sfc(sfzoo[[2]]), a = 1)
#' #PATH(sf_dataset)
#' #sc_path(sf::st_sfc(sfzoo))
sc_path.sf <- function(x, ...) {
  sc_path(.st_get_geometry(x), ...)
}

#' @param ids object id, one for each object in the `sfc`
#'
#' @importFrom dplyr bind_rows
#' @name sc_path
#' @export
#' @examples 
#' #sc_path(sf::st_sfc(sfzoo))
sc_path.sfc <- function(x, ids = NULL, ...) {
  x <- gibble::gibble(x)
  if (is.null(ids)) {
    ids <- sc::sc_uid(nrow(x))
  } else {
    ids <- ids[x[["object"]]]
  }
  x[["path"]] <- ids
  #dplyr::rename(x, island_ = rlang::.data$part, ncoords_ = rlang::.data$nrow)
  #x[["island_"]] <- x[["part"]]
  x[["ncoords_"]] <- x[["nrow"]]
  #x[["part"]] <- NULL
  x[["nrow"]] <- NULL
  x
}
#   ## TODO record this somehow for roundtripping
#   ## also have to know the class for the ncoord, ndim below
#   classes <- lapply(x, class)
#   
#   x <- lapply(x, sc_path)
#  # if (!is.null(ids)) {
# #    stopifnot(length(ids) == length(x))
# #    x <- lapply(seq_along(x), function(a) dplyr::bind_cols(x[[a]], faster_as_tibble(list(object_ = rep(ids[a], nrow(x[[a]]))))))
# #  }
#  tibble::as_tibble(structure(do.call(rbind, x), dimnames = c(list(NULL), list(c("ncoord", "ndim")))))

gibble_path <- function(x, ids = NULL, ...) {
  out <- gibble::gibble(x)
  if (is.null(ids)) {
    ids <- sc_uid(nrow(out))
  } else {
    ids <- ids[out[["object"]]]
  }
  dplyr::mutate(out, path = ids)
}

#' @name sc_path
#' @export
#' @importFrom dplyr bind_rows mutate row_number
#' @examples
#' sc_path(sfzoo$multipolygon)
sc_path.MULTIPOLYGON <- function(x, ...) {
  gibble_path(x)
}

#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$polygon)
sc_path.POLYGON <- function(x, ...) {
  gibble_path(x)
}
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$linestring)
sc_path.LINESTRING <- function(x, ...) gibble_path(x)
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$multilinestring)
sc_path.MULTILINESTRING <- function(x, ...) gibble_path(x)
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$point)
sc_path.POINT <- function(x, ...) gibble_path(x)
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$multipoint)
sc_path.MULTIPOINT <- function(x, ...) gibble_path(x)
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$multipoint)
sc_path.GEOMETRYCOLLECTION <- function(x, ...) lapply(x, gibble_path)



