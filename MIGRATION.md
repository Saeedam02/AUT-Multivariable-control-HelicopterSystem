# Migration from the original repository

Use this v2 tree as a replacement structure rather than copying individual MATLAB files into the old flat root.

## Keep

- `LICENSE` (included here);
- the original helicopter image (moved to `assets/`);
- the original scripts for historical traceability (moved to `legacy/`).

## Remove from the root after migration

- `MFILE_Design.m`;
- `RobustPerformance.m`;
- `RobustStability.m`;
- all `.asv` autosave files;
- old generated `.fig`/`.jpg` result files that can be regenerated.

## Add

Copy the complete contents of this v2 package into the repository root. Then commit on a branch, run MATLAB CI, inspect the generated numerical results, and only then merge to `main`.

## Required scientific follow-up

Do not choose the `consistent-denominator` model as the new default until the original helicopter model source confirms that `8733` is the correct G(3,2) coefficient. Also replace generic channel labels with the actual four input and ten output variables/units when those records are available.
