# Mathematical model

The repository represents the nominal helicopter as a continuous-time MIMO transfer matrix

$$
G(s) \in \mathbb{R}^{10\times 4}.
$$

Each element $G_{ij}(s)$ maps manipulated input $u_j$ to measured output $y_i$.
The complete 40-channel coefficient set is defined once in
`src/models/buildHelicopterPlant.m`.

Because the original repository does not document physical channel names or units, the
refactor intentionally keeps the labels generic. See `MODEL_PROVENANCE.md`.

## Controlled square subplant

Most standard output-feedback synthesis routines in this repository operate on a square
selected plant

$$
G_c(s) = G(s)[\mathcal I_y,:] \in \mathbb{R}^{4\times4},
$$

where $\mathcal I_y$ is a set of four controlled outputs. Until the physical objectives are
recovered, `selectControlledOutputs` chooses the full-rank DC submatrix with the lowest
condition number. This is only a reproducible numerical demonstration rule.

## Relative Gain Array

For a nonsingular steady-state gain $G_c(0)$, the RGA is

$$
\Lambda = G_c(0) \circ G_c(0)^{-T},
$$

where $\circ$ denotes elementwise multiplication. Elements near +1 are generally easier
pairings for decentralized control, while large or negative values indicate interaction risk.

## Singular values and conditioning

The directional gains are characterized by

$$
\bar\sigma\!\left(G_c(j\omega)\right),\qquad
\underline\sigma\!\left(G_c(j\omega)\right),
$$

and the frequency-dependent condition number

$$
\kappa(\omega)=\frac{\bar\sigma(G_c(j\omega))}
{\underline\sigma(G_c(j\omega))}.
$$

The refactored implementation computes the maximum over **all** singular values, correcting
the legacy scripts that only inspected the first three singular-value rows.
