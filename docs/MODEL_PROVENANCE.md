# Model provenance and unresolved metadata

The 10-output, 4-input transfer-function matrix in `src/models/buildHelicopterPlant.m` is transcribed from the repository's original `MFILE_Design.m`. The refactor deliberately preserves the original coefficient set by default.

## Unresolved G(3,2) coefficient

The denominator of `G(3,2)` contains `87338*s^3` in all three original analysis scripts, while the otherwise matching eighth-order denominator used throughout neighboring channels contains `8733*s^3`. The repository contains no source document that proves whether `87338` is intentional or a transcription error.

For this reason:

- `Variant="legacy"` is the default and uses **87338**.
- `Variant="consistent-denominator"` uses **8733** only as a clearly labeled candidate for sensitivity analysis.
- No report should call the alternative value "correct" until the original linearization/model-identification source is checked.

## Channel names and units

The source repository does not document the physical meaning or engineering units of `u1..u4` and `y1..y10`. The refactor therefore uses generic channel labels instead of inventing rotor, attitude, velocity, or position assignments.

Before publication-quality use, recover and document:

1. the four actuator/input definitions and units;
2. the ten measured/output variables and units;
3. the equilibrium/operating point;
4. whether the model came from analytical linearization, system identification, or both;
5. the source of every transfer-function coefficient.
