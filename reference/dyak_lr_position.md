# Calculate the left-right position wrt to the symmetrised yakuba midline

Returns the signed left-right position of points with respect to the
midline of the symmetric yakuba template, analogous to
[`malevnc::manc_lr_position()`](https://natverse.org/malevnc/reference/manc_lr_position.html).

## Usage

``` r
dyak_lr_position(x, units = c("nm", "microns"), ...)
```

## Arguments

- x:

  An object containing XYZ vertex locations, compatible with
  [`nat::xyzmatrix()`](https://rdrr.io/pkg/nat/man/xyzmatrix.html).

- units:

  Units of `x` and of the returned displacement.

- ...:

  Additional arguments passed to
  [`nat::xform()`](https://rdrr.io/pkg/nat/man/xform.html).

## Value

A numeric vector of point displacements (in `units`) where 0 is at the
midline and positive values are to the fly's right.

## Details

Points are mapped into
[yakubasym](https://flyconnectome.github.io/yakuba/reference/yakubasym.md)
space and the X coordinate of each point is compared with that of its
mirror image. As in
[`manc_lr_position()`](https://natverse.org/malevnc/reference/manc_lr_position.html),
the returned value is this mirror displacement, i.e. *twice* the
distance from the midline. Note that the X axis of the yakuba dataset
points to the fly's left (opposite to MANC); the sign is adjusted so
that positive values are on the fly's right in both packages.

## See also

[`mirror_dyak()`](https://flyconnectome.github.io/yakuba/reference/mirror_dyak.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dna02 <- read_dyak_neurons("DNa02")
# mean position of each neuron: positive values are on the fly's right
sapply(dna02, function(n) mean(dyak_lr_position(n)))
# colour points: red for left, green for right (nautical convention)
xyz <- nat::xyzmatrix(dna02[[1]])
points3d(xyz, col = ifelse(dyak_lr_position(xyz) < 0, "red", "green"))
} # }
```
