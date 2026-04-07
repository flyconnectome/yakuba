dyak_xyz <- function(xyzin, outunits = c("nm", "microns", "um", "raw"),
                     inunits = c("raw", "nm", "microns", "um"),
                     as_character = FALSE) {
  outunits <- match.arg(outunits)
  inunits <- match.arg(inunits)
  if (is.character(xyzin)) {
    xyzin <- neuprint_simplify_xyz(xyzin)
  }
  if (is.vector(xyzin) && any(is.na(xyzin))) {
    xyzin[is.na(xyzin)] <- ""
  }

  xyz <- nat::xyzmatrix(xyzin)
  if (identical(outunits, inunits)) {
    if (as_character) {
      return(nat::xyzmatrix2str(xyz))
    }
    return(xyz)
  }

  if (identical(inunits, "nm")) {
    xyz <- xyz / 8
  } else if (inunits %in% c("um", "microns")) {
    xyz <- xyz / (8 / 1000)
  }

  if (identical(outunits, "nm")) {
    xyz <- xyz * 8
  } else if (outunits %in% c("um", "microns")) {
    xyz <- xyz * 8 / 1000
  }

  if (as_character) nat::xyzmatrix2str(xyz) else xyz
}

neuprint_simplify_xyz <- function(x) {
  longform <- grepl("^list", x)
  if (any(longform)) {
    x[longform] <- sub("list\\(([0-9 ,]+)\\).*", "\\1", x[longform])
    stillbad <- grepl("^list", x[longform])
    if (any(stillbad)) {
      warning("failed to parse ", sum(stillbad), " locations. Setting to NA.")
      x[longform][stillbad] <- NA
    }
  }
  x
}

#' Get yakuba ids in standard formats
#'
#' @param ids Either numeric ids (in `character`, `numeric`, `integer` or
#'   `integer64` format) or a query expression.
#' @inheritParams malevnc::manc_ids
#' @param ... Additional arguments passed to `malevnc::manc_ids()`.
#' @inheritParams with_dyak
#'
#' @return A vector of numeric ids with mode determined by `as_character` and
#'   `integer64`.
#' @seealso [malevnc::manc_ids()]
#' @examples
#' \donttest{
#' ids <- dyak_ids("DNa02")
#' ids
#' dyak_ids("DNa02", integer64 = TRUE)
#' }
#' @export
dyak_ids <- function(ids,
                     mustWork = TRUE,
                     as_character = TRUE,
                     integer64 = FALSE,
                     unique = FALSE,
                     ...,
                     dataset = dyak_default_dataset()) {
  with_dyak(
    malevnc::manc_ids(
      ids,
      mustWork = mustWork,
      as_character = as_character,
      integer64 = integer64,
      unique = unique,
      ...
    ),
    dataset = dataset
  )
}

#' Map XYZ locations to bodyids for the yakuba dataset
#'
#' @param xyz xyz location (by default in raw yakuba pixels)
#' @param units The optional units of the incoming 3D positions. Defaults to
#'   `raw`.
#' @inheritParams malevnc::manc_xyz2bodyid
#' @inheritParams with_dyak
#'
#' @return A character vector of body ids (`0` is missing somas / missing
#'   locations).
#' @seealso [malevnc::manc_xyz2bodyid()]
#' @examples
#' \donttest{
#' meta <- dyak_neuprint_meta("DNa02")
#' dyak_xyz2bodyid(meta$somaLocation[1:2])
#' }
#' @export
dyak_xyz2bodyid <- function(xyz, units = c("raw", "nm", "microns", "um"),
                            node = "neutu", cache = FALSE,
                            dataset = dyak_default_dataset()) {
  xyzraw <- dyak_xyz(xyz, inunits = units, outunits = "raw")
  with_dyak(
    malevnc::manc_xyz2bodyid(xyzraw, node = node, cache = cache),
    dataset = dataset
  )
}
