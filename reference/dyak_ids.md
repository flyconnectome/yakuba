# Get yakuba ids in standard formats

Get yakuba ids in standard formats

## Usage

``` r
dyak_ids(
  ids,
  mustWork = TRUE,
  as_character = TRUE,
  integer64 = FALSE,
  unique = FALSE,
  ...,
  dataset = dyak_default_dataset()
)
```

## Arguments

- ids:

  Either numeric ids (in `character`, `numeric`, `integer` or
  `integer64` format) or a query expression.

- mustWork:

  Whether to insist that at least one valid id is returned (default
  `TRUE`)

- as_character:

  Whether to return segments as character rather than numeric vector
  (the default is character for safety).

- integer64:

  whether to return ids with class bit64::integer64.

- unique:

  Whether to ensure that only unique ids are returned (default `TRUE`)

- ...:

  Additional arguments passed to
  [`malevnc::manc_ids()`](https://natverse.org/malevnc/reference/manc_ids.html).

- dataset:

  The name of the dataset as reported in Clio or neuprint.

## Value

A vector of numeric ids with mode determined by `as_character` and
`integer64`.

## See also

[`malevnc::manc_ids()`](https://natverse.org/malevnc/reference/manc_ids.html)

## Examples

``` r
# \donttest{
ids <- dyak_ids("DNa02")
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
ids
#> Error: object 'ids' not found
dyak_ids("DNa02", integer64 = TRUE)
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
# }
```
