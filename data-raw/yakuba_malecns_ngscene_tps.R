# Thin-plate spline from yakuba to male CNS (both in microns) defined by the
# pointA/pointB landmark pairs in a clio neuroglancer scene. pointA is in yakuba
# space, pointB in male CNS space; both are in 8 nm voxels.
library(nat)

regurl <- "https://clio-ng.janelia.org/#!gs://flyem-user-links/short/2025-04-05.124221.029477.json"
ann <- fafbseg::ngl_annotations(fafbseg::ngl_decode_scene(regurl))
reg <- tpsreg(sample = xyzmatrix(ann$pointA) * 8 / 1000,
              reference = xyzmatrix(ann$pointB) * 8 / 1000)
saveRDS(reg, "inst/extdata/yakuba_malecns_ngscene_tps.rds")
