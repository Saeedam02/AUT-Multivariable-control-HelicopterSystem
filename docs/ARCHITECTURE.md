# Repository architecture

The refactor separates source-derived modeling, nominal analysis, controller synthesis, robust verification, examples, tests and generated results.

```text
src/models       source-faithful plant + uncertainty construction
src/analysis     poles/zeros, output selection, RGA, singular values, conditioning
src/controllers  decentralized PI, LQI, H-infinity and mu synthesis
src/robustness   robstab/robgain/wcgain/mussv-based verification
examples         reproducible entry-point scripts
tests            MATLAB unit tests and regressions
legacy           untouched original scripts for provenance
docs             theory, model provenance and result-reporting guidance
results          generated plots/results (not source of truth)
```

The central design rule is: **the plant coefficients live in exactly one maintained source file**. This removes the duplicated-model problem that allowed the same suspicious coefficient to propagate through multiple legacy scripts.
