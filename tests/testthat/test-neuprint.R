test_that("yakuba neuprint wrappers work", {
  conn <- try(dyak_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "yakuba neuprint connection unavailable")

  expect_s3_class(conn, "neuprint_connection")

  ids <- head(dyak_ids("DNa02"), 2)
  expect_length(ids, 2)
  expect_type(ids, "character")

  ids_num <- dyak_ids(ids, as_character = FALSE, unique = FALSE)
  expect_length(ids_num, 2)
  expect_type(ids_num, "double")

  meta <- dyak_neuprint_meta(ids, conn = conn)
  expect_s3_class(meta, "data.frame")
  expect_equal(sort(as.character(meta$bodyid)), sort(ids))
  expect_true(all(c("bodyid", "type") %in% colnames(meta)))

  if ("somaLocation" %in% colnames(meta) && all(!is.na(meta$somaLocation))) {
    expect_equal(
      sort(dyak_xyz2bodyid(meta$somaLocation, dataset = "yakuba")),
      sort(as.character(meta$bodyid))
    )
  }

  ct <- dyak_connection_table(ids[1], partners = "outputs", conn = conn)
  expect_s3_class(ct, "data.frame")
  expect_true(nrow(ct) > 0)
  expect_true("partner" %in% colnames(ct))

  neurons <- suppressWarnings(read_dyak_neurons(ids[1], conn = conn))
  expect_s3_class(neurons, "neuronlist")
  expect_length(neurons, 1)
})

test_that("yakuba dataset selection helpers work", {
  prev <- choose_dyak_dataset("yakuba")
  on.exit(options(prev), add = TRUE)

  expect_equal(getOption("yakuba.dataset"), "yakuba")

  ops <- choose_dyak("yakuba", set = FALSE)
  expect_true(is.list(ops))
  expect_true(all(c("malevnc.dataset", "malevnc.neuprint_dataset") %in% names(ops)))

  expect_identical(with_dyak(getOption("yakuba.dataset"), dataset = "yakuba"), "yakuba")
})
