# Register yakuba and MANC TPS transforms

`yakuba_register_xforms()` registers a thin-plate spline transform from
`yakubaum` to `MANC` using the bundled `yakuba_MANC_1000pts_tps.rds`
file, and adds a simple scaling alias from `yakuba` (nm) to `yakubaum`
(microns). Call once per session if the startup hook has not already
done so.

## Usage

``` r
yakuba_register_xforms()
```

## Value

Invisibly returns `NULL`.

## Examples

``` r
# \donttest{
library(malevnc)
library(nat)
library(nat.templatebrains)
yakuba_register_xforms()

MANC.tissue.surf.yak <- xform_brain(MANC.tissue.surf, sample = "MANC",
  reference = "yakuba")
#> Error in loadNamespace(x): there is no package called ‘Morpho’
wire3d(MANC.tissue.surf.yak)
#> Error: object 'MANC.tissue.surf.yak' not found
# }
```
