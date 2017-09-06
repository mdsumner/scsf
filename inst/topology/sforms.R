## demonstrate round-trip of sc_coord/sc_path/sc_object
## same pattern works for spatstat, sp - can build sf from these, and vice versa

## examples are minimal mesh, ellie, hawaii

## demo 1: decompose to sc intermediates and rebuild

decompose_sc <- function(x) {
  list(coord = sc_coord(x), 
       path = sc_path(x), 
       object = sc_object(x))
}

library(sc)
library(scsf)
library(dplyr)
## minimal_mesh is a simple 2-feature multipolygon sf
ints <- decompose_sc(minimal_mesh)
plot(build_sf(ints$path, ints$coord), col = "grey")

ints <- decompose_sc(st_cast(minimal_mesh, "MULTILINESTRING"))
plot(build_sf(ints$path, ints$coord), 
     col = viridis::viridis(nrow(ints$object)), lwd = rev(seq_len(nrow(ints$object)))*3)

ints <- decompose_sc(st_cast(minimal_mesh, "MULTIPOINT"))
plot(build_sf(ints$path, ints$coord), 
     col = viridis::viridis(nrow(ints$object)), cex = seq_len(nrow(ints$object)))


ints <- decompose_sc(inlandwaters)
plot(build_sf(ints$path, ints$coord), 
     col = viridis::viridis(nrow(ints$object)), cex = seq_len(nrow(ints$object)))

rep_id <- function(n, reper) rep(seq_len(n), reper)
library(ggplot2)
## diy fortify
ints <- decompose_sc(minimal_mesh)
subreps <- rep_id(nrow(ints$path), ints$path$ncoords_)
ggtab <- ints$coord %>% 
  mutate(group = subreps, 
         id = rep(ints$path$object, ints$path$ncoords_))


decompose_gg <- function(x)
##' build sf
##'
##' @param gm a gibble, geom map
##' @param vertex_pool the vertices to use, described by the gibble geom map `gm``
build_sf <- function(gm, coords_in, crs = NULL) {
  glist <- vector("list", length(unique(gm$object)))
  coords_in <- gm %>% dplyr::select(-type, -ncol, -ncoords_) %>%
    dplyr::slice(rep(seq_len(nrow(gm)), gm$ncoords_)) %>% bind_cols(coords_in)
  ufeature <- unique(gm$object)
  for (ifeature in seq_along(ufeature)) {
    gm0 <- gm %>% dplyr::filter(object == ufeature[ifeature])
    type <- gm0$type[1]
    coord0 <- coords_in %>% dplyr::filter(object == ifeature)
    ## object becomes sub-feature element (not a hole, that is "part")
    coord0$object <- rep(seq_len(nrow(gm0)), gm0$ncoords_)
    glist[[ifeature]] <- switch(type,
                                POINT = sf::st_point(unlist(coord0 %>% dplyr::select(x_, y_))),
                                MULTIPOINT = sf::st_multipoint(as.matrix(coord0 %>% dplyr::select(x_, y_))),
                                LINESTRING = sf::st_linestring(as.matrix(coord0 %>% dplyr::select(x_, y_))),
                                MULTILINESTRING = sf::st_multilinestring(lapply(split(coord0 %>% dplyr::select(x_, y_), coord0$path_), as.matrix)),
                                POLYGON = sf::st_polygon(lapply(split(coord0 %>% dplyr::select(x_, y_), coord0$path_), as.matrix)),
                                MULTIPOLYGON = sf::st_multipolygon(lapply(split(coord0 %>% dplyr::select(x_, y_, path_), coord0$subobject),
                                                                          function(part) lapply(split(part %>% select(x_, y_), part$path_), as.matrix)))
    )
  }
   if (is.null(crs)) crs <- sf::NA_crs_
  out <-   sf::st_sfc(glist, crs = crs)
  out
}

build_sf_multipolygon <- function(x, gdim = "XY") {
  
}
prepare_sf_ct <- function(x) {
  tabs <- sc::PRIMITIVE(x)
  
  segment <-  tibble::tibble(vertex_ = c(t(as.matrix(tabs$segment %>% 
    dplyr::select(.vertex0, .vertex1))))) %>%
    dplyr::inner_join(tabs$vertex %>% 
    dplyr::mutate(vertex = row_number() - 1)) %>% 
    dplyr::mutate(segment = (row_number() + 1) %/% 2)
  segs <- split(segment$vertex, segment$segment)
  
  list(coords = cbind(tabs$vertex$x_, tabs$vertex$y_), segs = distinct_uord_segments(segs))
}

distinct_uord_segments <- function(segs) {
  x <- dplyr::distinct(tibble::as_tibble(do.call(rbind, segs)))
  usort <- do.call(rbind, lapply(segs, sort))
  bad <- duplicated(usort)
  x <- x[!bad, ]
  lapply(split(x, seq_len(nrow(x))), unlist)
}

st_line_from_segment <- function(segs, coords) {
  sf::st_sfc(lapply(segs, function(a) sf::st_linestring(coords[a + 1, ])))
}

build_triangles <- function(coords, segments, ...) {
  RTriangle::triangulate(RTriangle::pslg(P = coords,S = do.call(rbind, segments)+1 ), ...)
}
library(dplyr)
library(scsf)
psf <- prepare_sf_ct(rmapshaper::ms_simplify(rnaturalearth::ne_countries(returnclass = "sf")))
#data("wrld_simpl", package = "maptools")
library(sf)
#psf <- prepare_sf_ct(rmapshaper::ms_simplify(st_as_sf(wrld_simpl)))
tri <- build_triangles(psf$coords, psf$segs, a = 3)

library(rgl)
xyz <- proj4::ptransform(cbind(tri$P, 0) * pi/180, src.proj  = "+init=epsg:4326", 
                         dst.proj = "+proj=geocent")
dim(xyz)
rgl.clear()
rgl.triangles(xyz[t(tri$T), ])
rglwidget()


library(marmap)
data("hawaii", package = "marmap")
qm <- quadmesh::quadmesh(raster::aggregate(as.raster(hawaii), fact = 5))
qm$vb[1:2, ] <- t(proj4::project(t(qm$vb[1:2, ]), "+proj=laea +lon_0=180"))
rgl.clear()
shade3d(qm, col = "white")
aspect3d(1, 1, .5)
axes3d()
rglwidget()

library(gibble)
nc <- read_sf(system.file("shape/nc.shp", package="sf"))
nc_gmap <- gibble(nc)
library(dplyr)
coords <- sf::st_coordinates(nc) %>% as_tibble() %>% dplyr::transmute(x_ = X, y_ = Y)
anc <- build_sf(nc_gmap, coords, crs = st_crs(nc))
anc