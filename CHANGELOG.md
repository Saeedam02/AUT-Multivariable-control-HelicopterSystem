# Changelog

## 2.0.0 - 2026-08-23

### Added
- source-faithful 10x4 plant builder with documented model variants;
- plant validation and model-provenance documentation;
- automatic demonstration output-subset selection;
- RGA, singular-value and MIMO conditioning analysis;
- decentralized PI, LQI, H-infinity and optional mu-synthesis controllers;
- structured dynamic uncertainty model;
- `robstab`, `robgain`, `wcgain` and `mussv` robustness workflows;
- worst-case model extraction;
- MATLAB unit tests and GitHub Actions CI;
- reproducible example scripts;
- comprehensive README and theory documentation.

### Fixed
- legacy maximum-singular-value logic that considered only the first three singular values;
- duplicated plant coefficient definitions across multiple maintained scripts;
- autosave/generated-file repository hygiene.

### Preserved intentionally
- the original `87338` coefficient in `G(3,2)` remains the default because the repository does not contain enough evidence to silently replace it.
