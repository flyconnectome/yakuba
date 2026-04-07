# Switch the default dataset for `dyak_*` functions

`choose_dyak_dataset()` sets the default dataset used by all `dyak_*`
functions. It is the recommended way to access yakuba dataset variants.
Unlike
[`choose_dyak()`](https://flyconnectome.github.io/yakuba/reference/with_dyak.md)
it does *not* permanently change the default dataset used when callers
use functions from the `malevnc` package directly (such as
[`malevnc::manc_xyz2bodyid()`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.html)).
Known aliases for the main yakuba dataset do not require a live Clio
lookup.

## Usage

``` r
choose_dyak_dataset(dataset = "yakuba")
```

## Arguments

- dataset:

  The name of the dataset as reported in Clio (usually `yakuba`), or
  neuprint (`yakuba-vnc`). These are aliases for the in progress
  production yakuba dataset. Currently there are no released datasets,
  but we expect those to look like e.g. `yakuba-vnc:v0.1`.

## Value

A named list of previous option values, matching
[`options()`](https://rdrr.io/r/base/options.html).

## Examples

``` r
# \donttest{
choose_dyak_dataset("yakuba")
dyak_ids("DNa02")
#> Error in (function (path, body = NULL, server = NULL, conf = NULL, parse.json = TRUE,     include_headers = TRUE, simplifyVector = FALSE, app = NULL,     ...) {    if (is.null(app))         app = paste0("neuprintr/", utils::packageVersion("neuprintr"))    req <- if (is.null(body)) {        httr::GET(url = file.path(server, path, fsep = "/"),             config = conf, httr::user_agent(app), ...)    }    else {        httr::POST(url = file.path(server, path, fsep = "/"),             body = body, config = conf, httr::user_agent(app),             ...)    }    neuprint_error_check(req)    if (parse.json) {        parsed = neuprint_parse_json(req, simplifyVector = simplifyVector)        if (length(parsed) == 2 && isTRUE(names(parsed)[2] ==             "error")) {            stop("neuPrint error: ", parsed$error)        }        if (include_headers) {            fields_to_include = c("url", "headers")            attributes(parsed) = c(attributes(parsed), req[fields_to_include])        }        parsed    }    else req})(path = path, body = body, server = server, conf = conf, parse.json = parse.json,     include_headers = include_headers, simplifyVector = simplifyVector,     app = app): Unauthorized (HTTP 401). Failed to process url: https://neuprint-yakuba.janelia.org/api/dbmeta/datasets with neuPrint error: invalid or expired jwt.
# }
```
