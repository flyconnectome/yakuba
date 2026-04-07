dyak_default_dataset <- function() {
  getOption("yakuba.dataset", default = "yakuba")
}

normalise_dyak_dataset <- function(dataset) {
  if (is.null(dataset) || !nzchar(dataset)) {
    return("yakuba")
  }

  dataset_lc <- tolower(dataset)
  if (dataset_lc %in% c("yakuba", "yakuba-vnc", "yakubavnc")) {
    "yakuba"
  } else {
    dataset
  }
}

dyak_known_dataset_options <- function(dataset) {
  dataset <- normalise_dyak_dataset(dataset)
  if (!identical(dataset, "yakuba")) {
    return(NULL)
  }

  list(
    malevnc.dataset = dataset,
    malevnc.neuprint = "https://neuprint.janelia.org",
    malevnc.neuprint_dataset = "yakuba-vnc",
    malevnc.server = NULL,
    malevnc.rootnode = NULL
  )
}

#' Evaluate an expression after temporarily setting malevnc options
#'
#' @description `yakuba` is a thin wrapper around `malevnc`. This function
#'   temporarily changes the server/dataset options for `malevnc` while running
#'   your expression.
#'
#' @details Note that it can also temporarily switch out the active dataset for
#'   the `yakuba` package if you specify the `dataset` argument and this is
#'   different from the current active dataset. This allows you to easily run
#'   the same expression for different yakuba dataset variants.
#'
#' @param expr An expression involving `malevnc`/`yakuba` functions to evaluate
#'   with the specified autosegmentation.
#' @param dataset The name of the dataset as reported in Clio or neuprint.
#' @inheritParams malevnc::choose_malevnc_dataset
#'
#' @return `with_dyak()` returns the result of `expr`. `choose_dyak_dataset()`
#'   and `choose_dyak()` return named lists of previous option values, matching
#'   `options()`.
#' @seealso [malevnc::choose_flyem_dataset()],
#'   [malevnc::choose_malevnc_dataset()]
#' @examples
#' \donttest{
#' with_dyak(dyak_ids("DNa02"))
#'
#' old <- choose_dyak("yakuba", set = FALSE)
#' str(old)
#' }
#' @name with_dyak
#' @export
with_dyak <- function(expr, dataset = dyak_default_dataset()) {
  oldop <- choose_dyak(dataset = dataset)
  on.exit(options(oldop), add = TRUE)
  oldop2 <- choose_dyak_dataset(dataset = dataset)
  on.exit(options(oldop2), add = TRUE)
  force(expr)
}

#' Switch the default dataset for `dyak_*` functions
#'
#' @param dataset The name of the dataset as reported in Clio (usually
#'   `yakuba`), or neuprint (`yakuba-vnc`). These are aliases for the in
#'   progress production yakuba dataset. Currently there are no released
#'   datasets, but we expect those to look like e.g. `yakuba-vnc:v0.1`.
#' @description `choose_dyak_dataset()` sets the default dataset used by all
#'   `dyak_*` functions. It is the recommended way to access yakuba dataset
#'   variants. Unlike [choose_dyak()] it does *not* permanently change the
#'   default dataset used when callers use functions from the `malevnc` package
#'   directly (such as `malevnc::manc_xyz2bodyid()`). Known aliases for the main
#'   yakuba dataset do not require a live Clio lookup.
#'
#' @return A named list of previous option values, matching `options()`.
#' @examples
#' \donttest{
#' choose_dyak_dataset("yakuba")
#' dyak_ids("DNa02")
#' }
#' @export
choose_dyak_dataset <- function(dataset = "yakuba") {
  dataset <- normalise_dyak_dataset(dataset)
  if (is.null(dyak_known_dataset_options(dataset))) {
    malevnc::choose_flyem_dataset(dataset, set = FALSE)
  }

  old_dataset <- dyak_default_dataset()
  if (!identical(old_dataset, dataset)) {
    message("switching yakuba dataset from `", old_dataset, "` to `", dataset, "`")
  }

  options(yakuba.dataset = dataset)
}

#' @rdname with_dyak
#' @description `choose_dyak()` swaps out the default `malevnc` dataset for the
#'   yakuba dataset. This means that all functions from the `malevnc` package
#'   should target yakuba instead. It is recommended that you use [with_dyak()]
#'   to do this temporarily unless you have no intention of using other FlyEM
#'   datasets. *To switch the default `yakuba` dataset please see
#'   `choose_dyak_dataset()`.*
#'
#'   When Clio dataset lookup is unavailable, `choose_dyak()` falls back to a
#'   built-in neuprint-only configuration for the main yakuba dataset aliases.
#'   DVID/Clio-backed functionality may be unavailable in that session.
#' @export
choose_dyak <- function(dataset = dyak_default_dataset(), set = TRUE) {
  dataset <- normalise_dyak_dataset(dataset)
  tryCatch(
    malevnc::choose_flyem_dataset(dataset = dataset, set = set),
    error = function(e) {
      ops <- dyak_known_dataset_options(dataset)
      if (is.null(ops)) {
        stop(e)
      }

      warning(
        "Clio dataset lookup failed; falling back to baked-in neuprint settings ",
        "for `", dataset, "`. DVID/Clio-backed functionality may be unavailable ",
        "in this session.",
        call. = FALSE
      )
      if (isTRUE(set)) {
        options(ops)
      } else {
        ops
      }
    }
  )
}
