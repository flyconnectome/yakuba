# Changelog

## yakuba 0.2.0

**Behaviour change** to yakuba \<-\> MANC transforms:

- Points are now shifted by about (-6.5, -7.1, -8.0) µm before the 1000
  point TPS registrations are applied, because those registrations were
  computed in a frame offset from current yakuba coordinates. As a
  result, `xform_brain(x, sample = "yakuba", reference = "MANC")` gives
  different (more accurate) results than in 0.1.0. Mean distance between
  matched yakuba/MANC DNs drops from 8.9 to 5.6 µm. The old behaviour is
  available as `xform_dyak2manc(x, method = "tps1000_unshifted")`.

New features:

- New
  [`xform_dyak2manc()`](https://flyconnectome.github.io/yakuba/reference/xform_dyak2manc.md)
  maps yakuba neurons or points to MANC space (or back). It offers
  alternative registrations via `method`: `"tps1000"` (default, same as
  [`xform_brain()`](https://natverse.org/nat.templatebrains/reference/xform_brain.html)),
  `"manual"` (Hiroshi Shiozaki’s landmarks), `"ngscene"` (Clio
  neuroglancer landmarks via malecns) and `"tps1000_unshifted"`.
- Left-right mirroring based on Sebastian Cachero’s registration to a
  symmetrised yakuba template:
  - [`mirror_dyak()`](https://flyconnectome.github.io/yakuba/reference/mirror_dyak.md)
    and
    [`symmetric_dyak()`](https://flyconnectome.github.io/yakuba/reference/mirror_dyak.md),
    analogous to
    [`malevnc::mirror_manc()`](https://natverse.org/malevnc/reference/mirror_manc.html)
    and
    [`malevnc::symmetric_manc()`](https://natverse.org/malevnc/reference/mirror_manc.html).
  - [`dyak_lr_position()`](https://flyconnectome.github.io/yakuba/reference/dyak_lr_position.md),
    analogous to
    [`malevnc::manc_lr_position()`](https://natverse.org/malevnc/reference/manc_lr_position.html).
  - New `yakubasym` template brain; `yakubaum -> yakubasym` is
    registered for
    [`nat.templatebrains::xform_brain()`](https://natverse.org/nat.templatebrains/reference/xform_brain.html).
- New datasets `yakuba_neuropil_shell` and `yakuba_vnc_shell` (surface
  meshes).
- New article “Transforms between yakuba and MANC” documents the
  registrations and the coordinate offset.

**Full Changelog**:
<https://github.com/flyconnectome/yakuba/compare/v0.1.0>…v0.2.0

## yakuba 0.1.0

- First tagged release. Thin wrapper around malevnc for the *D. yakuba*
  male VNC neuprint and Clio datasets:
  [`dyak_neuprint()`](https://flyconnectome.github.io/yakuba/reference/dyak_neuprint.md),
  [`dyak_neuprint_meta()`](https://flyconnectome.github.io/yakuba/reference/dyak_neuprint_meta.md),
  [`dyak_connection_table()`](https://flyconnectome.github.io/yakuba/reference/dyak_connection_table.md),
  [`read_dyak_neurons()`](https://flyconnectome.github.io/yakuba/reference/read_dyak_neurons.md),
  [`dyak_ids()`](https://flyconnectome.github.io/yakuba/reference/dyak_ids.md),
  [`dyak_xyz2bodyid()`](https://flyconnectome.github.io/yakuba/reference/dyak_xyz2bodyid.md),
  [`dyak_islatest()`](https://flyconnectome.github.io/yakuba/reference/dyak_islatest.md),
  [`dyak_body_annotations()`](https://flyconnectome.github.io/yakuba/reference/dyak_body_annotations.md),
  [`yakuba_annotate_body()`](https://flyconnectome.github.io/yakuba/reference/yakuba_annotate_body.md),
  [`choose_dyak()`](https://flyconnectome.github.io/yakuba/reference/with_dyak.md),
  [`choose_dyak_dataset()`](https://flyconnectome.github.io/yakuba/reference/choose_dyak_dataset.md)
  and
  [`with_dyak()`](https://flyconnectome.github.io/yakuba/reference/with_dyak.md).
- Bridging registration from yakuba to MANC for
  [`nat.templatebrains::xform_brain()`](https://natverse.org/nat.templatebrains/reference/xform_brain.html).
- [`yakuba_annotate_body()`](https://flyconnectome.github.io/yakuba/reference/yakuba_annotate_body.md)
  follows
  [`malevnc::manc_annotate_body()`](https://natverse.org/malevnc/reference/manc_annotate_body.html)
  0.4.0 defaults: `test = FALSE` and new `dry_run = TRUE`, so a bare
  call previews the POST body rather than writing. Requires malevnc (\>=
  0.4.0).
