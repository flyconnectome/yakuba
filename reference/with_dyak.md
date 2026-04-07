# Evaluate an expression after temporarily setting malevnc options

`yakuba` is a thin wrapper around `malevnc`. This function temporarily
changes the server/dataset options for `malevnc` while running your
expression.

`choose_dyak()` swaps out the default `malevnc` dataset for the yakuba
dataset. This means that all functions from the `malevnc` package should
target yakuba instead. It is recommended that you use `with_dyak()` to
do this temporarily unless you have no intention of using other FlyEM
datasets. *To switch the default `yakuba` dataset please see
[`choose_dyak_dataset()`](https://flyconnectome.github.io/yakuba/reference/choose_dyak_dataset.md).*

## Usage

``` r
with_dyak(expr, dataset = dyak_default_dataset())

choose_dyak(dataset = dyak_default_dataset(), set = TRUE)
```

## Arguments

- expr:

  An expression involving `malevnc`/`yakuba` functions to evaluate with
  the specified autosegmentation.

- dataset:

  The name of the dataset as reported in Clio or neuprint.

- set:

  Whether to set the relevant package options or just to return a list
  of the required options.

## Value

`with_dyak()` returns the result of `expr`.
[`choose_dyak_dataset()`](https://flyconnectome.github.io/yakuba/reference/choose_dyak_dataset.md)
and `choose_dyak()` return named lists of previous option values,
matching [`options()`](https://rdrr.io/r/base/options.html).

## Details

Note that it can also temporarily switch out the active dataset for the
`yakuba` package if you specify the `dataset` argument and this is
different from the current active dataset. This allows you to easily run
the same expression for different yakuba dataset variants.

## See also

[`malevnc::choose_flyem_dataset()`](https://natverse.org/malevnc/reference/choose_malevnc_dataset.html),
[`malevnc::choose_malevnc_dataset()`](https://natverse.org/malevnc/reference/choose_malevnc_dataset.html)

## Examples

``` r
# \donttest{
with_dyak(dyak_ids("DNa02"))
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!

old <- choose_dyak("yakuba", set = FALSE)
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
str(old)
#> Error: object 'old' not found
# }
```
