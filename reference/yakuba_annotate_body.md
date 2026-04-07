# Set Clio body annotations

Set Clio body annotations

## Usage

``` r
yakuba_annotate_body(
  x,
  test = TRUE,
  version = NULL,
  write_empty_fields = FALSE,
  designated_user = NULL,
  protect = c("user"),
  chunksize = 50,
  check_types = TRUE,
  ...,
  dataset = dyak_default_dataset()
)
```

## Arguments

- x:

  A data frame, list or JSON string containing body annotations. End
  users are strongly recommended to use data frames.

- test:

  Whether to use the test Clio store (recommended until you are sure
  that you know what you are doing).

- version:

  Optional Clio version to associate with this annotation. The default
  `NULL` uses the current version returned by the API.

- write_empty_fields:

  When `x` is a data frame, this controls whether empty fields in `x`
  overwrite fields in the Clio database.

- designated_user:

  Optional alternate user recorded in Clio for the annotation.

- protect:

  Vector of fields that will not be overwritten if they already have a
  value in Clio. Set to `TRUE` to protect all fields and to `FALSE` to
  overwrite all fields for which you provide data.

- chunksize:

  When you have many bodies to annotate the request will by default be
  sent 50 records at a time to avoid timeouts. Set to `Inf` to insist
  that all records are sent in a single request.

- check_types:

  Whether to verify data-frame column types against the active yakuba
  Clio schema.

- ...:

  Additional parameters passed to
  [`pbapply::pbsapply()`](https://peter.solymos.org/pbapply/reference/pbapply.html).

- dataset:

  The name of the dataset as reported in Clio or neuprint.

## Value

`NULL` invisibly on success. Errors out on failure.

## Details

Details of the Clio body annotation system are provided in
[`malevnc::manc_annotate_body()`](https://natverse.org/malevnc/reference/manc_annotate_body.html).
It can take some time to apply annotations, so requests are chunked by
default in groups of 50.

A single column called `position` or 3 columns named `x`, `y`, `z` or
`X`, `Y`, `Z` in any form accepted by
[`nat::xyzmatrix()`](https://rdrr.io/pkg/nat/man/xyzmatrix.html) will be
converted to a position stored with each record. This is recommended
when creating records.

When `protect=TRUE` no data in Clio will be overwritten, only new data
will be added. When `protect=FALSE` all fields will be overwritten by
new data for each non-empty value in `x`. If `write_empty_fields=TRUE`
then even empty fields in `x` will overwrite fields in the database.

## Validation

Validation depends on how you provide your input data. If `x` is a data
frame then each row is checked for some basics including the presence of
a `bodyid`, and empty fields are removed. We also check field types
against the active yakuba Clio schema by default.

## Users

Clio records a user and timestamp for every modification to fields in a
record. By default your email address from the Clio token will be used.
You can specify an alternate user with the `designated_user` argument;
see
[`malevnc::manc_annotate_body()`](https://natverse.org/malevnc/reference/manc_annotate_body.html)
for details.

## See also

[`malevnc::manc_annotate_body()`](https://natverse.org/malevnc/reference/manc_annotate_body.html)

## Examples

``` r
if (FALSE) { # \dontrun{
ids <- dyak_ids("DNa02", as_character = FALSE)
yakuba_annotate_body(
  data.frame(bodyid = ids[1], group = min(ids)),
  test = TRUE
)
} # }
```
