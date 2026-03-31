# Contributing Guidelines

Contributions are welcome via pull requests. This document outlines the process to help keep chart changes reviewable and reproducible.

## How to Contribute

1. Fork or branch from this repository.
2. Keep each change scoped to one logical chart concern.
3. Update tests and documentation in the same change as code.
4. Run the local verification targets that match the touched surface.

## Technical Requirements

- Follow Helm chart best practices.
- Keep `values.yaml`, `values.yaml.example`, and `values.schema.json` in sync.
- Keep `README.md` aligned with `docs/README.md.gotmpl`.
- Preserve backward compatibility deliberately; if a breaking change is necessary, document it clearly.

## Generate README

The chart README is generated from [docs/README.md.gotmpl](./README.md.gotmpl) and [values.yaml](../values.yaml) with `helm-docs`.

Install the local git hook once:

```shell
pre-commit install
pre-commit install-hooks
```

Regenerate the README on demand:

```shell
pre-commit run helm-docs --all-files
```

Or use the local wrapper:

```shell
make docs
```
