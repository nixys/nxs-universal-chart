# Agent Guide

This repository is the reference baseline for reusable Helm application charts that keep:

- one chart at the repository root
- one shared helper library dependency exposed as `nuc-common`
- one values contract backed by `values.schema.json`
- one representative example file
- one layered test pyramid under `tests/units`, `tests/smokes`, and `tests/e2e`

## Repository Standard

Treat this repository as an application chart backed by the shared `nuc-common` helper library.

When making changes:

1. update the templates and, if helper behavior changes, sync the upstream helper source and dependency metadata
2. update `values.yaml`, `values.yaml.example`, and `values.schema.json`
3. update tests and fixtures
4. update docs in the same change
5. run a compact verification pass

## Chart Design Expectations

- Keep templates deterministic; sort map keys where output order matters.
- Prefer shared rendering behavior in the library helper layer over duplicate inline logic.
- Keep defaults minimal. The base `values.yaml` should render no manifests.
- Keep `values.yaml.example` representative enough to exercise every supported template family.
- Preserve backward compatibility where practical. If an old value name is still accepted, document the preferred replacement.

## Documentation Rules

- Keep one root `README.md` as the primary entry point.
- Keep `README.md` aligned with `docs/README.md.gotmpl`.
- Keep testing details in `docs/TESTS.MD`.
- Keep local dependency setup in `docs/DEPENDENCY.md`.
- Keep dependency resolution reproducible with `Chart.lock`.
- Update docs in the same change as code whenever the values contract or workflow changes.

## Test Rules

- `tests/units/` should validate chart-owned behavior, not every field of every manifest.
- `tests/smokes/` should prove that the chart lints, renders, and respects schema constraints.
- `tests/e2e/` should stay local-friendly and avoid unnecessary external dependencies.
- Keep e2e fixtures CRD-free unless the repository explicitly manages CRD installation.

## Final Verification

Prefer to run a compact validation set before finishing work:

```bash
git diff --check
make deps
helm lint . -f values.yaml.example
make deps
helm template smoke-test . -f values.yaml.example >/tmp/nxs-universal-chart.yaml
make deps
helm unittest --with-subchart=false -f 'tests/units/*_test.yaml' .
python3 tests/smokes/run/smoke.py --scenario default-empty --scenario rendering-contract --scenario example-render
bash -n tests/e2e/test-e2e.sh
sh -n tests/units/backward_compatibility_test.sh
```
