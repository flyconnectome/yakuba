# Check if a bodyid still exists in the specified yakuba DVID node

Check if a bodyid still exists in the specified yakuba DVID node

## Usage

``` r
dyak_islatest(
  ids,
  node = "neutu",
  method = c("auto", "size", "sparsevol"),
  dataset = dyak_default_dataset()
)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.html)

- node:

  A DVID node (defaults to the current neutu node, see
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.html))

- method:

  Which DVID endpoint to use. Expert use only.

- dataset:

  The name of the dataset as reported in Clio or neuprint.

## Value

A logical vector ordered by input ids.

## Details

For details (and there are some) please see
[`malevnc::manc_islatest()`](https://natverse.org/malevnc/reference/manc_islatest.html).

## See also

[`malevnc::manc_islatest()`](https://natverse.org/malevnc/reference/manc_islatest.html)

## Examples

``` r
# \donttest{
dyak_islatest(c(10280,10490))
#> [1] TRUE TRUE
# }
```
