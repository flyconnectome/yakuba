# Map XYZ locations to bodyids for the yakuba dataset

Map XYZ locations to bodyids for the yakuba dataset

## Usage

``` r
dyak_xyz2bodyid(
  xyz,
  units = c("raw", "nm", "microns", "um"),
  node = "neutu",
  cache = FALSE,
  dataset = dyak_default_dataset()
)
```

## Arguments

- xyz:

  xyz location (by default in raw yakuba pixels)

- units:

  The optional units of the incoming 3D positions. Defaults to `raw`.

- node:

  A DVID node as returned by
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.html).
  The default is to return the current active (unlocked) node being used
  through neutu.

- cache:

  Whether to cache the result of this call for 5 minutes.

- dataset:

  The name of the dataset as reported in Clio or neuprint.

## Value

A character vector of body ids (`0` is missing somas / missing
locations).

## See also

[`malevnc::manc_xyz2bodyid()`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.html)

## Examples

``` r
# \donttest{
meta <- dyak_neuprint_meta("DNa02")
#> Error in (function (path, body = NULL, server = NULL, conf = NULL, parse.json = TRUE,     include_headers = TRUE, simplifyVector = FALSE, app = NULL,     ...) {    if (is.null(app))         app = paste0("neuprintr/", utils::packageVersion("neuprintr"))    req <- if (is.null(body)) {        httr::GET(url = file.path(server, path, fsep = "/"),             config = conf, httr::user_agent(app), ...)    }    else {        httr::POST(url = file.path(server, path, fsep = "/"),             body = body, config = conf, httr::user_agent(app),             ...)    }    neuprint_error_check(req)    if (parse.json) {        parsed = neuprint_parse_json(req, simplifyVector = simplifyVector)        if (length(parsed) == 2 && isTRUE(names(parsed)[2] ==             "error")) {            stop("neuPrint error: ", parsed$error)        }        if (include_headers) {            fields_to_include = c("url", "headers")            attributes(parsed) = c(attributes(parsed), req[fields_to_include])        }        parsed    }    else req})(path = path, body = body, server = server, conf = conf, parse.json = parse.json,     include_headers = include_headers, simplifyVector = simplifyVector,     app = app): Unauthorized (HTTP 401). Failed to process url: https://neuprint-yakuba.janelia.org/api/dbmeta/datasets with neuPrint error: invalid or expired jwt.
dyak_xyz2bodyid(meta$somaLocation[1:2])
#> Error: object 'meta' not found
# }
```
