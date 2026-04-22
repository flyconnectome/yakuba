# Read neuronal skeletons via neuprint

Read neuronal skeletons via neuprint

## Usage

``` r
read_dyak_neurons(
  ids,
  connectors = FALSE,
  units = c("nm", "raw", "microns"),
  heal.threshold = Inf,
  conn = NULL,
  ...,
  dataset = dyak_default_dataset()
)
```

## Arguments

- ids:

  bodyids in any form compatible with
  [`malevnc::manc_ids()`](https://natverse.org/malevnc/reference/manc_ids.html).

- connectors:

  Whether to fetch synaptic connections for the neuron (default `FALSE`
  in contrast to
  [`neuprintr::neuprint_read_neurons()`](https://natverse.org/neuprintr/reference/neuprint_read_neurons.html)).

- units:

  Units of the returned neurons (default `nm`).

- heal.threshold:

  The threshold for healing disconnected skeleton fragments. The default
  of `Inf` ensures that all fragments are joined together.

- conn:

  Optional, a `neuprint_connection` object. Defaults to
  [`dyak_neuprint()`](https://flyconnectome.github.io/yakuba/reference/dyak_neuprint.md)
  to ensure that query is against the yakuba dataset.

- ...:

  Additional arguments passed to
  [`neuprintr::neuprint_read_neurons()`](https://natverse.org/neuprintr/reference/neuprint_read_neurons.html).

- dataset:

  The name of the dataset as reported in Clio or neuprint.

## Value

A [`nat::neuronlist`](https://rdrr.io/pkg/nat/man/neuronlist.html)
object containing one or more neurons.

## See also

[`malevnc::manc_read_neurons()`](https://natverse.org/malevnc/reference/manc_read_neurons.html)

## Examples

``` r
# \donttest{
dns <- read_dyak_neurons("DNa02")
#> Warning: NAs introduced by coercion to integer64 range
dns
#> 'neuronlist' containing 2 'neuprintneuron' objects and 'data.frame' with 39 vars [158.7 kB]
# }
```
