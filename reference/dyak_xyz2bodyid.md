# Map XYZ locations to bodyids for the yakuba dataset

Map XYZ locations to bodyids for the yakuba dataset

## Usage

``` r
dyak_xyz2bodyid(
  xyz,
  units = c("raw", "nm", "microns", "um"),
  node = "neutu",
  cache = FALSE,
  dataset = dyak_default_dataset()
)
```

## Arguments

- xyz:

  xyz location (by default in raw yakuba pixels)

- units:

  The optional units of the incoming 3D positions. Defaults to `raw`.

- node:

  A DVID node as returned by
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.html).
  The default is to return the current active (unlocked) node being used
  through neutu.

- cache:

  Whether to cache the result of this call for 5 minutes.

- dataset:

  The name of the dataset as reported in Clio or neuprint.

## Value

A character vector of body ids (`0` is missing somas / missing
locations).

## See also

[`malevnc::manc_xyz2bodyid()`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.html)

## Examples

``` r
# \donttest{
meta <- dyak_neuprint_meta("DNa02")
#> Warning: NAs introduced by coercion to integer64 range
dyak_xyz2bodyid(meta$somaLocation[1:2])
#> [1] 0 0
# }
```
