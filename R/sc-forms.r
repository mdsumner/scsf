#' ## is this the right way to share a generic with the base
#' ## package? Probably should just Depends sc?
#' #' @name sc_coord.sf
#' #' @export
#' #' @importFrom sc sc_coord
#' sc_coord <- function(x, ...) {
#'   sc::sc_coord(x, ...)
#' }
#' 
#' #' @name sc_object.sf
#' #' @export
#' #' @importFrom sc sc_object
#' sc_object <- function(x, ...) {
#'   sc::sc_object(x, ...)
#' }
#' 
#' #' @name sc_path.sf
#' #' @export
#' #' @importFrom sc sc_path
#' sc_path <- function(x, ...) {
#'   sc::sc_path(x, ...)
#' }
#' 
#' #' PATH model
#' #' @param x input path
#' #' @param ... arguments to methods
#' #' @name PATH
#' #' @export
#' #' @importFrom sc PATH
#' PATH <- function(x, ...) {
#'   sc::PATH(x, ...)
#' }
#' 
#' #' PRIMITIVE model. 
#' #' @param x input object
#' #' @param ... arguments to methods
#' #' @name PRIMITIVE.sf
#' #' @export
#' #' @importFrom sc PRIMITIVE
#' PRIMITIVE <- function(x, ...) {
#'   sc::PRIMITIVE(x, ...)
#' }
