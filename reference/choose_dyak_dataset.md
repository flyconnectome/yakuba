# Switch the default dataset for `dyak_*` functions

`choose_dyak_dataset()` sets the default dataset used by all `dyak_*`
functions. It is the recommended way to access yakuba dataset variants.
Unlike
[`choose_dyak()`](https://flyconnectome.github.io/yakuba/reference/with_dyak.md)
it does *not* permanently change the default dataset used when callers
use functions from the `malevnc` package directly (such as
[`malevnc::manc_xyz2bodyid()`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.html)).
Known aliases for the main yakuba dataset do not require a live Clio
lookup.

## Usage

``` r
choose_dyak_dataset(dataset = "yakuba")
```

## Arguments

- dataset:

  The name of the dataset as reported in Clio (usually `yakuba`), or
  neuprint (`yakuba-vnc`). These are aliases for the in progress
  production yakuba dataset. Currently there are no released datasets,
  but we expect those to look like e.g. `yakuba-vnc:v0.1`.

## Value

A named list of previous option values, matching
[`options()`](https://rdrr.io/r/base/options.html).

## Examples

``` r
# \donttest{
choose_dyak_dataset("yakuba")
dyak_ids("DNa02")
#> Warning: NAs introduced by coercion to integer64 range
#> [1] "10490" "10280"
# }
```
