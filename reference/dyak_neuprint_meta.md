# Fetch neuprint metadata for yakuba neurons

Fetch neuprint metadata for yakuba neurons

## Usage

``` r
dyak_neuprint_meta(
  ids = NULL,
  conn = NULL,
  roiInfo = FALSE,
  simplify.xyz = TRUE,
  cache = NA,
  ...,
  dataset = dyak_default_dataset()
)
```

## Arguments

- ids:

  body ids. When missing all bodies known to DVID are returned.

- conn:

  Optional, a `neuprint_connection` object. Defaults to
  [`dyak_neuprint()`](https://flyconnectome.github.io/yakuba/reference/dyak_neuprint.md)
  to ensure that query is against the yakuba dataset.

- roiInfo:

  whether to include the `roiInfo` field detailing synapse numbers in
  different locations. This is omitted by default as it is returned as a
  character vector of unprocessed JSON.

- simplify.xyz:

  Whether to simplify columns containing XYZ locations to a simple
  `"x,y,z"` format rather than a longer form referencing a schema at
  `spatialreference.org`. Defaults to `TRUE`.

- cache:

  whether to cache the query. When `cache=NA` (the default) queries are
  cached for neuprint snapshot versions (but not production datasets).
  See details.

- ...:

  Additional arguments passed to
  [`neuprintr::neuprint_get_meta()`](https://natverse.org/neuprintr/reference/neuprint_get_meta.html).

- dataset:

  The name of the dataset as reported in Clio or neuprint.

## Value

A data frame with one row for each unique input id and `NA`s for all
columns except `bodyid` when neuprint holds no metadata.

## See also

[`malevnc::manc_neuprint_meta()`](https://natverse.org/malevnc/reference/manc_neuprint_meta.html)

## Examples

``` r
# \donttest{
dyak_neuprint_meta("DNa02")
#> Warning: NAs introduced by coercion to integer64 range
#>   bodyid post  pre downstream upstream synweight           statusLabel
#> 1  10490  667 1405       9661      667     10328 Prelim Roughly traced
#> 2  10280  717 1703      11806      717     12523       Cervical Anchor
#>               class hemilineage somaNeuromere somaSide exitNerve rootSide  type
#> 1 descending neuron        <NA>          <NA>     <NA>      <NA>        L DNa02
#> 2 descending neuron        <NA>          <NA>     <NA>      <NA>        R DNa02
#>   group location locationType nerve entryNerve subclass subsubclass
#> 1 10280     <NA>         <NA>  <NA>       <NA>     <NA>        <NA>
#> 2 10280     <NA>         <NA>  <NA>       <NA>     <NA>        <NA>
#>   matchingNotes description tosomaLocation systematicType serial somaLocation
#> 1          <NA>        <NA>           <NA>           <NA>     NA         <NA>
#> 2          <NA>        <NA>           <NA>           <NA>     NA         <NA>
#>      seedPosition         seedGroup status totalNtPredictions
#> 1 17265,7157,2711 cervical-anterior Traced               1405
#> 2 11571,7834,2712 cervical-anterior Anchor               1703
#>   predictedNtConfidence   predictedNt celltypeTotalNtPredictions
#> 1             0.8277975 acetylcholine                       3108
#> 2             0.8322900 acetylcholine                       3108
#>   celltypePredictedNt celltypePredictedNtConfidence   consensusNt     voxels
#> 1       acetylcholine                     0.8302591 acetylcholine 3114139584
#> 2       acetylcholine                     0.8302591 acetylcholine 3423699391
#>    soma
#> 1 FALSE
#> 2 FALSE
dyak_neuprint_meta(dyak_ids("DNa02"))
#> Warning: NAs introduced by coercion to integer64 range
#>   bodyid post  pre downstream upstream synweight           statusLabel
#> 1  10490  667 1405       9661      667     10328 Prelim Roughly traced
#> 2  10280  717 1703      11806      717     12523       Cervical Anchor
#>               class hemilineage somaNeuromere somaSide exitNerve rootSide  type
#> 1 descending neuron        <NA>          <NA>     <NA>      <NA>        L DNa02
#> 2 descending neuron        <NA>          <NA>     <NA>      <NA>        R DNa02
#>   group location locationType nerve entryNerve subclass subsubclass
#> 1 10280     <NA>         <NA>  <NA>       <NA>     <NA>        <NA>
#> 2 10280     <NA>         <NA>  <NA>       <NA>     <NA>        <NA>
#>   matchingNotes description tosomaLocation systematicType serial somaLocation
#> 1          <NA>        <NA>           <NA>           <NA>     NA         <NA>
#> 2          <NA>        <NA>           <NA>           <NA>     NA         <NA>
#>      seedPosition         seedGroup status totalNtPredictions
#> 1 17265,7157,2711 cervical-anterior Traced               1405
#> 2 11571,7834,2712 cervical-anterior Anchor               1703
#>   predictedNtConfidence   predictedNt celltypeTotalNtPredictions
#> 1             0.8277975 acetylcholine                       3108
#> 2             0.8322900 acetylcholine                       3108
#>   celltypePredictedNt celltypePredictedNtConfidence   consensusNt     voxels
#> 1       acetylcholine                     0.8302591 acetylcholine 3114139584
#> 2       acetylcholine                     0.8302591 acetylcholine 3423699391
#>    soma
#> 1 FALSE
#> 2 FALSE
# }
```
