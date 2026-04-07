#' Return neurojson body annotations via the Clio interface
#'
#' @details In comparison with `dyak_neuprint_meta()`, this provides access to
#'   up to the second annotations; it is also presently faster than that call.
#'   Compared with `dyak_neuprint_meta()`, it does not produce a stable set of
#'   columns, only returning those that exist for the given query ids.
#'
#' @inheritParams malevnc::manc_body_annotations
#' @inheritParams with_dyak
#' @param dataset The name of the dataset as reported in Clio e.g. `yakuba`,
#'   `yakuba-vnc` etc. `yakuba`, `yakuba-vnc` and `yakubavnc` are treated as
#'   aliases for the main yakuba dataset.
#' @param ... Additional arguments passed to [pbapply::pblapply()].
#'
#' @return A data frame with metadata.
#' @seealso [malevnc::manc_body_annotations()]
#' @examples
#' \donttest{
#' dyak_body_annotations("DNa02")
#' }
#' @export
dyak_body_annotations <- function(ids = NULL, query = NULL, json = FALSE,
                                  config = NULL,
                                  show.extra = c("none", "user", "time", "all"),
                                  cache = FALSE, test = FALSE, ...,
                                  dataset = dyak_default_dataset()) {
  show.extra <- match.arg(show.extra)
  with_dyak(
    malevnc::manc_body_annotations(
      ids = ids,
      query = query,
      json = json,
      config = config,
      show.extra = show.extra,
      cache = cache,
      test = test,
      ...
    ),
    dataset = dataset
  )
}

#' Set Clio body annotations
#'
#' @details Details of the Clio body annotation system are provided in
#'   [malevnc::manc_annotate_body()]. It can take some time to apply
#'   annotations, so requests are chunked by default in groups of 50.
#'
#'   A single column called `position` or 3 columns named `x`, `y`, `z` or `X`,
#'   `Y`, `Z` in any form accepted by [nat::xyzmatrix()] will be converted to a
#'   position stored with each record. This is recommended when creating
#'   records.
#'
#'   When `protect=TRUE` no data in Clio will be overwritten, only new data
#'   will be added. When `protect=FALSE` all fields will be overwritten by new
#'   data for each non-empty value in `x`. If `write_empty_fields=TRUE` then
#'   even empty fields in `x` will overwrite fields in the database.
#'
#' @section Validation:
#'   Validation depends on how you provide your input data. If `x` is a data
#'   frame then each row is checked for some basics including the presence of a
#'   `bodyid`, and empty fields are removed. We also check field types against
#'   the active yakuba Clio schema by default.
#'
#' @section Users:
#'   Clio records a user and timestamp for every modification to fields in a
#'   record. By default your email address from the Clio token will be used. You
#'   can specify an alternate user with the `designated_user` argument; see
#'   [malevnc::manc_annotate_body()] for details.
#'
#' @param x A data frame, list or JSON string containing body annotations. End
#'   users are strongly recommended to use data frames.
#' @param version Optional Clio version to associate with this annotation. The
#'   default `NULL` uses the current version returned by the API.
#' @param test Whether to use the test Clio store (recommended until you are
#'   sure that you know what you are doing).
#' @param write_empty_fields When `x` is a data frame, this controls whether
#'   empty fields in `x` overwrite fields in the Clio database.
#' @param designated_user Optional alternate user recorded in Clio for the
#'   annotation.
#' @param protect Vector of fields that will not be overwritten if they already
#'   have a value in Clio. Set to `TRUE` to protect all fields and to `FALSE` to
#'   overwrite all fields for which you provide data.
#' @param chunksize When you have many bodies to annotate the request will by
#'   default be sent 50 records at a time to avoid timeouts. Set to `Inf` to
#'   insist that all records are sent in a single request.
#' @param check_types Whether to verify data-frame column types against the
#'   active yakuba Clio schema.
#' @param ... Additional parameters passed to [pbapply::pbsapply()].
#' @inheritParams with_dyak
#'
#' @return `NULL` invisibly on success. Errors out on failure.
#' @seealso [malevnc::manc_annotate_body()]
#' @examples
#' \dontrun{
#' ids <- dyak_ids("DNa02", as_character = FALSE)
#' yakuba_annotate_body(
#'   data.frame(bodyid = ids[1], group = min(ids)),
#'   test = TRUE
#' )
#' }
#' @export
yakuba_annotate_body <- function(x, test = TRUE, version = NULL,
                                 write_empty_fields = FALSE,
                                 designated_user = NULL,
                                 protect = c("user"), chunksize = 50,
                                 check_types = TRUE, ...,
                                 dataset = dyak_default_dataset()) {
  if (is.data.frame(x) && "bodyid" %in% colnames(x)) {
    x$bodyid <- dyak_ids(x$bodyid, as_character = FALSE, unique = FALSE,
                         dataset = dataset)
  }
  with_dyak(
    malevnc::manc_annotate_body(
      x,
      test = test,
      version = version,
      designated_user = designated_user,
      write_empty_fields = write_empty_fields,
      protect = protect,
      chunksize = chunksize,
      check_types = check_types,
      query = FALSE,
      ...
    ),
    dataset = dataset
  )
}

#' Check if a bodyid still exists in the specified yakuba DVID node
#'
#' @details For details (and there are some) please see
#'   [malevnc::manc_islatest()].
#'
#' @inheritParams malevnc::manc_islatest
#' @inheritParams with_dyak
#'
#' @return A logical vector ordered by input ids.
#' @seealso [malevnc::manc_islatest()]
#' @examples
#' \donttest{
#' dyak_islatest(c(10280,10490))
#' }
#' @export
dyak_islatest <- function(ids, node = "neutu",
                          method = c("auto", "size", "sparsevol"),
                          dataset = dyak_default_dataset()) {
  ids <- dyak_ids(ids, dataset = dataset)
  with_dyak(
    malevnc::manc_islatest(ids, node = node, method = method),
    dataset = dataset
  )
}

#' Read neuronal skeletons via neuprint
#'
#' @param ids bodyids in any form compatible with `malevnc::manc_ids()`.
#' @param connectors Whether to fetch synaptic connections for the neuron
#'   (default `FALSE` in contrast to [neuprintr::neuprint_read_neurons()]).
#' @param ... Additional arguments passed to
#'   [neuprintr::neuprint_read_neurons()].
#' @param units Units of the returned neurons (default `nm`).
#' @param heal.threshold The threshold for healing disconnected skeleton
#'   fragments. The default of `Inf` ensures that all fragments are joined
#'   together.
#' @inheritParams with_dyak
#' @param conn Optional, a `neuprint_connection` object. Defaults to
#'   [dyak_neuprint()] to ensure that query is against the yakuba dataset.
#'
#' @return A `nat::neuronlist` object containing one or more neurons.
#' @seealso [malevnc::manc_read_neurons()]
#' @examples
#' \donttest{
#' dns <- read_dyak_neurons("DNa02")
#' dns
#' }
#' @export
read_dyak_neurons <- function(ids, connectors = FALSE,
                              units = c("nm", "raw", "microns"),
                              heal.threshold = Inf, conn = NULL, ...,
                              dataset = dyak_default_dataset()) {
  units <- match.arg(units)
  if (is.null(conn)) {
    conn <- with_dyak(dyak_neuprint(), dataset = dataset)
  }

  res <- with_dyak(
    malevnc::manc_read_neurons(
      ids,
      conn = conn,
      connectors = connectors,
      heal.threshold = heal.threshold,
      ...
    ),
    dataset = dataset
  )

  switch(units, nm = res * rep(8, 4), microns = res * rep(8 / 1000, 4), res)
}
