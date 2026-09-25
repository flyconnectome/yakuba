# Offset between current yakuba coordinates and the frame of the surface
# (yakSurf, fitted by Sebastian Cachero to an earlier yakuba synapse cloud) used
# to compute the 1000 point TPS registrations to MANC and yakubasym.
#
# yakSurf is related to yakuba_neuropil_shell by a pure translation: fits with
# axis flips, scaling or rotation are worse, and fits to quarters of the VNC
# along the AP axis agree within ~1 µm. The result, rounded to 0.1 µm, is
# hard-coded as yakuba_surf_offset in R/xform.R.
library(nat)
devtools::load_all()

ys <- readRDS("~/dev/R/malevnc/data-raw/yakSurf_lowRes.rds")
yp <- xyzmatrix(ys)
nv <- xyzmatrix(yakuba_neuropil_shell)

# translation-only ICP with median displacement updates
tt <- c(0, 0, 0)
for (i in 1:30) {
  pp <- sweep(yp, 2, tt, "+")
  tt <- tt + apply(nv[nabor::knn(nv, pp, k = 1)$nn.idx[, 1], ] - pp, 2,
                   stats::median)
}
resid <- nabor::knn(nv, sweep(yp, 2, tt, "+"), k = 1)$nn.dists
round(tt, 2)             # ~ (6.49, 7.06, 7.97)
stats::median(resid)     # ~ 2 µm (decimated shell; ~1.1 µm at full resolution)
# current yakuba -> yakSurf frame
-round(tt, 1)
