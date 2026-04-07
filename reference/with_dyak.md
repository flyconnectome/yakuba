# Evaluate an expression after temporarily setting malevnc options

`yakuba` is a thin wrapper around `malevnc`. This function temporarily
changes the server/dataset options for `malevnc` while running your
expression.

`choose_dyak()` swaps out the default `malevnc` dataset for the yakuba
dataset. This means that all functions from the `malevnc` package should
target yakuba instead. It is recommended that you use `with_dyak()` to
do this temporarily unless you have no intention of using other FlyEM
datasets. *To switch the default `yakuba` dataset please see
[`choose_dyak_dataset()`](https://flyconnectome.github.io/yakuba/reference/choose_dyak_dataset.md).*

When Clio dataset lookup is unavailable, `choose_dyak()` falls back to a
built-in neuprint-only configuration for the main yakuba dataset
aliases. DVID/Clio-backed functionality may be unavailable in that
session.

## Usage

``` r
with_dyak(expr, dataset = dyak_default_dataset())

choose_dyak(dataset = dyak_default_dataset(), set = TRUE)
```

## Arguments

- expr:

  An expression involving `malevnc`/`yakuba` functions to evaluate with
  the specified autosegmentation.

- dataset:

  The name of the dataset as reported in Clio or neuprint.

- set:

  Whether to set the relevant package options or just to return a list
  of the required options.

## Value

`with_dyak()` returns the result of `expr`.
[`choose_dyak_dataset()`](https://flyconnectome.github.io/yakuba/reference/choose_dyak_dataset.md)
and `choose_dyak()` return named lists of previous option values,
matching [`options()`](https://rdrr.io/r/base/options.html).

## Details

Note that it can also temporarily switch out the active dataset for the
`yakuba` package if you specify the `dataset` argument and this is
different from the current active dataset. This allows you to easily run
the same expression for different yakuba dataset variants.

## See also

[`malevnc::choose_flyem_dataset()`](https://natverse.org/malevnc/reference/choose_malevnc_dataset.html),
[`malevnc::choose_malevnc_dataset()`](https://natverse.org/malevnc/reference/choose_malevnc_dataset.html)

## Examples

``` r
# \donttest{
with_dyak(dyak_ids("DNa02"))
#> Error in (function (path, body = NULL, server = NULL, conf = NULL, parse.json = TRUE,     include_headers = TRUE, simplifyVector = FALSE, app = NULL,     ...) {    if (is.null(app))         app = paste0("neuprintr/", utils::packageVersion("neuprintr"))    req <- if (is.null(body)) {        httr::GET(url = file.path(server, path, fsep = "/"),             config = conf, httr::user_agent(app), ...)    }    else {        httr::POST(url = file.path(server, path, fsep = "/"),             body = body, config = conf, httr::user_agent(app),             ...)    }    neuprint_error_check(req)    if (parse.json) {        parsed = neuprint_parse_json(req, simplifyVector = simplifyVector)        if (length(parsed) == 2 && isTRUE(names(parsed)[2] ==             "error")) {            stop("neuPrint error: ", parsed$error)        }        if (include_headers) {            fields_to_include = c("url", "headers")            attributes(parsed) = c(attributes(parsed), req[fields_to_include])        }        parsed    }    else req})(path = path, body = body, server = server, conf = conf, parse.json = parse.json,     include_headers = include_headers, simplifyVector = simplifyVector,     app = app): Unauthorized (HTTP 401). Failed to process url: https://neuprint-yakuba.janelia.org/api/dbmeta/datasets with neuPrint error: invalid or expired jwt.

old <- choose_dyak("yakuba", set = FALSE)
str(old)
#> List of 5
#>  $ malevnc.server          : chr "https://emdata7-yakuba.janelia.org"
#>  $ malevnc.rootnode        : chr "04d73f090f864fe3ba17e57410b8c7ce"
#>  $ malevnc.dataset         : chr "yakuba"
#>  $ malevnc.neuprint        : chr "https://neuprint-yakuba.janelia.org"
#>  $ malevnc.neuprint_dataset: chr "yakuba-vnc"
# }
```
