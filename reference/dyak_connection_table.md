# Connectivity query for yakuba neurons

Connectivity query for yakuba neurons

## Usage

``` r
dyak_connection_table(
  ids,
  partners = c("inputs", "outputs"),
  moredetails = c("class", "group", "type", "somaSide", "somaNeuromere", "hemilineage"),
  summary = FALSE,
  threshold = 1L,
  roi = NULL,
  by.roi = FALSE,
  conn = NULL,
  ...,
  dataset = dyak_default_dataset()
)
```

## Arguments

- ids:

  A set of body ids (see
  [`dyak_ids()`](https://flyconnectome.github.io/yakuba/reference/dyak_ids.md)
  for a range of ways to specify these).

- partners:

  Either inputs or outputs. Redundant with `prepost`, but probably
  clearer.

- moredetails:

  Either a logical (to add all fields when `TRUE`) or a character vector
  naming additional fields returned by
  [`dyak_neuprint_meta()`](https://flyconnectome.github.io/yakuba/reference/dyak_neuprint_meta.md)
  that will be added to the results data frame.

- summary:

  When `TRUE` and more than one query neuron is given, summarises
  connectivity grouped by partner.

- threshold:

  Only return partners \>= to an integer value. Default of 1 returns all
  partners. This threshold will be applied to the ROI weight when the
  `roi` argument is specified, otherwise to the whole neuron.

- roi:

  a single ROI. Use `neuprint_ROIs` to see what is available.

- by.roi:

  logical, whether or not to break neurons' connectivity down by region
  of interest (ROI)

- conn:

  Optional, a `neuprint_connection` object. Defaults to
  [`dyak_neuprint()`](https://flyconnectome.github.io/yakuba/reference/dyak_neuprint.md)
  to ensure that query is against the yakuba dataset.

- ...:

  additional arguments passed to `neuprint_connection_table`

- dataset:

  The name of the dataset as reported in Clio e.g. `yakuba`,
  `yakuba-vnc` etc. `yakuba`, `yakuba-vnc` and `yakubavnc` are treated
  as aliases for the main yakuba dataset.

## Value

A data frame.

## See also

[`malevnc::manc_connection_table()`](https://natverse.org/malevnc/reference/manc_connection_table.html)

## Examples

``` r
# \donttest{
dyak_connection_table("DNa02", partners = "outputs")
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
dyak_connection_table("DNa02", partners = "outputs", summary = TRUE)
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
# }
```
