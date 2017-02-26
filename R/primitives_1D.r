#' Arc node topology for simple features. 
#' @name sc_node
#' @param x input simple features object
#' @param ... arguments for methods
#' @importFrom sc sc_node PRIMITIVE
#' @export
#' @examples
#' x <- sf::st_read(system.file("extdata/file.geojson", package= "sc"))
#' sc_node(x)  ## get the nodes
#' ## now get the arcs (should the functions be called arc() and node()?)

sc_node.sf <- function(x, ...) {
  sc_node(sc::PRIMITIVE(x))
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


sf <- function(x) UseMethod("sf")
sf.PRIMITIVE <- function(x) {
  # df <- sc_object(x)
  g <-  x[["segment"]] %>% 
    split(.$segment_) %>% 
    purrr::map(function(segdf) {
      dplyr::inner_join(segdf %>% dplyr::rename(vertex_ = .vertex0), x[["vertex"]], "vertex_") %>% 
        dplyr::transmute(x0 = x_, y0 = y_, vertex_ = .vertex1) %>% 
        dplyr::inner_join(x[["vertex"]], "vertex_") %>% dplyr::select(x0, y0, x_, y_) %>% 
        unlist() %>% 
        matrix(ncol = 2)  %>%  t() %>% 
        sf::st_linestring(dim = "XY")
      
    }
    )
  d <- x[["segment"]] %>% dplyr::select(path_)
  d[["geometry"]] <- g[x[["segment"]][["segment_"]]]
  d <- d %>% dplyr::group_by(path_) %>% tidyr::nest()
  d[["geometry"]] <- d[["data"]] %>% purrr::map(function(x) st_polygonize(st_union(st_geometrycollection(as.list(x$geometry)))))  %>% st_sfc()
  
  d[["data"]] <- NULL
  st_as_sf(d)
}