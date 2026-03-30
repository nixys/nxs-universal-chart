# Tests

This chart uses four complementary automated test layers:

- `tests/units/` for fast `helm-unittest` suites
- `tests/units/backward_compatibility_test.sh` for rendering against previous stable tags
- `tests/smokes/` for render-path and schema validation
- `tests/e2e/` for kind-based installation checks against a real API server

## Unit Tests

Unit tests live under `tests/units/`.

They focus on chart-owned behavior rather than reasserting every generated field:

- helper-driven label and annotation merges
- selector composition
- `generic` propagation into templated fields
- representative manifests from `values.yaml.example`

## Unit Test Layout

```text
tests/units/
├── backward_compatibility_test.sh
├── example_*_test.yaml
├── rendering_contract_test.yaml
└── values/
    └── rendering_contract.values.yaml
```

Run all Helm unit suites:

```bash
make deps
helm unittest --with-subchart=false -f 'tests/units/*_test.yaml' .
```

Run the compatibility script:

```bash
sh tests/units/backward_compatibility_test.sh
```

Notes:

- values file paths inside the unit suites are resolved relative to `tests/units/`
- `--with-subchart=false` keeps the downloaded `nuc-common` library dependency out of the unit-suite traversal
- compatibility checks require local git tags to be present

## Smoke Tests

Smoke tests live under `tests/smokes/`.

The structure is intentionally split into small reusable layers:

- `run/` contains the entry point
- `scenarios/` orchestrates complete smoke flows
- `steps/` contains reusable operations
- `fixtures/` contains dedicated smoke-test values files

## Smoke Directory Layout

```text
tests/smokes/
├── helpers/
│   └── argparser.py
├── fixtures/
│   ├── invalid-list-contract.values.yaml
│   └── rendering-contract.values.yaml
├── run/
│   └── smoke.py
├── scenarios/
│   └── smoke.py
├── steps/
│   ├── chart.py
│   ├── helm.py
│   ├── kubeconform.py
│   ├── render.py
│   └── system.py
└── requirements.txt
```

Covered scenarios:

1. `default-empty`
   Verifies that the chart renders no manifests with default values.

2. `schema-invalid-list-contract`
   Verifies that `values.schema.json` rejects the old list-based top-level resource contract.

3. `rendering-contract`
   Verifies:
   - `generic` propagation into `tpl`
   - shared labels and annotations
   - selector label merging
   - generated ConfigMap and Deployment rendering

4. `example-render`
   Renders `values.yaml.example` and verifies that every supported template family produces the expected manifest kinds.

5. `example-kubeconform`
   Validates the example render with `kubeconform`.
   `SealedSecret` is skipped by default because it depends on an external CRD schema.

Install Python dependency:

```bash
pip3 install -r tests/smokes/requirements.txt
```

Run all smoke tests:

```bash
make deps
python3 tests/smokes/run/smoke.py
```

Equivalent `Makefile` targets:

```bash
make test-smoke
make test-smoke-fast
```

## E2E Tests

End-to-end tests live under `tests/e2e/`.

This layer uses a small shell runner around `kind` and Helm to validate that the chart can be installed into a real cluster without any extra CRDs.

## E2E Layout

```text
tests/e2e/
├── kind.yaml
├── test-e2e.sh
└── values/
    └── install.values.yaml
```

`tests/e2e/test-e2e.sh` performs the following steps:

1. Starts a disposable kind cluster from `tests/e2e/kind.yaml`.
2. Creates the fixed namespace `nxs-universal-chart-e2e`.
3. Runs `helm upgrade --install` against the chart root with `tests/e2e/values/install.values.yaml`.
4. Verifies the installed Deployment, StatefulSet, Service, Ingress, HPA, PDB, NetworkPolicy, ConfigMap, Secret, hook Job, standard Job, and CronJob.
5. Cleans up the kind cluster on exit.

Run the default end-to-end flow:

```bash
make deps
bash tests/e2e/test-e2e.sh
```

Pass additional arguments through to `helm upgrade --install`:

```bash
bash tests/e2e/test-e2e.sh --debug
```

Equivalent `Makefile` targets:

```bash
make test-e2e
make test-e2e-debug
make test-e2e-help
```

To pass extra arguments through `make`, use `E2E_ARGS`:

```bash
make test-e2e E2E_ARGS="--debug"
```

## E2E Prerequisites

- `docker`
- `kind`
- `kubectl`
- `helm`

Optional environment overrides:

- `CLUSTER_NAME`
- `K8S_VERSION`

## Notes

- e2e intentionally avoids CRD-backed resources so the local cluster flow stays fast and deterministic.
- The e2e values file uses `nameOverride: e2e`, so rendered resource names are stable and easy to verify with `kubectl get`.
