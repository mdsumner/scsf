
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.com/mdsumner/sc.svg?branch=master)](https://travis-ci.com/mdsumner/sc)

sc
==

The goal of sc is to provide a general common form for complex multi-dimensional data.

See the [proposal.md](proposal.md).

Why?
====

Geographic Information System (GIS) tools provide data structures optimized for a relatively narrow class of workflows that leverage a combination of *spatial*, graphics, drawing-design, imagery, geodetic and database techniques. When modern GIS was born in the 1990s it adopted a set of compromises that divorced it from its roots in graph theory (arc-node topology) to provide the best performance for what were the most complicated sets of cartographic and land-management system data at the time.

The huge success of ArcView and the shapefile brought this arcane domain into common usage and helped establish our modern view of what "geo-spatial data" is. The creation of the "simple features standard"" in the early 2000s formalized this modern view and provided a basis to avoid some of the inconsistencies and incompleteness that are present in the shapefile specification.

Spatial, graphics, drawing-design, imagery, geodetic and database techniques are broader than any GIS, are used in combination in many fields, but no other field combines them in the way that GIS tools do. GIS does however impose a certain view point, a lens through which each of those very general fields is seen via the perspective of the optimizations, the careful constraints and compromises that were formalized in the early days.

This lens is seen side-on when 1) bringing graphics data (images, drawings) into a GIS where a localization metadata context is assumed 2) attempting to visualize geo-spatial raster data with graphics tools 3) creating lines to represent the path of sensor platforms that record many variables like temperature, salinity, radiative flux as well as location in time and space.

The word "spatial" has a rather general meaning, and while GIS idioms sometimes extend into the Z dimension time is usually treated in a special way. Where GIS really starts to show its limits is in the boundary between discrete and continuous measures and entities. We prefer to default to the most general meaning of spatial, work with tools that allow flexibility despite the (rather arbitrary) choice of topological and geometric structures and dimensions that a given model needs. When the particular optimizations and clever constraints of the simple features and GIS world are required and/or valuable then we use those, but prefer not to see that 1) this model must fit into this GIS view 2) GIS has no place in this model. For us the boundaries are not so sharp and there's valuable cross-over in many fields.

The particular GIS-like limitations that we seek are as follows.

-   flexibility in the number and type/s of attribute stored as "coordinates", x, y, lon, lat, z, time, temperature, etc.
-   ability to store attributes on parts i.e. the state is the object, the county is the part
-   shared vertices
-   the ability to leverage topology engines like D3 to dynamically segmentize a piecewise graph using geodetic curvature
-   the ability to extend the hierarchical view in GIS to 3D, 4D spatial, graphical, network and general modelling domains
-   clarity on the distinction between topology and geometry
-   clarity on the distinction between vector and raster data, without having an arbitrary boundary between them
-   multiple models of raster `georeferencing` from basic offset/scale, general affine transform, full curvilinear and partial curvilinear with affine and rectilinear optimizations where applicable
-   ability to store points, lines and areas together, with shared topology as appropriate
-   a flexible and powerful basis for conversion between formats both in the GIS idioms and outside them
-   flexibility, ease-of-use, composability, modularity, tidy-ness
-   integration with specialist computational engines, database systems, geometric algorithms, drawing tools and other systems
-   interactivity, integration with D3, shiny, ggplot2, ggvis, leaflet
-   scaleability, the ability to leverage back-end databases, specialist parallelism engines, remote compute and otherwise distributed compute systems

Flexibility in attributes generally is the key to breaking out of traditional GIS constraints that don't allow clear continuous / discrete distinctions, or time-varying objects/events, 3D/4D geometry, or clarity on topology versus geometry. When everything is tables this becomes natural, and we can build structures like link-relations between tables that transfer data only when required.

The ability many GIS tools from R in a consistent way is long-term goal, and this will be best done via dplyr "back-ending" or a model very like it.

Approach
========

We can't possibly provide all the aspirations detailed above, but we hope to

-   demonstrate the clear need, interest and opportunities that currently exist for fostering their development
-   illustrate links between existing systems that from a slightly different perspective become achievable goals rather than insurmountable challenges
-   provide a platform for generalizing some of the currently fragmented translations that occur across the R community between commonly used tools that aren't formally speaking to each other.
-   provide tools that we build along the way

