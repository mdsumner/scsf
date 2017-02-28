context("primitives")

#
# test_that("primitives 0D", {
#   error("no tests!")
# })
test_that("primitives 1D", {
  # inlandwaters[5, ] 
  minimal_mesh %>% PRIMITIVE() %>% expect_s3_class("PRIMITIVE") %>% 
   ## test round-trip back to sf
   sf() %>% expect_s3_class("sf") %>% PRIMITIVE() %>% sf() %>% expect_s3_class("sf")
  
  
})

#library(maptools)
#data(wrld_simpl)
#nodes <- arc_node(PRIMITIVE(st_as_sf(wrld_simpl)))


# 
# test_that("primitives 2D", {
#   error("no tests!")
# })
# test_that("primitives 3D", {
#   error("no tests!")
# })
