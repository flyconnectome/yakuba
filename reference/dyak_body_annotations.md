# Return neurojson body annotations via the Clio interface

Return neurojson body annotations via the Clio interface

## Usage

``` r
dyak_body_annotations(
  ids = NULL,
  query = NULL,
  json = FALSE,
  config = NULL,
  show.extra = c("none", "user", "time", "all"),
  cache = FALSE,
  test = FALSE,
  ...,
  dataset = dyak_default_dataset()
)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.html)

- query:

  A json query string (see examples or documentation) or an R list with
  field names as elements.

- json:

  Whether to return unparsed JSON rather than an R list (default
  `FALSE`).

- config:

  An optional httr::config (expert use only, must include a bearer
  token)

- show.extra:

  Extra columns to show with user/timestamp information.

- cache:

  Whether to cache the result of this call for 5 minutes.

- test:

  Whether to unset the clio-store test server (default `FALSE`)

- ...:

  Additional arguments passed to
  [`pbapply::pblapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)

- dataset:

  The name of the dataset as reported in Clio e.g. `yakuba`,
  `yakuba-vnc` etc. `yakuba`, `yakuba-vnc` and `yakubavnc` are treated
  as aliases for the main yakuba dataset.

## Value

A data frame with metadata.

## Details

In comparison with
[`dyak_neuprint_meta()`](https://flyconnectome.github.io/yakuba/reference/dyak_neuprint_meta.md),
this provides access to up to the second annotations; it is also
presently faster than that call. Compared with
[`dyak_neuprint_meta()`](https://flyconnectome.github.io/yakuba/reference/dyak_neuprint_meta.md),
it does not produce a stable set of columns, only returning those that
exist for the given query ids.

## See also

[`malevnc::manc_body_annotations()`](https://natverse.org/malevnc/reference/manc_body_annotations.html)

## Examples

``` r
# \donttest{
dyak_body_annotations("DNa02")
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
# }
```
