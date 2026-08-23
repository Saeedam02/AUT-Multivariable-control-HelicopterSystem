# Validation status

The refactor was generated and statically inspected in an environment without MATLAB installed. Therefore no numerical MATLAB execution is claimed in this package.

The included GitHub Actions workflow is designed to perform the actual MATLAB unit tests on push/pull request using official MathWorks actions with Control System Toolbox and Robust Control Toolbox.

Before merging into `main`, confirm that the CI run is green and inspect any synthesis warnings from `pidtune`, `lqr`, `mixsyn`, `robstab`, `robgain`, `wcgain`, `mussv`, or `musyn`.
