#' Register yakuba and MANC TPS transforms
#'
#' @description `yakuba_register_xforms()` registers a thin-plate spline
#'   transform from `yakubaum` to `MANC` using the bundled
#'   `yakuba_MANC_1000pts_tps.rds` file, and adds a simple scaling alias from
#'   `yakuba` (nm) to `yakubaum` (microns). It also registers a thin-plate
#'   spline from `yakubaum` to the symmetric template `yakubasym` (see
#'   [mirror_dyak()]). Call once per session if the startup hook has not
#'   already done so.
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

  f_sym <- system.file("extdata", "yakuba_yakubaSym_1000pts_tps.rds",
                       package = "yakuba", mustWork = TRUE)
  nat.templatebrains::add_reglist(
    readRDS(f_sym),
    sample = "yakubaum",
    reference = "yakubasym"
  )

  invisible(NULL)
}

#' Mirror yakuba neurons or points to the opposite side of the VNC
#'
#' @description `mirror_dyak()` mirrors neurons, surfaces and other point data
#'   in yakuba space to the opposite side of the VNC.
#'
#'   `symmetric_dyak()` transforms objects onto a symmetrised version of the
#'   yakuba template, optionally mirroring across the midline.
#'
#' @details Mirroring maps `x` into the symmetric [yakubasym] space with a
#'   bundled thin-plate spline registration (`yakuba_yakubaSym_1000pts_tps.rds`,
#'   computed by Sebastian Cachero), flips across the X axis and then maps back
#'   with the inverse registration. The registration is defined in microns;
#'   nm inputs are scaled before and after transformation. Requires the
#'   suggested `Morpho` package.
#'
#'   Denser versions of the registration (10000 points) were also computed but
#'   gave < 1 µm change in mirrored positions at ~500x the compute cost.
#'
#' @param x An object compatible with [nat::xform()] (neuron, neuronlist,
#'   dotprops, surface, coordinate matrix etc).
#' @param units Coordinate units of `x` and the returned object. Defaults to
#'   nm, matching [read_dyak_neurons()].
#' @param subset Optional subset passed to [nat::xform()], e.g. when
#'   transforming selected elements of a neuronlist.
#' @param ... Additional arguments passed to [nat::xform()].
#'
#' @return A transformed object of the same kind as `x`, in the same `units`.
#' @export
#' @seealso [yakubasym]
#' @examples
#' \dontrun{
#' dna02 <- read_dyak_neurons("DNa02")
#' dna02.m <- mirror_dyak(dna02)
#' plot3d(dna02, col = "black")
#' plot3d(dna02.m, col = "red")
#' }
mirror_dyak <- function(x, units = c("nm", "microns"), subset = NULL, ...) {
  units <- match.arg(units)
  reg <- yakuba_sym_reg()
  x_sym <- symmetric_dyak(x, units = units, mirror = TRUE, subset = subset, ...)
  x_um <- if (units == "nm") x_sym / 1e3 else x_sym
  x_m <- nat::xform(x_um, reg = nat::reglist(reg, swap = TRUE),
                    subset = subset, ...)
  if (units == "nm") x_m * 1e3 else x_m
}

#' @rdname mirror_dyak
#' @param mirror Whether to mirror across the midline of the symmetric space.
#' @details `symmetric_dyak()` returns objects in [yakubasym] space, using
#'   `units` for both input and output.
#' @export
#' @examples
#' \dontrun{
#' # DNa02 neurons and their mirror images in symmetric space
#' dna02.sym <- symmetric_dyak(dna02)
#' dna02.sym.m <- symmetric_dyak(dna02, mirror = TRUE)
#' }
symmetric_dyak <- function(x, units = c("nm", "microns"), mirror = FALSE,
                           subset = NULL, ...) {
  units <- match.arg(units)
  x_um <- if (units == "nm") x / 1e3 else x
  xt <- nat::xform(x_um, reg = yakuba_sym_reg(), subset = subset, ...)
  if (isTRUE(mirror)) {
    xt <- nat::mirror(
      xt,
      mirrorAxisSize = sum(yakubasym$BoundingBox[, 1]),
      mirrorAxis = "X",
      transform = "flip"
    )
  }
  if (units == "nm") xt * 1e3 else xt
}

#' Calculate the left-right position wrt to the symmetrised yakuba midline
#'
#' @description Returns the signed left-right position of points with respect
#'   to the midline of the symmetric yakuba template, analogous to
#'   `malevnc::manc_lr_position()`.
#'
#' @details Points are mapped into [yakubasym] space and the X coordinate of
#'   each point is compared with that of its mirror image. As in
#'   `manc_lr_position()`, the returned value is this mirror displacement,
#'   i.e. *twice* the distance from the midline. Note that the X axis of the
#'   yakuba dataset points to the fly's left (opposite to MANC); the sign is
#'   adjusted so that positive values are on the fly's right in both packages.
#'
#' @param x An object containing XYZ vertex locations, compatible with
#'   [nat::xyzmatrix()].
#' @param units Units of `x` and of the returned displacement.
#' @param ... Additional arguments passed to [nat::xform()].
#'
#' @return A numeric vector of point displacements (in `units`) where 0 is at
#'   the midline and positive values are to the fly's right.
#' @export
#' @seealso [mirror_dyak()]
#' @examples
#' \dontrun{
#' dna02 <- read_dyak_neurons("DNa02")
#' # mean position of each neuron: positive values are on the fly's right
#' sapply(dna02, function(n) mean(dyak_lr_position(n)))
#' # colour points: red for left, green for right (nautical convention)
#' xyz <- nat::xyzmatrix(dna02[[1]])
#' points3d(xyz, col = ifelse(dyak_lr_position(xyz) < 0, "red", "green"))
#' }
dyak_lr_position <- function(x, units = c("nm", "microns"), ...) {
  units <- match.arg(units)
  xyz <- nat::xyzmatrix(x)
  xyzt <- symmetric_dyak(xyz, units = units, ...)
  xyzt2 <- symmetric_dyak(xyz, units = units, mirror = TRUE, ...)
  unname(xyzt2[, 1] - xyzt[, 1])
}

#' Symmetric yakuba VNC template
#'
#' @description A `templatebrain` object describing the symmetrised yakuba VNC
#'   template (in microns) used by [mirror_dyak()] and [symmetric_dyak()].
#' @format A `templatebrain` object (see `nat.templatebrains::templatebrain`).
#' @export
yakubasym <- structure(
  list(
    name = "yakubaVNCdisplaced-5_yakubaVNCdisplacedH_01_warpSym-1",
    regName = "yakubasym",
    type = "Symmetrised yakuba VNC template",
    sex = "M",
    dims = c(459L, 439L, 1027L),
    voxdims = c(0.512, 0.512, 0.512),
    origin = c(0, 0, 0),
    BoundingBox = structure(
      c(0, 234.496, 0, 224.256, 0, 525.312),
      dim = 2:3,
      class = "boundingbox"
    ),
    units = c("microns", "microns", "microns"),
    description = NULL,
    doi = NULL
  ),
  class = "templatebrain"
)

# internal: read (once) the yakubaum -> yakubasym TPS registration
yakuba_sym_reg <- function() {
  if (is.null(.yakuba_state$sym_reg)) {
    if (!requireNamespace("Morpho", quietly = TRUE)) {
      stop("Please install suggested package: Morpho", call. = FALSE)
    }
    f <- system.file("extdata", "yakuba_yakubaSym_1000pts_tps.rds",
                     package = "yakuba", mustWork = TRUE)
    .yakuba_state$sym_reg <- readRDS(f)
  }
  .yakuba_state$sym_reg
}
