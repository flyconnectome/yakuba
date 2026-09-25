#' Neuropil and VNC surface meshes for the yakuba VNC
#'
#' @description Surface meshes of the yakuba VNC in microns (`yakubaum` space).
#'   `yakuba_neuropil_shell` encloses the synaptic neuropil;
#'   `yakuba_vnc_shell` encloses the whole VNC including the cortex.
#'
#' @details These are the `neuropil-shell` and `vnc-shell` layers of the clio
#'   neuroglancer scene for the yakuba dataset, converted from nm to microns
#'   and decimated from ~107k to ~16k vertices (median deviation < 0.5 µm). See
#'   `data-raw/yakuba_shells.R` for details. Multiply by 1000 for use with nm
#'   data, e.g. from [read_dyak_neurons()].
#'
#' @format `mesh3d` objects.
#' @examples
#' \dontrun{
#' library(nat)
#' wire3d(yakuba_vnc_shell, col = "grey")
#' shade3d(yakuba_neuropil_shell, alpha = 0.3)
#' }
#' @docType data
"yakuba_neuropil_shell"

#' @rdname yakuba_neuropil_shell
#' @docType data
"yakuba_vnc_shell"
