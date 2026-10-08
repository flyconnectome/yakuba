# Transform yakuba neurons or points to MANC space (or back)

`xform_dyak2manc()` maps objects in yakuba space onto the MANC template
or, with `inverse = TRUE`, from MANC onto yakuba. Several alternative
registrations are available; only the default (`"tps1000"`) is used by
[`nat.templatebrains::xform_brain()`](https://natverse.org/nat.templatebrains/reference/xform_brain.html).

## Usage

``` r
xform_dyak2manc(
  x,
  method = c("tps1000", "manual", "ngscene", "tps1000_unshifted"),
  units = c("nm", "microns"),
  inverse = FALSE,
  ...
)
```

## Arguments

- x:

  An object compatible with
  [`nat::xform()`](https://rdrr.io/pkg/nat/man/xform.html) (neuron,
  neuronlist, dotprops, surface, coordinate matrix etc).

- method:

  Which registration to use (see details).

- units:

  Coordinate units of `x` and of the returned object (in MANC space
  unless `inverse = TRUE`).

- inverse:

  Whether to map from MANC to yakuba space.

- ...:

  Additional arguments passed to
  [`nat::xform()`](https://rdrr.io/pkg/nat/man/xform.html).

  See the [transforms
  article](https://flyconnectome.github.io/yakuba/articles/yakuba-transforms.html)
  for how the registrations and the offset were validated.

## Value

A transformed object of the same kind as `x`, in the same `units`.

## Details

The available methods are:

- `"tps1000"` (default): a thin-plate spline with 1000 landmarks
  computed by Sebastian Cachero from a surface fitted to an earlier
  version of the yakuba data. That surface is offset by a pure
  translation from current yakuba coordinates, so points are first
  shifted by (-6.5, -7.1, -8.0) µm. The shift was estimated by fitting
  that surface to
  [yakuba_neuropil_shell](https://flyconnectome.github.io/yakuba/reference/yakuba_neuropil_shell.md)
  (precision ~1 µm); it reduces the mismatch between matched yakuba and
  MANC descending neurons and neuropils by several µm.

- `"tps1000_unshifted"`: the same registration without the shift, as
  used by yakuba versions before the correction. Provided for comparison
  and reproducibility; not recommended for new work.

- `"manual"`: a thin-plate spline defined by 100 landmarks placed by
  hand by Hiroshi Shiozaki.

- `"ngscene"`: a thin-plate spline from yakuba to the male CNS
  (`malecnsum`) defined by 21 landmark pairs from a clio neuroglancer
  scene, followed by the `malecnsum` to `MANC` bridging registration.
  Requires the suggested `malecns` package.

On descending neurons with a known MANC match (MDN, DNg13, DNa02) the
mean distance to the matched MANC neuron was 5.6, 6.4, 7.7 and 8.9 µm
for `"tps1000"`, `"manual"`, `"ngscene"` and `"tps1000_unshifted"`,
respectively.

Inverse thin-plate splines are computed by swapping the landmark sets,
so round trips are approximate (~0.3 µm for `"tps1000"`, a few µm for
`"manual"`).

All registrations are defined in microns; nm inputs are scaled before
and after transformation. Requires the suggested `Morpho` package.

## See also

[`yakuba_register_xforms()`](https://flyconnectome.github.io/yakuba/reference/yakuba_register_xforms.md)

## Examples

``` r
if (FALSE) { # \dontrun{
mdn <- read_dyak_neurons("MDN")
mdn.manc <- xform_dyak2manc(mdn)
mdn.manc2 <- xform_dyak2manc(mdn, method = "manual")
plot3d(mdn.manc, col = "black")
plot3d(mdn.manc2, col = "red")
} # }
```
