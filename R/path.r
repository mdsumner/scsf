
#' @importFrom purrr map_df
sc_atom <- function(x, ...) faster_as_tibble(list(ncoords_= nrow(x), path_ = sc_uid()))
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
  x[["path_"]] <- sc::sc_uid(nrow(x))
  dplyr::rename(x, island_ = part, ncoords_ = nrow)
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
sc_path.MULTIPOINT <- function(x, ...) sc_atom(unclass(x))
#' @name sc_path
#' @export
#' @examples 
#' sc_path(sfzoo$multipoint)
sc_path.GEOMETRYCOLLECTION <- function(x, ...) lapply(x, sc_path)



