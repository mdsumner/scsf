#' Arc node topology for simple features. 
#' @name sc_node
#' @param x input simple features object
#' @param ... arguments for methods
#' @importFrom sc sc_node PRIMITIVE
#' @export
#' @examples
#'# x <- sf::st_read(system.file("extdata/file.geojson", package= "sc"))
#' #sc_node(x)  ## get the nodes
#' ## now get the arcs (should the functions be called arc() and node()?)

sc_node.sf <- function(x, ...) {
  stop("sc_node mehod for sf is not yet supported")
  sc_node(sc::PRIMITIVE(x))
}


#' Recompose `sf` simple features from `PRIMITIVE`` models. 
#' 
#' @param x input object
#' @param ... arguments passed to methods
#'
#' @return `PRIMITIVE`
#' 
#' @examples
#' prim <- PRIMITIVE(inlandwaters)
#' library(sf)
#' \donttest{
#' \dontrun{
#' plot(sf(prim))
#' }
#' }
#' @importFrom dplyr select_ inner_join %>% 
#' @name sf
#' @export
sf <- function(x) UseMethod("sf")
#' @name sf
#' @export
sf.PRIMITIVE <- function(x, ...) {
  ol <- vector("list", nrow(x$object))
  for (i_obj in seq(nrow(x$object))) {
   path <- x$object[i_obj, ] %>% dplyr::select_("object_") %>% 
     inner_join(x$path, "object_") 
   brl <- vector("list", nrow(path))
    for (i_br in seq(nrow(path))) {
  # this all needs revisit based on what kind of simple feature we have
      br_0 <-   inner_join(inner_join(path[i_br, ], x[["path_link_vertex"]], "path_"), x[["vertex"]], "vertex_")
      br_0 <- split(br_0, br_0[["island_"]])

     brl[[i_br]] <- lapply(br_0, function(aa) as.matrix(aa[c(seq_len(nrow(aa)), 1L), c("x_", "y_")]))
    }
 
   ol[[i_obj]] <- structure(list(unlist(brl, recursive = FALSE)), class = c("XY", "MULTIPOLYGON", "sfg"))
  }
  bb <- c(range(x$vertex$x_), range(x$vertex$y_))[c(1, 3, 2, 4)]
  na_crs <- structure(list(epsg = NA_integer_, proj4string = NA_character_), class = "crs")
  names(bb) <- structure(c("xmin", "ymin", "xmax", "ymax"), crs = na_crs)
  ## TODO: need round-trip crs
  sfd <- faster_as_tibble(x$object)
  #sfd[["geometry"]] <- sf::st_sfc(ol)
  sfd[["geometry"]] <- structure(ol, class = c("sfc_MULTIPOLYGON", "sfc"  ), n_empty = 0, precision = 0, crs = na_crs, bbox = bb)
  structure(sfd, sf_column = "geometry", agr = factor(NA, c("constant", "aggregate", "identity")), class = c("sf", class(sfd)))
}
#' @name sf
#' @export
sf.PATH <- function(x, ...) {
  sf(PRIMITIVE(x))
}
## do we need this? doesn't st_as_sf do it above? 
## very early, slow
## literally build all the component linestrings, group by path and rebuild
## also needs to group by object to do this right
## probably this is better done by flipping back to PATH first
# sf2.PRIMITIVE <- function(x) {
#   # df <- sc_object(x)
#   g <-  x[["segment"]] %>% 
#     split(.$segment_) %>% 
#     purrr::map(function(segdf) {
#       dplyr::inner_join(segdf %>% dplyr::rename_(vertex_ = quote(.vertex0)), x[["vertex"]], "vertex_") %>% 
#         dplyr::transmute(x0 = x_, y0 = y_, vertex_ = .vertex1) %>% 
#         dplyr::inner_join(x[["vertex"]], "vertex_") %>% dplyr::select_("x0", "y0", "x_", "y_") %>% 
#         unlist() %>% 
#         matrix(ncol = 2)  %>%  t() %>% 
#         sf::st_linestring(dim = "XY")
#       
#     }
#     )
#   d <- x[["segment"]] %>% dplyr::select(path_)
#   d[["geometry"]] <- g[x[["segment"]][["segment_"]]]
#   d <- d %>% dplyr::group_by(path_) %>% tidyr::nest()
#   d[["geometry"]] <- d[["data"]] %>% purrr::map(function(x) sf::st_polygonize(st_union(st_geometrycollection(as.list(x$geometry)))))  %>% st_sfc()
#   
#   d[["data"]] <- NULL
#   st_as_sf(d)
# }