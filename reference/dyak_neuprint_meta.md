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
#> Error in (function (path, body = NULL, server = NULL, conf = NULL, parse.json = TRUE,     include_headers = TRUE, simplifyVector = FALSE, app = NULL,     ...) {    if (is.null(app))         app = paste0("neuprintr/", utils::packageVersion("neuprintr"))    req <- if (is.null(body)) {        httr::GET(url = file.path(server, path, fsep = "/"),             config = conf, httr::user_agent(app), ...)    }    else {        httr::POST(url = file.path(server, path, fsep = "/"),             body = body, config = conf, httr::user_agent(app),             ...)    }    neuprint_error_check(req)    if (parse.json) {        parsed = neuprint_parse_json(req, simplifyVector = simplifyVector)        if (length(parsed) == 2 && isTRUE(names(parsed)[2] ==             "error")) {            stop("neuPrint error: ", parsed$error)        }        if (include_headers) {            fields_to_include = c("url", "headers")            attributes(parsed) = c(attributes(parsed), req[fields_to_include])        }        parsed    }    else req})(path = path, body = body, server = server, conf = conf, parse.json = parse.json,     include_headers = include_headers, simplifyVector = simplifyVector,     app = app): Unauthorized (HTTP 401). Failed to process url: https://neuprint-yakuba.janelia.org/api/dbmeta/datasets with neuPrint error: invalid or expired jwt.
dyak_neuprint_meta(dyak_ids("DNa02"))
#> Error in (function (path, body = NULL, server = NULL, conf = NULL, parse.json = TRUE,     include_headers = TRUE, simplifyVector = FALSE, app = NULL,     ...) {    if (is.null(app))         app = paste0("neuprintr/", utils::packageVersion("neuprintr"))    req <- if (is.null(body)) {        httr::GET(url = file.path(server, path, fsep = "/"),             config = conf, httr::user_agent(app), ...)    }    else {        httr::POST(url = file.path(server, path, fsep = "/"),             body = body, config = conf, httr::user_agent(app),             ...)    }    neuprint_error_check(req)    if (parse.json) {        parsed = neuprint_parse_json(req, simplifyVector = simplifyVector)        if (length(parsed) == 2 && isTRUE(names(parsed)[2] ==             "error")) {            stop("neuPrint error: ", parsed$error)        }        if (include_headers) {            fields_to_include = c("url", "headers")            attributes(parsed) = c(attributes(parsed), req[fields_to_include])        }        parsed    }    else req})(path = path, body = body, server = server, conf = conf, parse.json = parse.json,     include_headers = include_headers, simplifyVector = simplifyVector,     app = app): Unauthorized (HTTP 401). Failed to process url: https://neuprint-yakuba.janelia.org/api/dbmeta/datasets with neuPrint error: invalid or expired jwt.
# }
```
