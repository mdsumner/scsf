
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/mdsumner/scsf.svg?branch=master)](https://travis-ci.org/mdsumner/scsf)

scsf
====

Convert simple features to a generic common form that is more general and can be used for a wide variety of data structures.

Example - sf to ggplot2 round trip
----------------------------------

``` r
library(sf)
#> Linking to GEOS 3.5.0, GDAL 2.1.1, proj.4 4.9.3
## a MULTIPOLYGON layer
nc = st_read(system.file("shape/nc.shp", package="sf"))
#> Reading layer `nc' from data source `C:\Users\michae_sum\R\win-library\3.3\sf\shape\nc.shp' using driver `ESRI Shapefile'
#> converted into: MULTIPOLYGON
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
nc = st_read(system.file("gpkg/nc.gpkg", package="sf"))
#> Reading layer `nc.gpkg' from data source `C:\Users\michae_sum\R\win-library\3.3\sf\gpkg\nc.gpkg' using driver `GPKG'
#> Simple feature collection with 100 features and 14 fields
#> geometry type:  MULTIPOLYGON
#> dimension:      XY
#> bbox:           xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
#> epsg (SRID):    4267
#> proj4string:    +proj=longlat +datum=NAD27 +no_defs


(bmodel <- PATH(nc))
#> $object
#> # A tibble: 100 × 15
#>     AREA PERIMETER CNTY_ CNTY_ID        NAME   FIPS FIPSNO CRESS_ID BIR74
#>    <dbl>     <dbl> <dbl>   <dbl>      <fctr> <fctr>  <dbl>    <int> <dbl>
#> 1  0.114     1.442  1825    1825        Ashe  37009  37009        5  1091
#> 2  0.061     1.231  1827    1827   Alleghany  37005  37005        3   487
#> 3  0.143     1.630  1828    1828       Surry  37171  37171       86  3188
#> 4  0.070     2.968  1831    1831   Currituck  37053  37053       27   508
#> 5  0.153     2.206  1832    1832 Northampton  37131  37131       66  1421
#> 6  0.097     1.670  1833    1833    Hertford  37091  37091       46  1452
#> 7  0.062     1.547  1834    1834      Camden  37029  37029       15   286
#> 8  0.091     1.284  1835    1835       Gates  37073  37073       37   420
#> 9  0.118     1.421  1836    1836      Warren  37185  37185       93   968
#> 10 0.124     1.428  1837    1837      Stokes  37169  37169       85  1612
#> # ... with 90 more rows, and 6 more variables: SID74 <dbl>, NWBIR74 <dbl>,
#> #   BIR79 <dbl>, SID79 <dbl>, NWBIR79 <dbl>, object_ <chr>
#> 
#> $path
#> # A tibble: 108 × 4
#>    island_ ncoords_    path_  object_
#>      <chr>    <int>    <chr>    <chr>
#> 1        1       27 80af8919 898944a6
#> 2        1       26 3b895eaf 2636006c
#> 3        1       28 9f7b63e3 b5662b92
#> 4        1       26 20ee1544 16ecdc45
#> 5        2        7 417989fd 16ecdc45
#> 6        3        5 11f25722 16ecdc45
#> 7        1       34 760143e7 33c5c04e
#> 8        1       22 ed6f1a29 106e3dee
#> 9        1       24 a3daa5ff 5c268710
#> 10       1       17 83095490 c22d0001
#> # ... with 98 more rows
#> 
#> $vertex
#> # A tibble: 1,255 × 3
#>           x_       y_  vertex_
#>        <dbl>    <dbl>    <chr>
#> 1  -81.47276 36.23436 4b55fdbc
#> 2  -81.54084 36.27251 84993f22
#> 3  -81.56198 36.27359 f7bfaeba
#> 4  -81.63306 36.34069 c634b0eb
#> 5  -81.74107 36.39178 ccfbf8df
#> 6  -81.69828 36.47178 7dfed5b1
#> 7  -81.70280 36.51934 ca12ff1b
#> 8  -81.67000 36.58965 dd152802
#> 9  -81.34530 36.57286 e683edb7
#> 10 -81.34754 36.53791 004c0f94
#> # ... with 1,245 more rows
#> 
#> $path_link_vertex
#> # A tibble: 2,529 × 2
#>       path_  vertex_
#>       <chr>    <chr>
#> 1  80af8919 4b55fdbc
#> 2  80af8919 84993f22
#> 3  80af8919 f7bfaeba
#> 4  80af8919 c634b0eb
#> 5  80af8919 ccfbf8df
#> 6  80af8919 7dfed5b1
#> 7  80af8919 ca12ff1b
#> 8  80af8919 dd152802
#> 9  80af8919 e683edb7
#> 10 80af8919 004c0f94
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
#> Joining, by = "object_"
#> Joining, by = "path_"
#> Joining, by = "vertex_"

library(ggplot2)
ggplot(tab) + aes(x = x_, y = y_, group = path_) + 
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
#>   ..$ object_ : chr [1:6] "2025cb92" "194d0089" "f341c142" "e0eaa240" ...
#>   ..- attr(*, "sf_column")= chr "geom"
#>   ..- attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA
#>   .. ..- attr(*, "names")= chr [1:2] "ID" "Province"
#>  $ path            :Classes 'tbl_df', 'tbl' and 'data.frame':    189 obs. of  4 variables:
#>   ..$ island_ : chr [1:189] "1" "1" "1" "1" ...
#>   ..$ ncoords_: int [1:189] 280 27 7310 68 280 88 162 119 51 71 ...
#>   ..$ path_   : chr [1:189] "32a7c22f" "f27eb028" "df7bd6c9" "02530d7f" ...
#>   ..$ object_ : chr [1:189] "2025cb92" "194d0089" "f341c142" "f341c142" ...
#>  $ vertex          :Classes 'tbl_df', 'tbl' and 'data.frame':    30835 obs. of  3 variables:
#>   ..$ x_     : num [1:30835] 1116371 1117093 1117172 1117741 1117629 ...
#>   ..$ y_     : num [1:30835] -458419 -457111 -456893 -456561 -455510 ...
#>   ..$ vertex_: chr [1:30835] "dd644cd9" "0970f925" "4691d8f4" "013260ca" ...
#>  $ path_link_vertex:Classes 'tbl_df', 'tbl' and 'data.frame':    33644 obs. of  2 variables:
#>   ..$ path_  : chr [1:33644] "32a7c22f" "32a7c22f" "32a7c22f" "32a7c22f" ...
#>   ..$ vertex_: chr [1:33644] "dd644cd9" "0970f925" "4691d8f4" "013260ca" ...
#>  - attr(*, "class")= chr [1:2] "PATH" "sc"
#>  - attr(*, "join_ramp")= chr [1:4] "object" "path" "path_link_vertex" "vertex"

tab <- iw  %>% inner_cascade()
#> Joining, by = "object_"
#> Joining, by = "path_"
#> Joining, by = "vertex_"

library(ggplot2)
ggplot(tab) + aes(x = x_, y = y_, group = path_) + 
  ggpolypath::geom_polypath(aes(fill = Province)) +  geom_path(col = "black") 
```

![](README-unnamed-chunk-5-1.png)

``` r

ggplot(tab %>% filter(Province == "South Australia")) + aes(x = x_, y = y_, group = path_) + 
  ggpolypath::geom_polypath(fill = "dodgerblue") +  geom_path(col = "black") + coord_fixed()
```

![](README-unnamed-chunk-5-2.png)
