# Read neuronal skeletons via neuprint

Read neuronal skeletons via neuprint

## Usage

``` r
read_dyak_neurons(
  ids,
  connectors = FALSE,
  units = c("nm", "raw", "microns"),
  heal.threshold = Inf,
  conn = NULL,
  ...,
  dataset = dyak_default_dataset()
)
```

## Arguments

- ids:

  bodyids in any form compatible with
  [`malevnc::manc_ids()`](https://natverse.org/malevnc/reference/manc_ids.html).

- connectors:

  Whether to fetch synaptic connections for the neuron (default `FALSE`
  in contrast to
  [`neuprintr::neuprint_read_neurons()`](https://natverse.org/neuprintr/reference/neuprint_read_neurons.html)).

- units:

  Units of the returned neurons (default `nm`).

- heal.threshold:

  The threshold for healing disconnected skeleton fragments. The default
  of `Inf` ensures that all fragments are joined together.

- conn:

  Optional, a `neuprint_connection` object. Defaults to
  [`dyak_neuprint()`](https://flyconnectome.github.io/yakuba/reference/dyak_neuprint.md)
  to ensure that query is against the yakuba dataset.

- ...:

  Additional arguments passed to
  [`neuprintr::neuprint_read_neurons()`](https://natverse.org/neuprintr/reference/neuprint_read_neurons.html).

- dataset:

  The name of the dataset as reported in Clio or neuprint.

## Value

A [`nat::neuronlist`](https://rdrr.io/pkg/nat/man/neuronlist.html)
object containing one or more neurons.

## See also

[`malevnc::manc_read_neurons()`](https://natverse.org/malevnc/reference/manc_read_neurons.html)

## Examples

``` r
# \donttest{
dns <- read_dyak_neurons("DNa02")
#> Error in (function (path, body = NULL, server = NULL, conf = NULL, parse.json = TRUE,     include_headers = TRUE, simplifyVector = FALSE, app = NULL,     ...) {    if (is.null(app))         app = paste0("neuprintr/", utils::packageVersion("neuprintr"))    req <- if (is.null(body)) {        httr::GET(url = file.path(server, path, fsep = "/"),             config = conf, httr::user_agent(app), ...)    }    else {        httr::POST(url = file.path(server, path, fsep = "/"),             body = body, config = conf, httr::user_agent(app),             ...)    }    neuprint_error_check(req)    if (parse.json) {        parsed = neuprint_parse_json(req, simplifyVector = simplifyVector)        if (length(parsed) == 2 && isTRUE(names(parsed)[2] ==             "error")) {            stop("neuPrint error: ", parsed$error)        }        if (include_headers) {            fields_to_include = c("url", "headers")            attributes(parsed) = c(attributes(parsed), req[fields_to_include])        }        parsed    }    else req})(path = path, body = body, server = server, conf = conf, parse.json = parse.json,     include_headers = include_headers, simplifyVector = simplifyVector,     app = app): Unauthorized (HTTP 401). Failed to process url: https://neuprint-yakuba.janelia.org/api/dbmeta/datasets with neuPrint error: invalid or expired jwt.
dns
#> Error: object 'dns' not found
# }
```
