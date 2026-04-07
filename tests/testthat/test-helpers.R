test_that("yakuba dataset aliases normalise to the main dataset", {
  expect_equal(yakuba:::normalise_dyak_dataset("yakuba"), "yakuba")
  expect_equal(yakuba:::normalise_dyak_dataset("yakuba-vnc"), "yakuba")
  expect_equal(yakuba:::normalise_dyak_dataset("yakubavnc"), "yakuba")
})

test_that("dyak_xyz converts between raw and nanometres", {
  xyz_raw <- matrix(c(1, 2, 3), ncol = 3)
  xyz_nm <- yakuba:::dyak_xyz(xyz_raw, inunits = "raw", outunits = "nm")
  expect_equal(unname(as.vector(xyz_nm)), c(8, 16, 24))

  xyz_raw_roundtrip <- yakuba:::dyak_xyz(xyz_nm, inunits = "nm", outunits = "raw")
  expect_equal(unname(as.vector(xyz_raw_roundtrip)), c(1, 2, 3))
})

test_that("neuprint_simplify_xyz strips list wrappers", {
  expect_equal(
    yakuba:::neuprint_simplify_xyz("list(1, 2, 3)"),
    "1, 2, 3"
  )
})
