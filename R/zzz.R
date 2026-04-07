.yakuba_state <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  op.yakuba <- list(
    yakuba.dataset = "yakuba"
  )
  op <- options()
  toset <- !(names(op.yakuba) %in% names(op))
  if (any(toset)) {
    options(op.yakuba[toset])
  }

  .yakuba_state$xform_registration_failed <- FALSE
  res <- try(yakuba_register_xforms(), silent = TRUE)
  if (inherits(res, "try-error")) {
    .yakuba_state$xform_registration_failed <- TRUE
  }

  invisible()
}

.onAttach <- function(libname, pkgname) {
  if (isTRUE(.yakuba_state$xform_registration_failed)) {
    packageStartupMessage(
      "Trouble registering yakuba xforms.\n",
      "Try `yakuba_register_xforms()` after loading `nat.templatebrains`."
    )
  }

  invisible()
}
