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

test_that("mirror_dyak mirrors and round trips", {
  skip_if_not_installed("Morpho")

  # points inside the yakuba VNC (microns)
  xyz_um <- rbind(
    c(60, 100, 150),
    c(170, 110, 300),
    c(120, 80, 450)
  )
  m <- mirror_dyak(xyz_um, units = "microns")
  expect_equal(dim(m), dim(xyz_um))
  # points swap sides of the midline
  mid <- sum(yakubasym$BoundingBox[, 1]) / 2
  sym <- symmetric_dyak(xyz_um, units = "microns")
  sym_m <- symmetric_dyak(xyz_um, units = "microns", mirror = TRUE)
  expect_equal(sign(sym[, 1] - mid), -sign(sym_m[, 1] - mid))
  expect_gt(min(abs(m[, 1] - xyz_um[, 1])), 10)

  # mirroring twice returns the original points
  mm <- mirror_dyak(m, units = "microns")
  expect_lt(max(sqrt(rowSums((mm - xyz_um)^2))), 0.2)

  # nm and microns agree
  m_nm <- mirror_dyak(xyz_um * 1e3)
  expect_equal(m_nm / 1e3, m, tolerance = 1e-6)
})

test_that("yakubasym registration is available to xform_brain", {
  skip_if_not_installed("nat.templatebrains")
  skip_if_not_installed("Morpho")
  yakuba_register_xforms()
  xyz_um <- cbind(60, 100, 150)
  expect_equal(
    unname(nat.templatebrains::xform_brain(xyz_um, sample = "yakubaum",
                                           reference = "yakubasym")),
    unname(symmetric_dyak(xyz_um, units = "microns"))
  )
})

test_that("dyak_lr_position gives signed midline displacement", {
  skip_if_not_installed("Morpho")

  # points on either side in yakubasym space, mapped back to yakuba (microns).
  # Low X in yakuba is the fly's right (checked against MANC via the
  # yakuba -> MANC registration)
  sym <- rbind(c(60, 100, 200), c(175, 100, 200))
  xyz_um <- nat::xform(sym, reg = nat::invert_reglist(yakuba_sym_reg()))
  lr <- dyak_lr_position(xyz_um, units = "microns")
  expect_length(lr, 2L)
  expect_gt(lr[1], 0)
  expect_lt(lr[2], 0)
  mid <- sum(yakubasym$BoundingBox[, 1]) / 2
  expect_equal(abs(lr), 2 * abs(sym[, 1] - mid), tolerance = 1e-3)

  expect_equal(dyak_lr_position(xyz_um * 1e3), lr * 1e3, tolerance = 1e-6)
})

test_that("mirror_dyak maps the neuropil shell onto itself", {
  skip_if_not_installed("Morpho")
  set.seed(42)
  v <- nat::xyzmatrix(yakuba_neuropil_shell)
  m <- mirror_dyak(v[sample(nrow(v), 2000), ], units = "microns")
  # ~5 µm without the offset to the frame of the symmetrising registration
  expect_lt(stats::median(nabor::knn(v, m, k = 1)$nn.dists), 3)
})
