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

test_that("xform_dyak2manc methods work and round trip", {
  skip_if_not_installed("Morpho")
  xyz_um <- rbind(
    c(60, 100, 150),
    c(170, 110, 300),
    c(120, 80, 450)
  )
  manc <- xform_dyak2manc(xyz_um, units = "microns")
  expect_equal(unname(manc), rbind(
    c(255.8648, 270.1601, 387.9610),
    c(135.3236, 182.9314, 238.1279),
    c(206.2925, 103.8081, 106.6161)
  ), tolerance = 1e-5)
  expect_equal(xform_dyak2manc(xyz_um * 1e3) / 1e3, manc, tolerance = 1e-6)
  # inverse TPS is a reverse fit, so round trips are approximate
  back <- xform_dyak2manc(manc, units = "microns", inverse = TRUE)
  expect_lt(max(abs(back - xyz_um)), 0.5)

  man <- xform_dyak2manc(xyz_um, units = "microns", method = "manual")
  expect_lt(max(sqrt(rowSums((man - manc)^2))), 15)
  back <- xform_dyak2manc(man, units = "microns", method = "manual",
                          inverse = TRUE)
  expect_lt(max(abs(back - xyz_um)), 5)
})

test_that("xform_brain uses the default xform_dyak2manc registration", {
  skip_if_not_installed("nat.templatebrains")
  skip_if_not_installed("Morpho")
  yakuba_register_xforms()
  xyz_um <- cbind(60, 100, 150)
  manc <- nat.templatebrains::xform_brain(xyz_um, sample = "yakubaum",
                                          reference = "MANC")
  expect_equal(unname(manc),
               unname(xform_dyak2manc(xyz_um, units = "microns")))
  back <- nat.templatebrains::xform_brain(manc, sample = "MANC",
                                          reference = "yakubaum")
  expect_lt(max(abs(back - xyz_um)), 0.5)
})

test_that("xform_dyak2manc ngscene method chains via malecns", {
  skip_if_not_installed("Morpho")
  skip_if_not_installed("malecns")
  skip_if_not_installed("nat.templatebrains")
  xyz_um <- cbind(120, 110, 300)
  ng <- try(xform_dyak2manc(xyz_um, units = "microns", method = "ngscene"),
            silent = TRUE)
  skip_if(inherits(ng, "try-error"), "malecnsum -> MANC bridge unavailable")
  tps <- xform_dyak2manc(xyz_um, units = "microns")
  expect_lt(sqrt(sum((ng - tps)^2)), 15)
})

test_that("dyak_lr_position assigns neuropils to the correct side", {
  skip_if_not_installed("Morpho")
  # centroids (microns) of left/right pairs of neuprint ROI meshes
  cen <- rbind(
    "LegNp(T1)(L)" = c(172.8, 107.0, 112.9),
    "LegNp(T2)(L)" = c(172.5, 144.3, 251.6),
    "LegNp(T3)(L)" = c(173.2, 108.9, 394.7),
    "WTct(UTct-T2)(L)" = c(159.9, 59.9, 216.6),
    "HTct(UTct-T3)(L)" = c(147.5, 77.1, 290.2),
    "LegNp(T1)(R)" = c(68.7, 116.6, 115.5),
    "LegNp(T2)(R)" = c(89.7, 151.4, 252.9),
    "LegNp(T3)(R)" = c(93.1, 110.6, 393.4),
    "WTct(UTct-T2)(R)" = c(80.9, 64.6, 219.2),
    "HTct(UTct-T3)(R)" = c(100.9, 79.1, 290.9)
  )
  lr <- dyak_lr_position(cen, units = "microns")
  is_left <- grepl("(L)", rownames(cen), fixed = TRUE)
  # positive values are on the fly's right
  expect_true(all(lr[is_left] < 0))
  expect_true(all(lr[!is_left] > 0))
  # partners are equidistant from the midline on average (the mean was ~ -20
  # µm without yakuba_surf_offset)
  expect_lt(abs(mean(lr[is_left] + lr[!is_left])), 4)

  # consistent with the MANC midline after transformation
  mlr <- try(malevnc::manc_lr_position(
    xform_dyak2manc(cen, units = "microns"), units = "microns"), silent = TRUE)
  skip_if(inherits(mlr, "try-error"), "manc_lr_position unavailable")
  expect_equal(sign(mlr), sign(lr))
  expect_gt(stats::cor(mlr, lr), 0.95)
})
