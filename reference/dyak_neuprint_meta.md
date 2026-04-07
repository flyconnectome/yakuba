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

  Additional arguments passed to `neuprint_get_meta`

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
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
dyak_neuprint_meta(dyak_ids("DNa02"))
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
# }
```
