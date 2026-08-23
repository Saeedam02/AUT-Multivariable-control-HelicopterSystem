# Roadmap

The major software/robust-control refactor is implemented in v2. The remaining improvements depend on information or experimental data that are not present in the source repository.

## Highest priority

- Recover the physical names and units of all 4 inputs and 10 outputs.
- Verify the `G(3,2)` denominator coefficient against the original AUT helicopter model source.
- Document the equilibrium/linearization operating point.
- Replace the illustrative uncertainty weight with one fitted to model-validation residuals.

## Next technical developments

- actuator magnitude/rate limits and anti-windup;
- sensor noise and delay models;
- state estimator for LQI implementation;
- gain scheduling across operating points;
- nonlinear/Simulink validation against a higher-fidelity helicopter model;
- Monte Carlo uncertainty studies alongside formal robust margins;
- automated result table export for papers/reports;
- hardware-in-the-loop if the experimental platform becomes available.
