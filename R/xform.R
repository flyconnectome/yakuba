#' Register yakuba and MANC TPS transforms
#'
#' @description `yakuba_register_xforms()` registers a thin-plate spline
#'   transform from `yakubaum` to `MANC` using the bundled
#'   `yakuba_MANC_1000pts_tps.rds` file, and adds a simple scaling alias from
#'   `yakuba` (nm) to `yakubaum` (microns). Call once per session if the startup
#'   hook has not already done so.
#'
#' @return Invisibly returns `NULL`.
#' @export
#'
#' @examples
#' \donttest{
#' library(malevnc)
#' library(nat)
#' library(nat.templatebrains)
#' yakuba_register_xforms()
#'
#' MANC.tissue.surf.yak <- xform_brain(MANC.tissue.surf, sample = "MANC",
#'   reference = "yakuba")
#' wire3d(MANC.tissue.surf.yak)
#' }
yakuba_register_xforms <- function() {
  if (!requireNamespace("nat.templatebrains", quietly = TRUE)) {
    return(invisible(NULL))
  }

  f <- system.file("extdata", "yakuba_MANC_1000pts_tps.rds", package = "yakuba")
  if (!nzchar(f)) {
    stop("Unable to locate `yakuba_MANC_1000pts_tps.rds` in package extdata.")
  }

  yakuba_manc_tps <- readRDS(f)

  nat.templatebrains::add_reglist(
    yakuba_manc_tps,
    sample = "yakubaum",
    reference = "MANC"
  )

  nat.templatebrains::add_reglist(
    nat::reglist(diag(c(1 / 1e3, 1 / 1e3, 1 / 1e3, 1))),
    sample = "yakuba",
    reference = "yakubaum"
  )

  invisible(NULL)
}
