
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/mdsumner/scsf.svg?branch=master)](https://travis-ci.org/mdsumner/scsf) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/mdsumner/scsf?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/scsf) [![Coverage Status](https://img.shields.io/codecov/c/github/mdsumner/scsf/master.svg)](https://codecov.io/github/mdsumner/scsf?branch=master)

scsf
====

Convert simple features to a generic common form that is more general and can be used for a wide variety of data structures.

This is *work in progress* and at a very early stage. More to come.

Example - sf to ggplot2 round trip
----------------------------------

``` r
library(sf)
#> Linking to GEOS 3.5.1, GDAL 2.2.1, proj.4 4.9.3
## a MULTIPOLYGON layer
nc = st_read(system.file("shape/nc.shp", package="sf"))
#> Reading layer `nc' from data source `/perm_storage/home/mdsumner/R/x86_64-pc-linux-gnu-library/3.4/sf/shape/nc.shp' using driver `ESRI Shapefile'
#> Simple feature collection with 100 features and 14 fields
#> geometry type:  MULTIPOLYGON
#> dimension:      XY
#> bbox:           xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
#> epsg (SRID):    4267
#> proj4string:    +proj=longlat +datum=NAD27 +no_defs
```

The common form is the entity tables, objects, paths, vertices and a link table to allow de-duplication of shared vertices. Currently this de-duplication is done on all coordinate fields, but for most applications it will usually be done only in X-Y.

``` r
library(scsf)
#> Loading required package: sc
#> 
#> Attaching package: 'scsf'
#> The following object is masked from 'package:sc':
#> 
#>     minimal_mesh
nc = st_read(system.file("gpkg/nc.gpkg", package="sf"))
#> Reading layer `nc.gpkg' from data source `/perm_storage/home/mdsumner/R/x86_64-pc-linux-gnu-library/3.4/sf/gpkg/nc.gpkg' using driver `GPKG'
#> Simple feature collection with 100 features and 14 fields
#> geometry type:  MULTIPOLYGON
#> dimension:      XY
#> bbox:           xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
#> epsg (SRID):    4267
#> proj4string:    +proj=longlat +datum=NAD27 +no_defs


(bmodel <- PATH(nc))
#> $object
#> # A tibble: 100 x 15
#>     AREA PERIMETER CNTY_ CNTY_ID        NAME   FIPS FIPSNO CRESS_ID BIR74
#>  * <dbl>     <dbl> <dbl>   <dbl>      <fctr> <fctr>  <dbl>    <int> <dbl>
#>  1 0.114     1.442  1825    1825        Ashe  37009  37009        5  1091
#>  2 0.061     1.231  1827    1827   Alleghany  37005  37005        3   487
#>  3 0.143     1.630  1828    1828       Surry  37171  37171       86  3188
#>  4 0.070     2.968  1831    1831   Currituck  37053  37053       27   508
#>  5 0.153     2.206  1832    1832 Northampton  37131  37131       66  1421
#>  6 0.097     1.670  1833    1833    Hertford  37091  37091       46  1452
#>  7 0.062     1.547  1834    1834      Camden  37029  37029       15   286
#>  8 0.091     1.284  1835    1835       Gates  37073  37073       37   420
#>  9 0.118     1.421  1836    1836      Warren  37185  37185       93   968
#> 10 0.124     1.428  1837    1837      Stokes  37169  37169       85  1612
#> # ... with 90 more rows, and 6 more variables: SID74 <dbl>, NWBIR74 <dbl>,
#> #   BIR79 <dbl>, SID79 <dbl>, NWBIR79 <dbl>, object <chr>
#> 
#> $path
#> # A tibble: 108 x 6
#>     ncol         type subobject   object     path ncoords_
#>    <int>        <chr>     <int>    <chr>    <chr>    <int>
#>  1     2 MULTIPOLYGON         1 7bd00c9e 44a103a7       27
#>  2     2 MULTIPOLYGON         1 5f37096a 7a6067fc       26
#>  3     2 MULTIPOLYGON         1 5db6ca83 b2a4fa3f       28
#>  4     2 MULTIPOLYGON         1 161e4449 23e051d0       26
#>  5     2 MULTIPOLYGON         2 161e4449 b502a692        7
#>  6     2 MULTIPOLYGON         3 161e4449 1a88a667        5
#>  7     2 MULTIPOLYGON         1 8a5abd8f e2e33acb       34
#>  8     2 MULTIPOLYGON         1 cb288810 eb4bb191       22
#>  9     2 MULTIPOLYGON         1 a1113ca9 59226caa       24
#> 10     2 MULTIPOLYGON         1 c115cb1f d58f97a6       17
#> # ... with 98 more rows
#> 
#> $vertex
#> # A tibble: 1,255 x 3
#>           x_       y_  vertex_
#>        <dbl>    <dbl>    <chr>
#>  1 -81.47276 36.23436 70bb0a50
#>  2 -81.54084 36.27251 206bd287
#>  3 -81.56198 36.27359 ea7b6cc8
#>  4 -81.63306 36.34069 d67d84d7
#>  5 -81.74107 36.39178 6d288061
#>  6 -81.69828 36.47178 247b4cb6
#>  7 -81.70280 36.51934 e0dd0299
#>  8 -81.67000 36.58965 c2310979
#>  9 -81.34530 36.57286 f31060df
#> 10 -81.34754 36.53791 6d03b30d
#> # ... with 1,245 more rows
#> 
#> $path_link_vertex
#> # A tibble: 2,529 x 2
#>        path  vertex_
#>       <chr>    <chr>
#>  1 44a103a7 70bb0a50
#>  2 44a103a7 206bd287
#>  3 44a103a7 ea7b6cc8
#>  4 44a103a7 d67d84d7
#>  5 44a103a7 6d288061
#>  6 44a103a7 247b4cb6
#>  7 44a103a7 e0dd0299
#>  8 44a103a7 c2310979
#>  9 44a103a7 f31060df
#> 10 44a103a7 6d03b30d
#> # ... with 2,519 more rows
#> 
#> attr(,"class")
#> [1] "PATH" "sc"  
#> attr(,"join_ramp")
#> [1] "object"           "path"             "path_link_vertex"
#> [4] "vertex"
```

Prove that things work by round-tripping to the PATH model and onto the old fortify approach for `ggplot2`.

``` r
inner_cascade <- function(x) {
  tabnames <- sc:::join_ramp(x)
  tab <- x[[tabnames[1]]]
  for (ni in tabnames[-1L]) tab <- dplyr::inner_join(tab, x[[ni]])
  tab
}

## this just joins everything back together in one big fortify table
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
tab <- bmodel  %>% inner_cascade()
#> Joining, by = "object"
#> Joining, by = "path"
#> Joining, by = "vertex_"

library(ggplot2)
ggplot(tab) + aes(x = x_, y = y_, group = path) + 
  geom_polygon(aes(fill = AREA)) +  geom_path(lwd = 2, col = "black") 
```

![](README-unnamed-chunk-4-1.png)

What about polygons with holes and lots of tiny complicated parts.

``` r
data("inlandwaters")

iw <- PATH(inlandwaters)

str(iw)
#> List of 4
#>  $ object          :Classes 'tbl_df', 'tbl' and 'data.frame':    6 obs. of  3 variables:
#>   ..$ ID      : int [1:6] 103841 103842 103843 103846 103847 103848
#>   ..$ Province: chr [1:6] "Australian Capital Territory" "New Caledonia" "New South Wales" "South Australia" ...
#>   ..$ object  : chr [1:6] "b2f43348" "7dda9a78" "9b4ac03d" "353b9b72" ...
#>   ..- attr(*, "sf_column")= chr "geom"
#>   ..- attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA
#>   .. ..- attr(*, "names")= chr [1:2] "ID" "Province"
#>  $ path            :Classes 'tbl_df', 'tbl' and 'data.frame':    189 obs. of  6 variables:
#>   ..$ ncol     : int [1:189] 2 2 2 2 2 2 2 2 2 2 ...
#>   ..$ type     : chr [1:189] "MULTIPOLYGON" "MULTIPOLYGON" "MULTIPOLYGON" "MULTIPOLYGON" ...
#>   ..$ subobject: int [1:189] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ object   : chr [1:189] "b2f43348" "7dda9a78" "9b4ac03d" "9b4ac03d" ...
#>   ..$ path     : chr [1:189] "3340cf07" "a4246dd6" "283d3358" "467a50a3" ...
#>   ..$ ncoords_ : int [1:189] 280 27 7310 68 280 88 162 119 51 71 ...
#>  $ vertex          :Classes 'tbl_df', 'tbl' and 'data.frame':    30835 obs. of  3 variables:
#>   ..$ x_     : num [1:30835] 1116371 1117093 1117172 1117741 1117629 ...
#>   ..$ y_     : num [1:30835] -458419 -457111 -456893 -456561 -455510 ...
#>   ..$ vertex_: chr [1:30835] "7a07207b" "70c33671" "686dffb7" "12afa9b7" ...
#>  $ path_link_vertex:Classes 'tbl_df', 'tbl' and 'data.frame':    33644 obs. of  2 variables:
#>   ..$ path   : chr [1:33644] "3340cf07" "3340cf07" "3340cf07" "3340cf07" ...
#>   ..$ vertex_: chr [1:33644] "7a07207b" "70c33671" "686dffb7" "12afa9b7" ...
#>  - attr(*, "class")= chr [1:2] "PATH" "sc"
#>  - attr(*, "join_ramp")= chr [1:4] "object" "path" "path_link_vertex" "vertex"

tab <- iw  %>% inner_cascade()
#> Joining, by = "object"
#> Joining, by = "path"
#> Joining, by = "vertex_"

library(ggplot2)
ggplot(tab) + aes(x = x_, y = y_, group = path) + 
  ggpolypath::geom_polypath(aes(fill = Province)) +  geom_path(col = "black") 
```

![](README-unnamed-chunk-5-1.png)

``` r

ggplot(tab %>% filter(Province == "South Australia")) + aes(x = x_, y = y_, group = path) + 
  ggpolypath::geom_polypath(fill = "dodgerblue") +  geom_path(col = "black") + coord_fixed()
```

![](README-unnamed-chunk-5-2.png)
