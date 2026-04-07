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
#> Error in (function (path, body = NULL, server = NULL, conf = NULL, parse.json = TRUE,     include_headers = TRUE, simplifyVector = FALSE, app = NULL,     ...) {    if (is.null(app))         app = paste0("neuprintr/", utils::packageVersion("neuprintr"))    req <- if (is.null(body)) {        httr::GET(url = file.path(server, path, fsep = "/"),             config = conf, httr::user_agent(app), ...)    }    else {        httr::POST(url = file.path(server, path, fsep = "/"),             body = body, config = conf, httr::user_agent(app),             ...)    }    neuprint_error_check(req)    if (parse.json) {        parsed = neuprint_parse_json(req, simplifyVector = simplifyVector)        if (length(parsed) == 2 && isTRUE(names(parsed)[2] ==             "error")) {            stop("neuPrint error: ", parsed$error)        }        if (include_headers) {            fields_to_include = c("url", "headers")            attributes(parsed) = c(attributes(parsed), req[fields_to_include])        }        parsed    }    else req})(path = path, body = body, server = server, conf = conf, parse.json = parse.json,     include_headers = include_headers, simplifyVector = simplifyVector,     app = app): Unauthorized (HTTP 401). Failed to process url: https://neuprint-yakuba.janelia.org/api/dbmeta/datasets with neuPrint error: invalid or expired jwt.
conn
#> Error: object 'conn' not found
# }
```
