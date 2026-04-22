# Login to yakuba neuprint server

Login to yakuba neuprint server

## Usage

``` r
dyak_neuprint(
  token = Sys.getenv("neuprint_token"),
  dataset = NULL,
  Force = FALSE,
  ...
)
```

## Arguments

- token:

  neuprint authorisation token obtained e.g. from neuprint.janelia.org
  website.

- dataset:

  Allows you to override the neuprint dataset for `dyak_neuprint()`
  (which would otherwise be chosen based on the value of
  `options(yakuba.dataset)`, normally changed by
  [`choose_dyak_dataset()`](https://flyconnectome.github.io/yakuba/reference/choose_dyak_dataset.md)).

- Force:

  Passed to
  [`neuprintr::neuprint_login()`](https://natverse.org/neuprintr/reference/neuprint_login.html).

- ...:

  Additional arguments passed to
  [`neuprintr::neuprint_login()`](https://natverse.org/neuprintr/reference/neuprint_login.html).

## Value

A `neuprint_connection` object returned by
[`neuprintr::neuprint_login()`](https://natverse.org/neuprintr/reference/neuprint_login.html).

## Details

It should be possible to use the same token across public and private
neuprint servers if you are using the same email address. However this
does not seem to work for all users. Before giving up on this, do try
using the *most* recently issued token from a private server rather than
older tokens. If you need to pass a specific token you can use the
`token` argument, also setting `Force=TRUE` to ensure that the specified
token is used if you have already tried to log in during the current
session.

## See also

[`malevnc::manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.html)

## Examples

``` r
# \donttest{
conn <- dyak_neuprint()
conn
#> Connection to neuPrint server:
#>   https://neuprint-yakuba.janelia.org
#> with default dataset:
#>    yakuba-vnc 
#> Login active since: Wed, 22 Apr 2026 23:27:46 GMT
# }
```
