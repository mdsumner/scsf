#' @name arc_node
#' @importFrom sc arc_node
#' @export
#' @examples
#' x <- sf::st_read(system.file("extdata/file.geojson", package= "sc"))
#' arc_node(x)  ## get the nodes
#' ## now get the arcs (should the functions be called arc() and node()?)

arc_node.sf <- function(x, ...) {
  arc_node(PRIMITIVE(x))
}


#' Recompose `sf` simple features from `PRIMITIVE`` models. 
#'
#' @param x input object
#' @param ... arguments passed to methods
#'
#' @return `PRIMITIVE`
#' @export
#'
#' @examples
#' prim <- PRIMITIVE(inlandwaters)
#' library(sf)
#' plot(st_as_sf(prim))
#' @importFrom sf st_as_sf st_multipolygon st_sfc 
#' @importFrom dplyr select_ inner_join %>% 
st_as_sf.PRIMITIVE <- function(x, ...) {
  ol <- vector("list", nrow(x$object))
  for (i_obj in seq(nrow(x$object))) {
   path <- x$object[i_obj, ] %>% dplyr::select_("object_") %>% 
     inner_join(x$path, "object_") 
   brl <- vector("list", nrow(path))
    for (i_br in seq(nrow(path))) {
    #  br_0 <- path[i_br, ] %>% 
     #inner_join(x$path_link_vertex) %>% 
     #inner_join(x$vertex) %>% 
     #split(.$island_)
      br_0 <-   inner_join(inner_join(path[i_br, ], x[["path_link_vertex"]], "path_"), x[["vertex"]], "vertex_")
      br_0 <- split(br_0, br_0[["island_"]])
      ## not getting holes properly
     brl[[i_br]] <- lapply(br_0, function(aa) as.matrix(aa[c(seq_len(nrow(aa)), 1L), c("x_", "y_")]))
    }
   ## slow, need to class all the structure without going through sf checks
   ol[[i_obj]] <- sf::st_multipolygon(brl)
  }
  ## TODO: need round-trip crs
  sfd <- as.data.frame(x$object)
  sfd[["geometry"]] <- sf::st_sfc(ol)
  sf::st_as_sf(sfd)
}