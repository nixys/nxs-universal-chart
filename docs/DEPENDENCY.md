# Development Dependencies

This document describes the local tools needed to develop, document, and test the `nxs-universal-chart` Helm chart.

The repository is designed around a small set of entry points:

- `make lint`
- `make docs`
- `make test-unit`
- `make test-compat`
- `make test-smoke`
- `make test-e2e`

## Chart Dependency

The root chart declares the published helper dependency:

```yaml
dependencies:
  - name: nuc-common
    version: 1.0.0
    repository: oci://registry.nixys.ru/nuc
```

Resolve dependencies before direct Helm commands:

```bash
helm registry login registry.nixys.ru
make deps
```

`Chart.lock` should stay in sync with `Chart.yaml`, and shared helper changes must be synchronized with the upstream source in `/home/ruk/nixys/nuc-common`.

## Dependency Matrix

| Tool | Why it is needed | Required for |
|------|------------------|--------------|
| `git` | repository operations and reading tagged `values.yaml` in compatibility checks | development, `make test-compat` |
| `helm` | linting, templating, install/upgrade flows, `helm-unittest` plugin host | all workflows |
| `helm-unittest` | chart unit test plugin | `make test-unit` |
| `python3` | smoke-test runner | `make test-smoke`, `make test-smoke-fast` |
| `PyYAML` | smoke-test Python dependency | `make test-smoke`, `make test-smoke-fast` |
| `kubeconform` | schema validation in smoke tests | `make test-smoke` |
| `pre-commit` | local git hook manager for auto-regenerating `README.md` on commit | documentation workflow |
| `helm-docs` | README values-table generator | `make docs`, pre-commit hook |
| `docker` | `kind` runtime and fallback runtime for `helm-docs` wrapper | `make test-e2e`, optional `make docs` |
| `kubectl` | cluster verification in e2e tests | `make test-e2e` |
| `kind` | disposable local Kubernetes cluster for e2e | `make test-e2e` |

## Repository Defaults

If you want local behavior close to the repository defaults, use these versions:

- `kubeconform`: `v0.6.7`
- `kindest/node`: `v1.35.0`
- `KUBE_VERSION`: `1.35.2`

The chart itself is not pinned to one exact Helm version, but the repository currently targets Helm v4-compatible templating.

## Verification Commands

Use these commands to verify that the local toolchain is complete:

```bash
git --version
helm version
kubectl version --client
kind version
docker version
python3 --version
pre-commit --version
kubeconform -v
helm plugin list
make lint
make test-smoke-fast
```

Run the heavier checks only when their dependencies are available:

```bash
make test-unit
make test-compat
make test-smoke
make test-e2e
make docs
```
