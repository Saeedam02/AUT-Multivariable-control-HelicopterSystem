# Release checklist

Before tagging v2.0.0:

- [ ] Verify the physical 4-input/10-output channel names and units if source records are available.
- [ ] Verify the `G(3,2)` 87338/8733 coefficient; otherwise keep `legacy` as default.
- [ ] Confirm GitHub Actions MATLAB CI is green.
- [ ] Run `examples/run_nominal_analysis.m`.
- [ ] Run `examples/run_controller_comparison.m` and inspect any synthesis warnings.
- [ ] Run `examples/run_robustness_analysis.m`.
- [ ] Record MATLAB and toolbox versions in the release notes.
- [ ] Do not publish numerical robust-performance claims unless the uncertainty weight is stated.
- [ ] Create a GitHub release and attach source only; generated `.fig` files are not required.
