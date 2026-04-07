# yakuba: Access the Drosophila yakuba FlyEM Dataset

Provides a thin wrapper around the 'malevnc' package for working with
the Drosophila yakuba male VNC neuprint and annotation datasets.

## Bridging registrations

`yakuba` registers a bundled thin-plate spline transform from `yakubaum`
to `MANC` at package startup when `nat.templatebrains` is available. A
simple scaling alias is also added from `yakuba` (nm) to `yakubaum`
(microns), so
[`nat.templatebrains::xform_brain()`](https://natverse.org/nat.templatebrains/reference/xform_brain.html)
can chain from `yakuba` to `MANC`.

Note the current registration (which lives in inst/extdata) was computed
by Sebastian Cachero in April 2025. See [slack for
details](https://flyem-cns.slack.com/archives/C07SFDC909W/p1744652271402679?thread_ts=1744645357.564199&cid=C07SFDC909W)

## Package Options

There is currently one package option:

- `yakuba.dataset` keeps track of the active yakuba dataset.

You can use this to run your code against the production yakuba dataset
or future snapshot variants. The main ways to do this are:

1.  Use
    [`with_dyak()`](https://flyconnectome.github.io/yakuba/reference/with_dyak.md)
    to run one expression without changing the default yakuba dataset.

2.  Use
    [`choose_dyak_dataset()`](https://flyconnectome.github.io/yakuba/reference/choose_dyak_dataset.md)
    to choose a default yakuba dataset for the rest of the session.

3.  Expert users may set the `yakuba.dataset` option directly in their
    `.Rprofile`.

## See also

Useful links:

- <https://github.com/flyconnectome/yakuba>

- Report bugs at <https://github.com/flyconnectome/yakuba/issues>

## Author

**Maintainer**: Gregory Jefferis <jefferis@gmail.com>
([ORCID](https://orcid.org/0000-0002-0587-9355))

## Examples

``` r
# \donttest{
options()[grepl("^yakuba", names(options()))]
#> $yakuba.dataset
#> [1] "yakuba"
#> 
# }

# \donttest{
library(malevnc)
library(nat)
#> Loading required package: rgl
#> Some nat functions depend on a CMTK installation. See ?cmtk and README.md for details.
#> 
#> Attaching package: ‘nat’
#> The following object is masked from ‘package:rgl’:
#> 
#>     wire3d
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, union
library(nat.templatebrains)

MANC.tissue.surf.yak = nat.templatebrains::xform_brain(
  MANC.tissue.surf,
  sample = "MANC",
  reference = "yakuba"
)
#> Error in loadNamespace(x): there is no package called ‘Morpho’
wire3d(MANC.tissue.surf.yak)
#> Error: object 'MANC.tissue.surf.yak' not found

dna02 = read_dyak_neurons("DNa02")
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
plot3d(dna02, lwd = 3)
#> Error: object 'dna02' not found

# nb the default template space for MANC is calibrated in microns
# but for yakuba we use nm
dna02.manc = malevnc::manc_read_neurons("DNa02", units = "microns")
#> Error in (function (path, body = NULL, server = NULL, conf = NULL, parse.json = TRUE,     include_headers = TRUE, simplifyVector = FALSE, app = NULL,     ...) {    if (is.null(app))         app = paste0("neuprintr/", utils::packageVersion("neuprintr"))    req <- if (is.null(body)) {        httr::GET(url = file.path(server, path, fsep = "/"),             config = conf, httr::user_agent(app), ...)    }    else {        httr::POST(url = file.path(server, path, fsep = "/"),             body = body, config = conf, httr::user_agent(app),             ...)    }    neuprint_error_check(req)    if (parse.json) {        parsed = neuprint_parse_json(req, simplifyVector = simplifyVector)        if (length(parsed) == 2 && isTRUE(names(parsed)[2] ==             "error")) {            stop("neuPrint error: ", parsed$error)        }        if (include_headers) {            fields_to_include = c("url", "headers")            attributes(parsed) = c(attributes(parsed), req[fields_to_include])        }        parsed    }    else req})(path = path, body = body, server = server, conf = conf, parse.json = parse.json,     include_headers = include_headers, simplifyVector = simplifyVector,     app = app): Unauthorized (HTTP 401). Failed to process url: https://neuprint.janelia.org/api/dbmeta/datasets with neuPrint error: Please provide valid credentials.
dna02.manc.yak = nat.templatebrains::xform_brain(
  dna02.manc,
  reference = "yakuba",
  sample = "MANC"
)
#> Error: object 'dna02.manc' not found
# set up nice coords for the plot
plot3d(dna02.manc.yak, col = "black", lwd = 2)
#> Error: object 'dna02.manc.yak' not found
#' # }
```
