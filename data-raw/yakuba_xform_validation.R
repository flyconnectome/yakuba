# Validation of the yakuba -> MANC registrations and of the yakuba_surf_offset
# correction (see data-raw/yakuba_surf_offset.R and
# vignettes/articles/yakuba-transforms.Rmd). Needs neuprint access to the
# yakuba and MANC datasets and (for "ngscene") the malecns package.
library(nat)
library(malevnc)
devtools::load_all()

# translation-only ICP: median shift needed to move p onto ref
icp_t <- function(p, ref, n = 20) {
  # the malecnsum -> MANC bridge gives NA outside its domain
  p <- p[stats::complete.cases(p), , drop = FALSE]
  t <- c(0, 0, 0)
  for (i in 1:n) {
    q <- sweep(p, 2, t, "+")
    t <- t + apply(ref[nabor::knn(ref, q, k = 1)$nn.idx[, 1], ] - q, 2,
                   stats::median)
  }
  t
}

# ROI meshes (microns) straight from the neuprint API
roi_mesh <- function(r, conn) {
  tf <- tempfile(fileext = ".obj")
  res <- httr::GET(
    paste0(conn$server, "/api/roimeshes/mesh/", conn$dataset, "/",
           utils::URLencode(r, reserved = TRUE)),
    httr::add_headers(Authorization = paste("Bearer", conn$token)),
    httr::write_disk(tf))
  httr::stop_for_status(res)
  xyzmatrix(readobj::read.obj(tf, convert.rgl = TRUE)[[1]]) * 8 / 1000
}
choose_flyem_dataset("yakuba"); cy <- manc_neuprint()
choose_flyem_dataset("MANC"); cm <- manc_neuprint()
rois <- intersect(neuprintr::neuprint_ROIs(conn = cy),
                  neuprintr::neuprint_ROIs(conn = cm))
ym <- lapply(setNames(rois, rois), roi_mesh, conn = cy)
mm <- lapply(setNames(rois, rois), roi_mesh, conn = cm)

# matched descending neurons in both datasets
read_type <- function(type, ds) {
  choose_flyem_dataset(ds)
  manc_read_neurons(type, units = "microns", heal = FALSE)
}
dn_types <- c("MDN", "DNg13", "DNa02")
dy <- lapply(setNames(dn_types, dn_types), read_type, ds = "yakuba")
dm <- lapply(setNames(dn_types, dn_types), read_type, ds = "MANC")

# mean distance from each transformed yakuba neuron to its closest MANC neuron
dn_dist <- function(q, tg) sapply(q, function(n) min(sapply(tg, function(m)
  mean(nabor::knn(xyzmatrix(m), xyzmatrix(n), k = 1)$nn.dists))))

methods <- list(
  unshifted = function(x)
    xform_dyak2manc(x, units = "microns", method = "tps1000_unshifted"),
  tps1000 = function(x) xform_dyak2manc(x, units = "microns"),
  manual = function(x) xform_dyak2manc(x, units = "microns", method = "manual"),
  ngscene = function(x) xform_dyak2manc(x, units = "microns", method = "ngscene")
)
res <- t(sapply(methods, function(f) {
  d <- unlist(lapply(dn_types, function(ty) dn_dist(f(dy[[ty]]), dm[[ty]])))
  roi <- sapply(rois, function(r) icp_t(f(ym[[r]]), mm[[r]]))
  c(dn_mean_dist = mean(d), roi_shift = apply(roi, 1, stats::median))
}))
round(res, 1)
# expected: DN mean distance ~8.9 (unshifted), 5.6 (tps1000), 6.4 (manual),
# 7.7 (ngscene); median ROI shift ~(7.4, -2.1, 10.1) unshifted, (0.6, 0.2, 0.2)
# tps1000, (0.9, -0.3, -1.2) manual, (-2.0, 2.2, 1.6) ngscene

# left-right consistency of mirror_dyak, with and without the offset: median
# X shift still needed after mirroring each (L) ROI onto its (R) partner
unshifted_mirror <- function(x) {
  reg <- yakuba_extdata_reg("yakuba_yakubaSym_1000pts_tps.rds")
  xs <- mirror(xform(x, reg), mirrorAxisSize = sum(yakubasym$BoundingBox[, 1]),
               mirrorAxis = "X", transform = "flip")
  xform(xs, reglist(reg, swap = TRUE))
}
Ls <- grep("\\(L\\)$", rois, value = TRUE)
lr <- sapply(Ls, function(l) {
  r <- sub("\\(L\\)$", "(R)", l)
  c(unshifted = icp_t(unshifted_mirror(ym[[l]]), ym[[r]])[1],
    shifted = icp_t(mirror_dyak(ym[[l]], units = "microns"), ym[[r]])[1])
})
round(apply(lr, 1, stats::median), 2)
# expected: ~10.5 µm unshifted, ~0.2 µm shifted

# left-right assignment of intrinsic neuron somata: sign of dyak_lr_position()
# (positive = fly's right) vs the neuprint somaSide annotation, with and
# without the offset. malevnc::manc_lr_position() on MANC is the benchmark.
somata <- function(conn) {
  q <- paste("MATCH (n:Neuron) WHERE n.somaLocation IS NOT NULL",
             "AND n.class = 'intrinsic neuron'",
             "RETURN n.somaLocation.x, n.somaLocation.y, n.somaLocation.z, n.somaSide")
  d <- neuprintr::neuprint_fetch_custom(q, conn = conn, dataset = conn$dataset)$data
  data.frame(xyzmatrix(t(sapply(d, function(r) unlist(r[1:3])))) * 8 / 1000,
             side = sapply(d, function(r) format(r[[4]])))
}
unshifted_lr <- function(x) {
  xs <- xform(x, yakuba_extdata_reg("yakuba_yakubaSym_1000pts_tps.rds"))
  mirror(xs, mirrorAxisSize = sum(yakubasym$BoundingBox[, 1]),
         mirrorAxis = "X", transform = "flip")[, 1] - xs[, 1]
}
sy <- somata(cy)
sm <- somata(cm)
sm$side <- c(LHS = "L", RHS = "R", Midline = "M")[sm$side]
lr_summary <- function(lr, side) {
  s <- side %in% c("L", "R")
  c(n = sum(s), accuracy = mean(ifelse(lr[s] > 0, "R", "L") == side[s]),
    median_L = stats::median(lr[side == "L"]),
    median_R = stats::median(lr[side == "R"]),
    median_M = stats::median(lr[side == "M"]))
}
round(rbind(
  unshifted = lr_summary(unshifted_lr(xyzmatrix(sy)), sy$side),
  shifted = lr_summary(dyak_lr_position(xyzmatrix(sy), units = "microns"), sy$side),
  MANC = lr_summary(manc_lr_position(xyzmatrix(sm), units = "microns"), sm$side)
), 3)
# expected: accuracy 0.966 unshifted, 0.979 shifted, 0.972 MANC (n ~12k each);
# median L/R ~(-97, 75) unshifted, (-86.5, 85.9) shifted, (-88.8, 94.6) MANC