This package is intended to provide support to the `common form` approach described here. The package is not fully functional yet, but see these projects that are informed by this approach.

-   **rbgm** - [Atlantis Box Geometry Model](https://github.com/AustralianAntarcticDivision/rbgm), a "doubly-connected edge-list" form of linked faces and boxes in a spatially-explicit 3D ecosystem model
-   **rangl** - [Primitives for Spatial data](https://github.com/r-gris/rangl), a generalization of GIS forms with simple 3D plotting
-   **spbabel** - [Translators for R Spatial](https://github.com/mdsumner/spbabel), tools to convert from and to spatial forms, provides the general decomposition framework for paths, used by `rangl`
-   **sfct** - [Constrained Triangulation for Simple Features](https://github.com/r-gris/sfct) tools to decompose `simple features` into (non-mesh-indexed) primitives.

Design
------

<<<<<<< HEAD
We use the following words in a specified sense, denoting a hierarchy of sorts in order from highest to lowest with layer, object, branch (or path), primitives, coordinates, and vertices.

The current design uses capitalized function names `BRANCH`, `PRIMITIVE` ... that act on layers, while prefixed lower-case function names produce or derive the named entity at a given level for a given input. E.g. `sc_branch` will decompose all the geometries in an `sf` layer to the BRANCH model and return them in generic form. `BRANCH` will decompose the layer as a whole, including the component geometries.

`BRANCH()` is the main model used to decompose inputs, as it is the a more general form of the GIS idioms (simple features and georeferenced raster data) This treats connected *paths* as fully-fledged entities like vertices and objects are, creating a relational model that stores all *vertices* in one table, all *branches* in another, and and all highest-level *objects* in another. The BRANCH model also takes the extra step of *normalizing* vertices, finding duplicates in a given geometric space and creating an intermediate link table to record all *instances of the vertices*. The BRANCH model does not currently normalize branches, but this is something that could be done, and is close to what arc-node topology is.

The `PRIMITIVE` function decomposes a layer into actual primitives, rather than "paths", these are point, line segment, triangle, tetrahedron, and so on.
=======
Currently `PATH()` and `PRIMITIVE` are the highest level functions to decompose simple features objects.
>>>>>>> primitives-classes

There are decomposition functions for lower-level `sf` objects organized as `sc_path`, `sc_coord`, and `sc_object`. `sc_path` does all the work, building a simple map of all the parts and the vertex count. This is used to classify the vertex table when it is extracted, which makes the unique-id management for path-vertex normalization much simpler than it was in `gris` or `rangl`.

**NOTE:** earlier versions of this used the concept of "branch" rather than path, so there is some ongoing migration of the use of these words. *Branch* is a more general concept than implemented in geo-spatial systems generally, and so *path* is more accurate We reserve branch for possible future models that are general. A "point PATH" has meaning in the sense of being a single-vertex "path", and so a multipoint is a collection of these degenerate forms. "Path" as a concept is clearly rooted in optimization suited to planar forms, and so is more accurate than "branch".

In our terminology a branch or path is the group between the raw geometry and the objects, and so applies to a connected polygon ring, closed or open linestring, a single coordinate with a multipoint (a path with one vertex). In this scheme a polygon ring and a closed linestring are exactly the same (since they actually are exactly the same) and there are no plane-filling branches, or indeed volume-filling branches. This is a clear limitation of the branch model and it matches that used by GIS.

Exceptions
----------

TopoJSON, Eonfusion, PostGIS, QGIS geometry generators, Fledermaus, ...

Example - sf to ggplot2 round trip
----------------------------------

``` r
library(sf)
#> Linking to GEOS 3.5.0, GDAL 2.1.1
## a MULTIPOLYGON layer
nc = st_read(system.file("shape/nc.shp", package="sf"))
<<<<<<< HEAD
#> Reading layer `nc' from data source `C:\Users\mdsumner\Documents\R\win-library\3.3\sf\shape\nc.shp' using driver `ESRI Shapefile'
#> Warning in CPL_read_ogr(dsn, layer, as.character(options), quiet,
#> iGeomField - : GDAL Error 1: Failed to find required field in
#> gdal_datum.csv in InitDatumMappingTable(), using default table setup.
=======
#> Reading layer `nc' from data source `C:\inst\R\R\library\sf\shape\nc.shp' using driver `ESRI Shapefile'
>>>>>>> primitives-classes
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
library(sc)
<<<<<<< HEAD
nc = st_read(system.file("gpkg/nc.gpkg", package="sf"))
#> Reading layer `nc.gpkg' from data source `C:\Users\mdsumner\Documents\R\win-library\3.3\sf\gpkg\nc.gpkg' using driver `GPKG'
#> Simple feature collection with 100 features and 14 fields
#> geometry type:  MULTIPOLYGON
#> dimension:      XY
#> bbox:           xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
#> epsg (SRID):    4267
#> proj4string:    +proj=longlat +ellps=clrk66 +nadgrids=@conus,@alaska,@ntv2_0.gsb,@ntv1_can.dat +no_defs

(bmodel <- BRANCH(nc))
=======
(bmodel <- PATH(nc))
>>>>>>> primitives-classes
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
<<<<<<< HEAD
#>    island_ ncoords_          branch_          object_
#>      <chr>    <int>            <chr>            <chr>
#> 1        1       27 1fe228431c080796 f0e167f4c8db1a1f
#> 2        1       26 b239fb6aaa45b3ec 3c3e9a0aaccc9f12
#> 3        1       28 0a961a406ea59631 213bccd823c2c27d
#> 4        1       26 5ae42e258d48a21d 01291e3a050a7817
#> 5        2        7 fa2c6763c26648c6 01291e3a050a7817
#> 6        3        5 be9962b02adea6cf 01291e3a050a7817
#> 7        1       34 6c19fef9b64932d4 6fd8f49d7046550e
#> 8        1       22 b1fe4bbc2807e7fb eb2aece583845d3d
#> 9        1       24 44fd662f043886e9 56e207febafdd611
#> 10       1       17 4dfdbc36626325d2 58fd2ef57152c6ca
=======
#>    island_ ncoords_    path_  object_
#>      <chr>    <int>    <chr>    <chr>
#> 1        1       27 df894121 7b43e680
#> 2        1       26 f023c057 314e995a
#> 3        1       28 64802955 a9cf6c46
#> 4        1       26 f7e9c969 380f58d1
#> 5        2        7 a8709d80 380f58d1
#> 6        3        5 12538df2 380f58d1
#> 7        1       34 295b1051 503fa8b0
#> 8        1       22 76f28a32 474a9688
#> 9        1       24 8d8f2243 6010a560
#> 10       1       17 dec398bb e9851602
>>>>>>> primitives-classes
#> # ... with 98 more rows
#> 
#> $vertex
#> # A tibble: 1,255 × 3
<<<<<<< HEAD
#>           x_       y_          vertex_
#>        <dbl>    <dbl>            <chr>
#> 1  -81.47276 36.23436 5c25ef7ad7e5b922
#> 2  -81.54084 36.27251 2186c5c3916d8180
#> 3  -81.56198 36.27359 3e0d635d9e84cada
#> 4  -81.63306 36.34069 6cb5f2c848008e31
#> 5  -81.74107 36.39178 d3bba52e5995b257
#> 6  -81.69828 36.47178 3a6395093904434a
#> 7  -81.70280 36.51934 ae611d021eb3d1c6
#> 8  -81.67000 36.58965 cf2cef2e930deb26
#> 9  -81.34530 36.57286 45e518e9cdd94b90
#> 10 -81.34754 36.53791 2cb2dcc66f79f293
#> # ... with 1,245 more rows
#> 
#> $branch_link_vertex
#> # A tibble: 2,529 × 3
#>             branch_ order_          vertex_
#>               <chr>  <int>            <chr>
#> 1  1fe228431c080796      1 5c25ef7ad7e5b922
#> 2  1fe228431c080796      2 2186c5c3916d8180
#> 3  1fe228431c080796      3 3e0d635d9e84cada
#> 4  1fe228431c080796      4 6cb5f2c848008e31
#> 5  1fe228431c080796      5 d3bba52e5995b257
#> 6  1fe228431c080796      6 3a6395093904434a
#> 7  1fe228431c080796      7 ae611d021eb3d1c6
#> 8  1fe228431c080796      8 cf2cef2e930deb26
#> 9  1fe228431c080796      9 45e518e9cdd94b90
#> 10 1fe228431c080796     10 2cb2dcc66f79f293
=======
#>           x_       y_  vertex_
#>        <dbl>    <dbl>    <chr>
#> 1  -81.47276 36.23436 811cd104
#> 2  -81.54084 36.27251 17566107
#> 3  -81.56198 36.27359 9e8ec3bf
#> 4  -81.63306 36.34069 fa7e85a3
#> 5  -81.74107 36.39178 f683ebe9
#> 6  -81.69828 36.47178 48de79f3
#> 7  -81.70280 36.51934 24420d90
#> 8  -81.67000 36.58965 83adc02c
#> 9  -81.34530 36.57286 7d3f18f6
#> 10 -81.34754 36.53791 f2bce195
#> # ... with 1,245 more rows
#> 
#> $path_link_vertex
#> # A tibble: 2,529 × 2
#>       path_  vertex_
#>       <chr>    <chr>
#> 1  df894121 811cd104
#> 2  df894121 17566107
#> 3  df894121 9e8ec3bf
#> 4  df894121 fa7e85a3
#> 5  df894121 f683ebe9
#> 6  df894121 48de79f3
#> 7  df894121 24420d90
#> 8  df894121 83adc02c
#> 9  df894121 7d3f18f6
#> 10 df894121 f2bce195
>>>>>>> primitives-classes
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
#>  $ object          :Classes 'tbl_df', 'tbl' and 'data.frame':    6 obs. of  4 variables:
#>   ..$ ID      : int [1:6] 103841 103842 103843 103846 103847 103848
#>   ..$ Province: chr [1:6] "Australian Capital Territory" "New Caledonia" "New South Wales" "South Australia" ...
<<<<<<< HEAD
#>   ..$ object_ : chr [1:6] "3196572089cd6a08" "4499a68dcc61c7b3" "ca41c9adfaa44a99" "75dfff5132854ee4" ...
#>  $ branch            :Classes 'tbl_df', 'tbl' and 'data.frame':  189 obs. of  4 variables:
#>   ..$ island_ : chr [1:189] "1" "1" "1" "1" ...
#>   ..$ ncoords_: int [1:189] 280 27 7310 68 280 88 162 119 51 71 ...
#>   ..$ branch_ : chr [1:189] "16d95dac0b6baab7" "f5352dadb86981f4" "1342bd32881a5ddb" "2cbb1156a6e824a7" ...
#>   ..$ object_ : chr [1:189] "3196572089cd6a08" "4499a68dcc61c7b3" "ca41c9adfaa44a99" "ca41c9adfaa44a99" ...
#>  $ vertex            :Classes 'tbl_df', 'tbl' and 'data.frame':  30835 obs. of  3 variables:
#>   ..$ x_     : num [1:30835] 1116371 1117093 1117172 1117741 1117629 ...
#>   ..$ y_     : num [1:30835] -458419 -457111 -456893 -456561 -455510 ...
#>   ..$ vertex_: chr [1:30835] "6160939c911cdb32" "6c47b7006fe919ec" "c582e4e115621b4b" "cdcdb38cf04e9088" ...
#>  $ branch_link_vertex:Classes 'tbl_df', 'tbl' and 'data.frame':  33644 obs. of  3 variables:
#>   ..$ branch_: chr [1:33644] "16d95dac0b6baab7" "16d95dac0b6baab7" "16d95dac0b6baab7" "16d95dac0b6baab7" ...
#>   ..$ order_ : int [1:33644] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ vertex_: chr [1:33644] "6160939c911cdb32" "6c47b7006fe919ec" "c582e4e115621b4b" "cdcdb38cf04e9088" ...
#>  - attr(*, "class")= chr [1:2] "BRANCH" "sc"
#>  - attr(*, "join_ramp")= chr [1:4] "object" "branch" "branch_link_vertex" "vertex"
=======
#>   ..$ geom    :List of 6
#>   .. ..$ :List of 1
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:280, 1:2] 1116371 1117093 1117172 1117741 1117629 ...
#>   .. .. ..- attr(*, "class")= chr [1:3] "XY" "MULTIPOLYGON" "sfg"
#>   .. ..$ :List of 1
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:27, 1:2] 2468858 2469790 2470172 2470705 2471387 ...
#>   .. .. ..- attr(*, "class")= chr [1:3] "XY" "MULTIPOLYGON" "sfg"
#>   .. ..$ :List of 18
#>   .. .. ..$ :List of 12
#>   .. .. .. ..$ : num [1:7310, 1:2] 446061 448110 448444 448565 448641 ...
#>   .. .. .. ..$ : num [1:68, 1:2] 465616 465680 465864 466079 466379 ...
#>   .. .. .. ..$ : num [1:280, 1:2] 1116371 1117093 1117172 1117741 1117629 ...
#>   .. .. .. ..$ : num [1:88, 1:2] 1154300 1154342 1154469 1154710 1154996 ...
#>   .. .. .. ..$ : num [1:162, 1:2] 1108542 1108776 1109264 1109673 1110108 ...
#>   .. .. .. ..$ : num [1:119, 1:2] 1473640 1473774 1473887 1474117 1474351 ...
#>   .. .. .. ..$ : num [1:51, 1:2] 584047 584345 584746 585243 585783 ...
#>   .. .. .. ..$ : num [1:71, 1:2] 1387447 1387612 1387996 1388537 1389039 ...
#>   .. .. .. ..$ : num [1:264, 1:2] 624794 624895 625053 625358 625774 ...
#>   .. .. .. ..$ : num [1:253, 1:2] 1182261 1182388 1182586 1182796 1183194 ...
#>   .. .. .. ..$ : num [1:63, 1:2] 560920 560953 561127 561291 561460 ...
#>   .. .. .. ..$ : num [1:80, 1:2] 568384 568577 568870 569237 569655 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 1233744 1234235 1234461 1234310 1234676 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 1297243 1297365 1297913 1298173 1298010 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 1359615 1361417 1361896 1361870 1360138 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 1400553 1400737 1401098 1401447 1401530 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 1459512 1459840 1460354 1460984 1461102 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 1455430 1455779 1457162 1456809 1456315 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 1447003 1447147 1447440 1447721 1447565 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] 1440912 1441541 1441722 1441817 1441572 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 1441894 1442376 1442651 1442707 1442159 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:47, 1:2] 2098343 2098668 2098841 2099021 2099438 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:12, 1:2] 1472313 1472715 1472800 1472979 1473244 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 1494832 1495322 1495801 1495970 1496183 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] 1493536 1493594 1495043 1495389 1495706 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 1491660 1491936 1492533 1492834 1493226 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:15, 1:2] 1564989 1565054 1565174 1565673 1566182 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] 1620113 1620593 1620849 1620774 1620238 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:17, 1:2] 1615264 1615372 1616338 1617153 1621131 ...
#>   .. .. ..- attr(*, "class")= chr [1:3] "XY" "MULTIPOLYGON" "sfg"
#>   .. ..$ :List of 44
#>   .. .. ..$ :List of 12
#>   .. .. .. ..$ : num [1:4434, 1:2] -681074 -680885 -680821 -680474 -680376 ...
#>   .. .. .. ..$ : num [1:158, 1:2] -483997 -483641 -483224 -482747 -482199 ...
#>   .. .. .. ..$ : num [1:707, 1:2] -113900 -113780 -113344 -112933 -112533 ...
#>   .. .. .. ..$ : num [1:968, 1:2] -56130 -55977 -55685 -55142 -54394 ...
#>   .. .. .. ..$ : num [1:1405, 1:2] 73826 73831 73950 74230 74738 ...
#>   .. .. .. ..$ : num [1:1201, 1:2] 110372 110483 110767 111191 111474 ...
#>   .. .. .. ..$ : num [1:341, 1:2] 42284 42580 43140 43699 44809 ...
#>   .. .. .. ..$ : num [1:146, 1:2] 107708 107816 108134 108669 109421 ...
#>   .. .. .. ..$ : num [1:253, 1:2] 49838 49943 50639 51096 51460 ...
#>   .. .. .. ..$ : num [1:439, 1:2] 321446 321467 321717 322063 322480 ...
#>   .. .. .. ..$ : num [1:424, 1:2] 98242 98277 98517 98849 99228 ...
#>   .. .. .. ..$ : num [1:194, 1:2] 324124 324305 324600 324996 325429 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:25, 1:2] -7847 -6899 -6987 -6632 -6233 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] -350717 -350602 -349713 -349825 -350253 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] -246977 -246785 -246475 -245894 -246401 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] -247291 -246670 -245986 -245476 -245625 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:29, 1:2] -248305 -247374 -247139 -247033 -247415 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] -251725 -250980 -250808 -251045 -251725 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] -239785 -239750 -239555 -239012 -238499 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] -229797 -229268 -229004 -228736 -228872 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:11, 1:2] -227759 -227664 -226943 -225184 -224933 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:31, 1:2] -201142 -201132 -201130 -201108 -200828 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] -157173 -156968 -156740 -156238 -156943 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] -155390 -155111 -154728 -154297 -154087 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:10, 1:2] -155472 -155039 -154812 -154056 -153865 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] -157640 -157337 -156516 -155958 -156439 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:49, 1:2] -138995 -138849 -137306 -137182 -135407 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] -120303 -120188 -119798 -119376 -119207 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:17, 1:2] -109653 -109640 -109458 -108624 -108269 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] -108759 -108311 -108143 -107534 -106719 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] -34149 -33876 -33542 -33693 -33649 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:10, 1:2] -3071 -2885 -2303 -1606 -1465 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] -44.2 433.1 954.5 1113.6 1007.8 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:22, 1:2] 23672 23963 24256 25188 24897 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:492, 1:2] 46455 46678 47788 47970 47435 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:24, 1:2] 118463 118672 118606 118873 118798 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 82401 82637 83419 83728 83560 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 83796 83963 84239 84713 84976 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] -123726 -122812 -121665 -122316 -122638 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 160258 160797 160967 161335 161458 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:55, 1:2] 6834 8804 9439 9712 12614 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 2200 2757 3366 3261 2748 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] 9524 9911 10290 10369 10018 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] 4877 4886 4965 5555 5907 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:21, 1:2] 38717 39049 39576 40387 40626 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] 40841 41173 41570 42029 41274 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:10, 1:2] 225036 225346 225638 225874 225942 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:14, 1:2] 222111 222352 222622 222753 223115 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:11, 1:2] -4808 -4798 -4097 -4327 -4221 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 27046 28135 28552 28731 28457 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:60, 1:2] -224013 -223799 -223715 -223472 -223035 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:10, 1:2] -215794 -215662 -214727 -213947 -213232 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:12, 1:2] -212935 -212752 -212438 -212086 -210730 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] 25554 26735 26931 26630 25955 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:18, 1:2] 29037 29071 29582 30007 30076 ...
#>   .. .. ..- attr(*, "class")= chr [1:3] "XY" "MULTIPOLYGON" "sfg"
#>   .. ..$ :List of 61
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:190, 1:2] 652061 652140 652671 652937 652369 ...
#>   .. .. ..$ :List of 8
#>   .. .. .. ..$ : num [1:4424, 1:2] 706791 707637 707895 708419 708502 ...
#>   .. .. .. ..$ : num [1:220, 1:2] 801077 801365 801840 802597 803176 ...
#>   .. .. .. ..$ : num [1:238, 1:2] 801120 801311 801607 802427 802909 ...
#>   .. .. .. ..$ : num [1:110, 1:2] 865560 865669 865670 865818 866069 ...
#>   .. .. .. ..$ : num [1:78, 1:2] 897777 897936 898161 898375 898625 ...
#>   .. .. .. ..$ : num [1:68, 1:2] 880114 880277 880636 880947 881274 ...
#>   .. .. .. ..$ : num [1:66, 1:2] 823222 823448 823852 824471 825137 ...
#>   .. .. .. ..$ : num [1:65, 1:2] 817504 817667 818089 818743 819148 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:14, 1:2] 985578 985887 986213 986388 986958 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:15, 1:2] 985011 985225 985177 985438 985546 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 985697 985947 986224 986300 985759 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:261, 1:2] 977468 977805 977834 978773 978913 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:12, 1:2] 991638 991712 992379 992778 993192 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:194, 1:2] 990184 990609 990307 990511 990760 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:17, 1:2] 990394 990508 990892 991496 991974 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:19, 1:2] 991046 991247 991370 992134 992838 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:30, 1:2] 972619 973020 973868 974480 975152 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 973110 973561 974034 974448 974239 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:10, 1:2] 652657 653154 653391 653726 654186 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:18, 1:2] 821428 821684 821503 822055 823484 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 764917 765084 765438 765632 765485 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 793079 793366 793276 793515 793641 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 835246 835647 835933 836275 836398 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:331, 1:2] 882815 882878 883451 884261 884516 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 878979 879261 879241 881399 879705 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 881520 881677 882393 882571 882230 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 887351 887400 887731 887997 887966 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 931425 931723 932292 932545 932495 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 942896 943266 943637 943724 943421 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 917309 918355 918596 918627 918417 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 988370 988470 989089 989307 990008 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] 990779 991101 991479 991348 990925 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 989018 989395 989778 990372 990832 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:60, 1:2] 997859 997952 998713 999312 999893 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] 1003803 1004067 1005156 1005747 1006111 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:37, 1:2] 979297 980566 980845 980436 980586 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:12, 1:2] 974850 975170 975237 975569 975807 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:12, 1:2] 955152 955307 955724 956651 957687 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] 733879 734048 735074 734846 734006 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:17, 1:2] 744108 744494 744558 745325 745588 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:11, 1:2] 727178 727467 727551 728245 728544 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:68, 1:2] 718964 719995 720195 720072 720381 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 883192 883580 883773 884186 883779 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] 994403 994422 994430 994823 994415 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:12, 1:2] 994588 994753 995823 996102 996399 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:17, 1:2] 994773 995053 995570 995961 996244 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] 1015177 1015319 1015938 1015958 1016202 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:31, 1:2] 945192 945412 945916 945989 946347 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 1017306 1017978 1018197 1018654 1018906 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:18, 1:2] 1016012 1016186 1016675 1016977 1017164 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 1e+06 1e+06 1e+06 1e+06 1e+06 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:11, 1:2] 1012401 1012688 1013161 1013661 1013812 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 1013568 1013690 1015195 1014981 1014657 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 994837 994961 995313 995334 995690 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:5, 1:2] 991745 991772 991918 991747 991745 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 1010018 1010054 1010223 1010848 1010935 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 987387 987471 987821 987796 987713 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:22, 1:2] 997852 997943 998258 999539 1000143 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] 1023915 1024054 1024484 1025506 1026078 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:52, 1:2] 730316 730407 730911 731451 732053 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:61, 1:2] 730678 730719 732506 732857 733393 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:19, 1:2] 735755 735943 736603 736641 736728 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:177, 1:2] 1533244 1533657 1534500 1534701 1534780 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 991890 991941 992164 992390 992980 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 689289 689658 690200 690720 690726 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] 715810 716271 717023 717265 716545 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 956648 956776 957324 957590 957728 ...
#>   .. .. ..- attr(*, "class")= chr [1:3] "XY" "MULTIPOLYGON" "sfg"
#>   .. ..$ :List of 32
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ : num [1:4317, 1:2] 423164 423864 424331 424750 425010 ...
#>   .. .. .. ..$ : num [1:85, 1:2] 510902 511008 511248 511527 511890 ...
#>   .. .. .. ..$ : num [1:181, 1:2] 624350 624379 624567 624686 624696 ...
#>   .. .. .. ..$ : num [1:86, 1:2] 953762 953882 954041 954230 954465 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:12, 1:2] 508051 508103 508324 508757 509695 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 529333 529432 529727 530682 530428 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 1188458 1188631 1189113 1189481 1189536 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:14, 1:2] 735469 735985 736529 736882 739045 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:91, 1:2] 771906 772091 772199 773068 774284 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:73, 1:2] 785620 785635 786342 786481 786461 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:14, 1:2] 787898 788962 789565 789951 790245 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:12, 1:2] 859298 859441 859863 860096 860394 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:7, 1:2] 861083 861365 861250 861459 861740 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:6, 1:2] 866334 866807 867179 867445 866408 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:14, 1:2] 870700 870706 870845 871395 871595 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:77, 1:2] 883042 883068 883496 884373 884976 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:8, 1:2] 867000 867034 867725 867953 867880 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:17, 1:2] 881043 881687 882953 883280 884689 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 889941 890405 890836 891475 891672 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 889861 890652 891239 891219 890826 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:15, 1:2] 900401 900819 901495 902946 903101 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:21, 1:2] 903152 903245 903677 904176 905486 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:12, 1:2] 907966 908144 908752 910675 913191 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] 911008 911375 911941 913082 913501 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:17, 1:2] 914682 914800 915045 915609 916309 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:24, 1:2] 911490 911804 912219 913915 914338 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:12, 1:2] 998616 1002217 1002948 1003199 1003135 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:5, 1:2] 964455 964515 964555 964488 964455 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:11, 1:2] 920573 920834 921576 922211 921883 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:15, 1:2] 896151 897003 897605 898757 899937 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:23, 1:2] 893896 893918 895414 896654 896968 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:9, 1:2] 897926 898485 899003 899954 900447 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] 900851 900973 901273 901893 902184 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:14, 1:2] 941525 941866 942320 942976 943358 ...
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ : num [1:13, 1:2] 943181 943616 944195 944621 944921 ...
#>   .. .. ..- attr(*, "class")= chr [1:3] "XY" "MULTIPOLYGON" "sfg"
#>   .. ..- attr(*, "n_empty")= int 0
#>   .. ..- attr(*, "crs")=List of 2
#>   .. .. ..$ epsg       : int NA
#>   .. .. ..$ proj4string: chr "+proj=lcc +lat_1=-47 +lat_2=-17 +lat_0=-32 +lon_0=136 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
#>   .. .. ..- attr(*, "class")= chr "crs"
#>   .. ..- attr(*, "class")= chr [1:2] "sfc_MULTIPOLYGON" "sfc"
#>   .. ..- attr(*, "precision")= num 0
#>   .. ..- attr(*, "bbox")= Named num [1:4] -2239268 -2677570 2477934 2429213
#>   .. .. ..- attr(*, "names")= chr [1:4] "xmin" "ymin" "xmax" "ymax"
#>   ..$ object_ : chr [1:6] "3b1b1853" "2d913a46" "dffc3759" "9751bd8e" ...
#>   ..- attr(*, "sf_column")= chr "geom"
#>   ..- attr(*, "relation_to_geometry")= Factor w/ 3 levels "constant","aggregate",..: NA NA
#>   .. ..- attr(*, "names")= chr [1:2] "ID" "Province"
#>  $ path            :Classes 'tbl_df', 'tbl' and 'data.frame':    189 obs. of  4 variables:
#>   ..$ island_ : chr [1:189] "1" "1" "1" "1" ...
#>   ..$ ncoords_: int [1:189] 280 27 7310 68 280 88 162 119 51 71 ...
#>   ..$ path_   : chr [1:189] "5c150926" "0c1ec948" "933db717" "e08b969e" ...
#>   ..$ object_ : chr [1:189] "3b1b1853" "2d913a46" "dffc3759" "dffc3759" ...
#>  $ vertex          :Classes 'tbl_df', 'tbl' and 'data.frame':    30834 obs. of  3 variables:
#>   ..$ x_     : num [1:30834] 1116371 1117093 1117172 1117741 1117629 ...
#>   ..$ y_     : num [1:30834] -458419 -457111 -456893 -456561 -455510 ...
#>   ..$ vertex_: chr [1:30834] "9b33719c" "c912bfc3" "2e070258" "2a4f8799" ...
#>  $ path_link_vertex:Classes 'tbl_df', 'tbl' and 'data.frame':    33644 obs. of  2 variables:
#>   ..$ path_  : chr [1:33644] "5c150926" "5c150926" "5c150926" "5c150926" ...
#>   ..$ vertex_: chr [1:33644] "9b33719c" "c912bfc3" "2e070258" "2a4f8799" ...
#>  - attr(*, "class")= chr [1:2] "PATH" "sc"
#>  - attr(*, "join_ramp")= chr [1:4] "object" "path" "path_link_vertex" "vertex"
>>>>>>> primitives-classes

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

Example - sf to SQLite and filtered-read
----------------------------------------

See scdb

Primitives, the planar straight line graph and TopoJSON
-------------------------------------------------------

(WIP see primitives-classes)

``` r
example(PRIMITIVE)
```

### Arc-node topoplogy

``` r

example(arc_node)
```
