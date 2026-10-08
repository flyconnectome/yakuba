# Neuropil and VNC shell meshes for the yakuba VNC, as shown in the
# `neuropil-shell` and `vnc-shell` layers of the clio neuroglancer scene for
# the yakuba dataset (see `malevnc:::clio_datasets()[["yakuba"]]`).
#
# The source meshes are single-resolution legacy neuroglancer meshes (uint32
# vertex count, float32 xyz in nm, uint32 triangle indices). They are converted
# to microns (yakubaum space) and decimated to ~16k vertices.
library(nat)

base <- "https://storage.googleapis.com/z0422_17_vnc_1-yakuba-derived/rois"

read_ngmesh <- function(url) {
  f <- tempfile(fileext = ".ngmesh")
  on.exit(unlink(f))
  utils::download.file(url, f, mode = "wb", quiet = TRUE)
  con <- file(f, "rb")
  on.exit(close(con), add = TRUE)
  nv <- readBin(con, "integer", 1, size = 4)
  v <- matrix(readBin(con, "numeric", nv * 3, size = 4), ncol = 3, byrow = TRUE)
  i <- readBin(con, "integer", (file.size(f) - 4 - nv * 12) / 4, size = 4)
  rgl::tmesh3d(t(v / 1e3), matrix(i + 1L, nrow = 3), homogeneous = FALSE)
}

simplify_shell <- function(m, nverts = 16000) {
  s <- Rvcg::vcgQEdecim(m, tarface = 2 * nverts, silent = TRUE)
  # decimated surface should stay close to the original
  d <- nabor::knn(xyzmatrix(m), xyzmatrix(s), k = 1)$nn.dists
  stopifnot(stats::median(d) < 0.5)
  s$normals <- NULL
  s
}

yakuba_neuropil_shell <- simplify_shell(
  read_ngmesh(file.path(base, "neuropil-shell-v0/mesh/neuropil.ngmesh")))
yakuba_vnc_shell <- simplify_shell(
  read_ngmesh(file.path(base, "vnc-shell-v0/mesh/VNC.ngmesh")))

usethis::use_data(yakuba_neuropil_shell, yakuba_vnc_shell, overwrite = TRUE,
                  compress = "xz")
