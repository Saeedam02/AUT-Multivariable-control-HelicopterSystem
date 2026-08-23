# Contributing

1. Create a branch from `main`.
2. Run `setupProject`.
3. Add or update MATLAB unit tests for behavioral changes.
4. Run `runtests("tests")`.
5. Do not duplicate the helicopter coefficient table outside `buildHelicopterPlant.m`.
6. Do not invent channel names, units or model provenance. Update `docs/MODEL_PROVENANCE.md` when primary source information becomes available.
7. Generated plots belong in `results/` and should be reproducible from an example script.
8. For new robust-control claims, report the uncertainty structure, weight, margin definition and MATLAB routine used.
