#' @keywords internal
#' @import pbapply
#'
#' @section Bridging registrations: `yakuba` registers a bundled thin-plate
#'   spline transform from `yakubaum` to `MANC` at package startup when
#'   `nat.templatebrains` is available. A simple scaling alias is also added
#'   from `yakuba` (nm) to `yakubaum` (microns), so
#'   `nat.templatebrains::xform_brain()` can chain from `yakuba` to `MANC`.
#'
#'   Note the current registration (which lives in inst/extdata) was computed by
#'   Sebastian Cachero in April 2025. See [slack for
#'   details](https://flyem-cns.slack.com/archives/C07SFDC909W/p1744652271402679?thread_ts=1744645357.564199&cid=C07SFDC909W)
#'
#' @section Package Options:
#'   There is currently one package option:
#'
#'   \itemize{
#'   \item `yakuba.dataset` keeps track of the active yakuba dataset.
#'   }
#'
#'   You can use this to run your code against the production yakuba dataset or
#'   future snapshot variants. The main ways to do this are:
#'
#'   \enumerate{
#'   \item Use [with_dyak()] to run one expression without changing the default
#'   yakuba dataset.
#'   \item Use [choose_dyak_dataset()] to choose a default yakuba dataset for
#'   the rest of the session.
#'   \item Expert users may set the `yakuba.dataset` option directly in their
#'   `.Rprofile`.
#'   }
#'
#' @examples
#' \donttest{
#' options()[grepl("^yakuba", names(options()))]
#' }
#'
#' \donttest{
#' library(malevnc)
#' library(nat)
#' library(nat.templatebrains)
#'
#' MANC.tissue.surf.yak = nat.templatebrains::xform_brain(
#'   MANC.tissue.surf,
#'   sample = "MANC",
#'   reference = "yakuba"
#' )
#' wire3d(MANC.tissue.surf.yak)
#'
#' dna02 = read_dyak_neurons("DNa02")
#' plot3d(dna02, lwd = 3)
#'
#' # nb the default template space for MANC is calibrated in microns
#' # but for yakuba we use nm
#' dna02.manc = malevnc::manc_read_neurons("DNa02", units = "microns")
#' dna02.manc.yak = nat.templatebrains::xform_brain(
#'   dna02.manc,
#'   reference = "yakuba",
#'   sample = "MANC"
#' )
#' # set up nice coords for the plot
#' plot3d(dna02.manc.yak, col = "black", lwd = 2)
#' #' }
"_PACKAGE"
## usethis namespace: start
## usethis namespace: end
NULL
