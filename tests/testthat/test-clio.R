test_that("yakuba clio read wrappers work", {
  skip_if(inherits(try(malevnc:::clio_token(), silent = TRUE), "try-error"),
          message = "no clio token available")

  ids <- head(dyak_ids("DNa02"), 2)
  expect_length(ids, 2)

  ann <- dyak_body_annotations(ids[1], show.extra = "user")
  expect_s3_class(ann, "data.frame")
  expect_equal(as.character(ann$bodyid), ids[1])
  expect_true(any(grepl("_user$", colnames(ann))))

  expect_true(dyak_islatest(as.numeric(ids[1])))
})
