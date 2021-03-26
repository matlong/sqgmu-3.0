
# SQGMU-3.0

## Context

This MATLAB codes simulates deterministic or randomized version of the *Surface Quasi-Geostrophic* (SQG) model. The random dynamics is based on the transport under location uncertainty. The ensuing model is referred to as SQG model under moderate uncertainty (SQG_MU).

*This branch is the second version*, the first one corresponds to the reference papers ([1], [2], [3], [4]). It is *still in progress*!

## Usage

This code currently needs:

* the MATLAB image processing toolbox;
* the Wavelab toolbox ([5]).
* optionally, the Parallel Computing toolbox.

Copy the folder 'Wavelab850' into the Toolbox folder of your Matlab root folder.

Several parameters can be changed easily in `functions/set_model.m`.

Launch the script `main.m` to execute the algorithm. Plots and MAT-files are saved each day of simulation in the chosen output folder.

## Notes

`[WIP]` and `[TODO]` tags denote functionalities being currently developed and/or not fully tested. Use with care.

Compilation script for deployed m-code are provided in the `compile` directory. They must be adapted to the local configuration.

## References

1. ["Geophysical flows under location uncertainty, Part I", V. Resseguier et al., 2017.][1]
2. ["Geophysical flows under location uncertainty, Part II", V. Resseguier et al., 2017.][2]
3. ["Geophysical flows under location uncertainty, Part III", V. Resseguier et al., 2017.][3]
4. ["New trends in ensemble forecast strategy: uncertainty quantification for coarse-grid computational fluid dynamics", V. Resseguier et al., 2021.][4]
5. [http://statweb.stanford.edu/~wavelab][5]

[1]: http://dx.doi.org/10.1080/03091929.2017.1310210
[2]: http://dx.doi.org/10.1080/03091929.2017.1312101
[3]: http://dx.doi.org/10.1080/03091929.2017.1312102
[4]: http://dx.doi.org/10.1007/s11831-020-09437-x
[5]: http://statweb.stanford.edu/~wavelab

## Resources / contact

* [Fluminance team @ Inria Rennes](http://www.irisa.fr/fluminance)
* long.li@inria.fr
# sqgmu-3.0
