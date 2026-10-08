# yakuba (development version)

# yakuba 0.2.0

**Behaviour change** to yakuba <-> MANC transforms:

* Points are now shifted by about (-6.5, -7.1, -8.0) µm before the 1000 point
  TPS registrations are applied, because those registrations were computed in
  a frame offset from current yakuba coordinates. As a result,
  `xform_brain(x, sample = "yakuba", reference = "MANC")` gives different
  (more accurate) results than in 0.1.0. Mean distance between matched
  yakuba/MANC DNs drops from 8.9 to 5.6 µm. The old behaviour is available
  as `xform_dyak2manc(x, method = "tps1000_unshifted")`.

New features:

* New `xform_dyak2manc()` maps yakuba neurons or points to MANC space (or
  back). It offers alternative registrations via `method`: `"tps1000"`
  (default, same as `xform_brain()`), `"manual"` (Hiroshi Shiozaki's
  landmarks), `"ngscene"` (Clio neuroglancer landmarks via malecns) and
  `"tps1000_unshifted"`.
* Left-right mirroring based on Sebastian Cachero's registration to a
  symmetrised yakuba template:
  * `mirror_dyak()` and `symmetric_dyak()`, analogous to `malevnc::mirror_manc()`
    and `malevnc::symmetric_manc()`.
  * `dyak_lr_position()`, analogous to `malevnc::manc_lr_position()`.
  * New `yakubasym` template brain; `yakubaum -> yakubasym` is registered for
    `nat.templatebrains::xform_brain()`.
* New datasets `yakuba_neuropil_shell` and `yakuba_vnc_shell` (surface meshes).
* New article "Transforms between yakuba and MANC" documents the
  registrations and the coordinate offset.

**Full Changelog**: https://github.com/flyconnectome/yakuba/compare/v0.1.0...v0.2.0

# yakuba 0.1.0

* First tagged release. Thin wrapper around malevnc for the *D. yakuba* male
  VNC neuprint and Clio datasets: `dyak_neuprint()`, `dyak_neuprint_meta()`,
  `dyak_connection_table()`, `read_dyak_neurons()`, `dyak_ids()`,
  `dyak_xyz2bodyid()`, `dyak_islatest()`, `dyak_body_annotations()`,
  `yakuba_annotate_body()`, `choose_dyak()`, `choose_dyak_dataset()` and
  `with_dyak()`.
* Bridging registration from yakuba to MANC for
  `nat.templatebrains::xform_brain()`.
* `yakuba_annotate_body()` follows `malevnc::manc_annotate_body()` 0.4.0
  defaults: `test = FALSE` and new `dry_run = TRUE`, so a bare call previews
  the POST body rather than writing. Requires malevnc (>= 0.4.0).
