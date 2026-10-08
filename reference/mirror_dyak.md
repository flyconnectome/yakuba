# Mirror yakuba neurons or points to the opposite side of the VNC

`mirror_dyak()` mirrors neurons, surfaces and other point data in yakuba
space to the opposite side of the VNC.

`symmetric_dyak()` transforms objects onto a symmetrised version of the
yakuba template, optionally mirroring across the midline.

## Usage

``` r
mirror_dyak(x, units = c("nm", "microns"), subset = NULL, ...)

symmetric_dyak(
  x,
  units = c("nm", "microns"),
  mirror = FALSE,
  subset = NULL,
  ...
)
```

## Arguments

- x:

  An object compatible with
  [`nat::xform()`](https://rdrr.io/pkg/nat/man/xform.html) (neuron,
  neuronlist, dotprops, surface, coordinate matrix etc).

- units:

  Coordinate units of `x` and the returned object. Defaults to nm,
  matching
  [`read_dyak_neurons()`](https://flyconnectome.github.io/yakuba/reference/read_dyak_neurons.md).

- subset:

  Optional subset passed to
  [`nat::xform()`](https://rdrr.io/pkg/nat/man/xform.html), e.g. when
  transforming selected elements of a neuronlist.

- ...:

  Additional arguments passed to
  [`nat::xform()`](https://rdrr.io/pkg/nat/man/xform.html).

- mirror:

  Whether to mirror across the midline of the symmetric space.

## Value

A transformed object of the same kind as `x`, in the same `units`.

## Details

Mirroring maps `x` into the symmetric
[yakubasym](https://flyconnectome.github.io/yakuba/reference/yakubasym.md)
space with a bundled thin-plate spline registration
(`yakuba_yakubaSym_1000pts_tps.rds`, computed by Sebastian Cachero),
flips across the X axis and then maps back with the inverse
registration. As for the default method of
[`xform_dyak2manc()`](https://flyconnectome.github.io/yakuba/reference/xform_dyak2manc.md),
points are first shifted by (-6.5, -7.1, -8.0) µm to match the frame in
which the registration was computed. The registration is defined in
microns; nm inputs are scaled before and after transformation. Requires
the suggested `Morpho` package.

Denser versions of the registration (10000 points) were also computed
but gave \< 1 µm change in mirrored positions at ~500x the compute cost.

`symmetric_dyak()` returns objects in
[yakubasym](https://flyconnectome.github.io/yakuba/reference/yakubasym.md)
space, using `units` for both input and output.

## See also

[yakubasym](https://flyconnectome.github.io/yakuba/reference/yakubasym.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dna02 <- read_dyak_neurons("DNa02")
dna02.m <- mirror_dyak(dna02)
plot3d(dna02, col = "black")
plot3d(dna02.m, col = "red")
} # }
if (FALSE) { # \dontrun{
# DNa02 neurons and their mirror images in symmetric space
dna02.sym <- symmetric_dyak(dna02)
dna02.sym.m <- symmetric_dyak(dna02, mirror = TRUE)
} # }
```
