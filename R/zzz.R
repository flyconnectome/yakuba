.onLoad <- function(libname, pkgname) {
  op.yakuba <- list(
    yakuba.dataset = "yakuba"
  )
  op <- options()
  toset <- !(names(op.yakuba) %in% names(op))
  if (any(toset)) {
    options(op.yakuba[toset])
  }

  res <- try(yakuba_register_xforms(), silent = TRUE)
  if (inherits(res, "try-error")) {
    packageStartupMessage(
      "Trouble registering yakuba xforms.\n",
      "Try `yakuba_register_xforms()` after loading `nat.templatebrains`."
    )
  }

  invisible()
}
