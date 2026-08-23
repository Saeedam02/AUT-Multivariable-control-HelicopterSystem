# Results and reproduction

This repository intentionally does **not** check in fabricated numerical robustness margins. Run the MATLAB scripts to generate results with your installed MATLAB/toolbox release.

Recommended order:

```matlab
setupProject
run("examples/run_nominal_analysis.m")
run("examples/run_controller_comparison.m")
run("examples/run_robustness_analysis.m")
```

For the optional D-K iteration:

```matlab
run("examples/run_mu_synthesis.m")
```

Generated figures belong under `results/`. The `.gitignore` keeps generated binaries out of version control so the repository remains source-driven and reproducible.

When reporting results, include at minimum:

- selected controlled output indices and their recovered physical names;
- plant variant (`legacy` or `consistent-denominator`);
- nominal closed-loop stability;
- decentralized PI, LQI and H-infinity time-domain comparisons;
- H-infinity synthesis gamma;
- robust-stability margin and critical frequency/uncertainty;
- robust-performance margin;
- worst-case gain;
- uncertainty weight and its experimental justification;
- MATLAB release and toolbox versions.
