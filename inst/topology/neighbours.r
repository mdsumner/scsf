library(tidyverse)
library(sf)
library(scsf)
nc = st_read(system.file("shape/nc.shp", package="sf"), quiet = TRUE)
x <- PRIMITIVE(nc)


## this function uniquifies the segments, very much WIP
u_edges <- function(x, ...) UseMethod("u_edges")
u_edges.PRIMITIVE <- function(x, ...) {
  u_edges(x[["segment"]])
}
u_edges.data.frame <- function(x, ...) {
  u2 <- x %>%         mutate(uu = paste(pmin(.vertex0, .vertex1), pmax(.vertex0, .vertex1), sep = "_"))
  #dplyr::distinct(select(u2, uu, segment_), uu,  .keep_all = TRUE)
  select(u2, uu, segment_)
}


set.seed(100)
nc$colour <- sample(viridis::viridis(100))

## filter to the ith
for (ith in seq_len(nrow(nc))) {
  xith <- x$object[ith, "object_"] %>% inner_join(x$path, "object_") %>% 
    inner_join(x$path_link_vertex, "path_") %>% 
    inner_join(x$vertex, "vertex_")
  
  ## join by vertex 
  idx_vertex <- xith %>% dplyr::select(vertex_) %>% 
    inner_join(x$path_link_vertex, "vertex_") %>% 
    inner_join(x$path, "path_") %>% 
    distinct(object_) ##%>% inner_join(nc %>% mutate(object_ = x$object_))
  v_idx <- match(idx_vertex$object_, x$object$object_)
  
  
  ## join the subset data to the main on unique segment 
  ## (unique as in order of vertices is irrelevant)
  idx_edge <- u_edges.data.frame(x$object[ith, "object_"] %>% 
                                   inner_join(x$path, "object_") %>% 
                                   inner_join(x$segment, "path_")) %>%  
    select(-segment_) %>% inner_join(u_edges.PRIMITIVE(x), "uu") %>% 
    inner_join(x$segment, "segment_") %>% inner_join(x$path, "path_") %>% 
    distinct(object_)
  e_idx <- match(idx_edge$object_, x$object$object_)
  
  if (!length(e_idx) == length(v_idx)) {
    par(mfrow = c(3, 1), mar = c(rep(0.75, 4)))
    
    # Target county
    plot(nc[1], col = "firebrick", main = "Target county")
    plot(nc[ith, 1], add = TRUE, col = nc$colour[ith])
    
    plot(nc[, 1], col = "firebrick", main = "Edge share"); plot(nc[e_idx, 1], add = TRUE, col = nc$colour[e_idx])
    plot(nc[, 1], col = "firebrick", main = "Vertex share"); plot(nc[v_idx, 1], add = TRUE, col = nc$colour[v_idx])
    print(v_idx)
    print(e_idx)
  }
}
