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

