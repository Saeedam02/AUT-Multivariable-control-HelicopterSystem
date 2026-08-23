# Robust-control formulation

## Mixed-sensitivity H-infinity design

For loop transfer $L=GK$,

$$
S=(I+L)^{-1}, \qquad T=L(I+L)^{-1}.
$$

The project uses the mixed-sensitivity objective

$$
\left\|
\begin{bmatrix}
W_S S\\
W_U K S\\
W_T T
\end{bmatrix}
\right\|_\infty.
$$

`designHinfController` solves this problem with MATLAB `mixsyn`.

## Uncertainty model

The default robust-control demonstration uses normalized output-multiplicative uncertainty

$$
G_\Delta=(I+W_\Delta\Delta_y)G,
\qquad \|\Delta_y\|_\infty\le1.
$$

This weighting is illustrative. It is not claimed to be identified from helicopter data.

## Robust stability

`analyzeRobustStability` uses MATLAB `robstab` on the uncertain closed loop. This is a
structured uncertainty calculation and is stronger than simply checking
$\bar\sigma(M(j\omega))$.

A robust-stability margin greater than one means the modeled normalized uncertainty can be
scaled upward before the first destabilizing perturbation is reached; a margin below one
means the specified uncertainty set is not certified stable.

## Robust performance

The uncertain weighted performance map is

$$
P_{\mathrm{perf}} =
\begin{bmatrix}
W_S S\\
W_U K S\\
W_T T
\end{bmatrix}.
$$

`analyzeRobustPerformance` uses `robgain` and `wcgain` to quantify worst-case weighted gain.

## Structured singular value

For an LFT $M$ interconnected with structured normalized uncertainty $\Delta$, the structured
singular value is denoted $\mu_\Delta(M)$. `computeMuBounds` extracts the M-Delta form with
`lftdata` and computes `mussv` bounds across frequency.

The critical reference is

$$
\mu=1.
$$

Values below one are consistent with the corresponding normalized robustness condition;
values above one indicate violation of that condition.
