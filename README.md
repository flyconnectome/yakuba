# yakuba

`yakuba` is a thin wrapper around [malevnc](https://github.com/natverse/malevnc)
for working with the *Drosophila yakuba* male VNC connectome dataset in the same 
style as [malecns](https://github.com/natverse/malecns).

This dataset is currently in an in progress mode targeting an Autumn 2026 release.
The principal collaborators are 

* Hiroshi Shiozaki and David Stern, Janelia
* FlyEM team / Wyatt Korff and colleagues, Janelia
* Marta Costa and colleagues, *Drosophila* Connectomics Group, University of Cambridge
* Greg Jefferis, MRC LMB & University of Cambridge
* Kathi Eichler, University of Leipzig
* Michał Januszewski, Google

The initial package focuses on:

- dataset selection helpers
- neuprint metadata and connectivity queries
- body id lookup
- body annotation 
- neuron skeletons
