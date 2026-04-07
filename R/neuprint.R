#' Login to yakuba neuprint server
#'
#' @details It should be possible to use the same token across public and
#'   private neuprint servers if you are using the same email address. However
#'   this does not seem to work for all users. Before giving up on this, do try
#'   using the *most* recently issued token from a private server rather than
#'   older tokens. If you need to pass a specific token you can use the `token`
#'   argument, also setting `Force=TRUE` to ensure that the specified token is
#'   used if you have already tried to log in during the current session.
#'
#' @inheritParams malevnc::manc_neuprint
#' @param dataset Allows you to override the neuprint dataset for
#'   `dyak_neuprint()` (which would otherwise be chosen based on the value of
#'   `options(yakuba.dataset)`, normally changed by [choose_dyak_dataset()]).
#' @param Force Passed to `neuprintr::neuprint_login()`.
#' @param ... Additional arguments passed to [neuprintr::neuprint_login()].
#'
#' @return A `neuprint_connection` object returned by
#'   [neuprintr::neuprint_login()].
#' @seealso [malevnc::manc_neuprint()]
#' @examples
#' \donttest{
#' conn <- dyak_neuprint()
#' conn
#' }
#' @export
dyak_neuprint <- function(token = Sys.getenv("neuprint_token"),
                          dataset = NULL, Force = FALSE, ...) {
  ops <- choose_dyak(set = FALSE)
  if (is.null(dataset)) {
    dataset <- ops$malevnc.neuprint_dataset
  }

  neuprintr::neuprint_login(
    server = ops$malevnc.neuprint,
    dataset = tolower(dataset),
    token = token,
    Force = Force,
    ...
  )
}

#' Fetch neuprint metadata for yakuba neurons
#'
#' @param ids body ids. When missing all bodies known to DVID are returned.
#' @param simplify.xyz Whether to simplify columns containing XYZ locations to a
#'   simple `"x,y,z"` format rather than a longer form referencing a schema at
#'   `spatialreference.org`. Defaults to `TRUE`.
#' @inheritParams malevnc::manc_neuprint_meta
#' @inheritParams with_dyak
#' @param conn Optional, a `neuprint_connection` object. Defaults to
#'   [dyak_neuprint()] to ensure that query is against the yakuba dataset.
#' @param ... Additional arguments passed to [neuprintr::neuprint_get_meta()].
#'
#' @return A data frame with one row for each unique input id and `NA`s for all
#'   columns except `bodyid` when neuprint holds no metadata.
#' @seealso [malevnc::manc_neuprint_meta()]
#' @examples
#' \donttest{
#' dyak_neuprint_meta("DNa02")
#' dyak_neuprint_meta(dyak_ids("DNa02"))
#' }
#' @export
dyak_neuprint_meta <- function(ids = NULL, conn = NULL, roiInfo = FALSE,
                               simplify.xyz = TRUE, cache = NA, ...,
                               dataset = dyak_default_dataset()) {
  if (is.null(conn)) {
    conn <- with_dyak(dyak_neuprint(), dataset = dataset)
  }

  res <- with_dyak(
    malevnc::manc_neuprint_meta(
      ids,
      conn = conn,
      roiInfo = roiInfo,
      fields.regex.exclude = "^col_[0-9]+",
      ...
    ),
    dataset = dataset
  )
  res$bodyid <- as.numeric(res$bodyid)

  if (isTRUE(simplify.xyz)) {
    loc_cols <- grep("Location$", colnames(res))
    for (col in loc_cols) {
      res[[col]] <- neuprint_simplify_xyz(res[[col]])
    }
  }

  if (is.null(ids)) res[order(res$bodyid), ] else res
}

#' Connectivity query for yakuba neurons
#'
#' @param ids A set of body ids (see [dyak_ids()] for a range of ways to
#'   specify these).
#' @param moredetails Either a logical (to add all fields when `TRUE`) or a
#'   character vector naming additional fields returned by
#'   `dyak_neuprint_meta()` that will be added to the results data frame.
#' @param conn Optional, a `neuprint_connection` object. Defaults to
#'   [dyak_neuprint()] to ensure that query is against the yakuba dataset.
#' @inheritParams malevnc::manc_connection_table
#' @inheritParams neuprintr::neuprint_connection_table
#' @inheritParams with_dyak
#' @param ... Additional arguments passed to
#'   [neuprintr::neuprint_connection_table()].
#' @param dataset The name of the dataset as reported in Clio e.g. `yakuba`,
#'   `yakuba-vnc` etc. `yakuba`, `yakuba-vnc` and `yakubavnc` are treated as
#'   aliases for the main yakuba dataset.
#'
#' @return A data frame.
#' @seealso [malevnc::manc_connection_table()]
#' @examples
#' \donttest{
#' dyak_connection_table("DNa02", partners = "outputs")
#' dyak_connection_table("DNa02", partners = "outputs", summary = TRUE)
#' }
#' @export
dyak_connection_table <- function(ids, partners = c("inputs", "outputs"),
                                  moredetails = c(
                                    "class", "group", "type", "somaSide",
                                    "somaNeuromere", "hemilineage"
                                  ),
                                  summary = FALSE, threshold = 1L,
                                  roi = NULL, by.roi = FALSE, conn = NULL, ...,
                                  dataset = dyak_default_dataset()) {
  if (is.null(conn)) {
    conn <- with_dyak(dyak_neuprint(), dataset = dataset)
  }

  ids <- dyak_ids(ids, dataset = dataset)
  res <- neuprintr::neuprint_connection_table(
    ids,
    partners = partners,
    details = TRUE,
    threshold = threshold,
    conn = conn,
    summary = summary,
    roi = roi,
    by.roi = by.roi,
    ...
  )

  if (!is.logical(moredetails)) {
    extrafields <- moredetails
    moredetails <- TRUE
  } else {
    extrafields <- NULL
  }

  if (isTRUE(moredetails) && nrow(res) > 0) {
    dets <- dyak_neuprint_meta(unique(res$partner), conn = conn, dataset = dataset)
    if (is.null(extrafields)) {
      extrafields <- setdiff(colnames(dets), colnames(res))
    }
    dets <- dets[union("bodyid", extrafields)]
    res <- dplyr::left_join(res, dets, by = c("partner" = "bodyid"))
  }

  res
}
