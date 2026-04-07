test_that("yakuba xform registration works", {
  skip_if_not_installed("nat.templatebrains")

  expect_no_error(yakuba_register_xforms())

  xyz_nm <- cbind(1000, 2000, 3000)
  xyz_um <- nat.templatebrains::xform_brain(
    xyz_nm,
    sample = "yakuba",
    reference = "yakubaum"
  )
  expect_equal(unname(as.vector(xyz_um)), c(1, 2, 3))

  xyz_manc <- nat.templatebrains::xform_brain(
    xyz_um,
    sample = "yakubaum",
    reference = "MANC"
  )
  expect_true(is.matrix(xyz_manc))
  expect_equal(dim(xyz_manc), c(1L, 3L))

  xyz_manc2 <- nat.templatebrains::xform_brain(
    xyz_nm,
    sample = "yakuba",
    reference = "MANC"
  )
  expect_true(is.matrix(xyz_manc2))
  expect_equal(dim(xyz_manc2), c(1L, 3L))
})
