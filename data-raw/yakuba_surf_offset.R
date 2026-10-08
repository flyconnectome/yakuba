# Offset between current yakuba coordinates and the frame of the surface
# (yakSurf, fitted by Sebastian Cachero to an earlier yakuba synapse cloud) used
# to compute the 1000 point TPS registrations to MANC and yakubasym.
# The result, rounded to 0.1 µm, is hard-coded as yakuba_surf_offset in
# R/xform.R. See also data-raw/yakuba_xform_validation.R and
# vignettes/articles/yakuba-transforms.Rmd
library(nat)
devtools::load_all()

ys <- readRDS("~/dev/R/malevnc/data-raw/yakSurf_lowRes.rds")
yp <- xyzmatrix(ys)
nv <- xyzmatrix(yakuba_neuropil_shell)

# translation-only ICP with median displacement updates
icp_t <- function(p, ref, n = 30, t = colMeans(ref) - colMeans(p)) {
  for (i in 1:n) {
    q <- sweep(p, 2, t, "+")
    t <- t + apply(ref[nabor::knn(ref, q, k = 1)$nn.idx[, 1], ] - q, 2,
                   stats::median)
  }
  q <- sweep(p, 2, t, "+")
  c(t, median_resid = stats::median(nabor::knn(ref, q, k = 1)$nn.dists))
}

# 1. is the relationship a pure translation? try every axis flip (about the
# yakSurf centroid); only the unflipped surface fits (~2 µm vs >= 6 µm)
cen <- colMeans(yp)
flips <- expand.grid(x = c(1, -1), y = c(1, -1), z = c(1, -1))
round(cbind(flips, t(apply(flips, 1, function(s)
  icp_t(sweep(sweep(yp, 2, cen) * rep(s, each = nrow(yp)), 2, cen, "+"), nv)))),
  2)

# 2. translation is uniform along the AP axis (no scaling or rotation)
zq <- cut(yp[, 3], stats::quantile(yp[, 3], 0:4 / 4), include.lowest = TRUE)
round(t(sapply(split(seq_len(nrow(yp)), zq), function(i) icp_t(yp[i, ], nv, t = c(0, 0, 0)))), 2)

# 3. the offset: ~ (6.49, 7.06, 7.97) µm with median residual ~2 µm for the
# decimated shell (~1.1 µm for the full resolution clio mesh)
off <- icp_t(yp, nv, t = c(0, 0, 0))
round(off, 2)
# current yakuba -> yakSurf frame
-round(off[1:3], 1)
