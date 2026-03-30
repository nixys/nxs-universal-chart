#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if command -v helm-docs >/dev/null 2>&1; then
  exec helm-docs --chart-search-root=. --template-files=docs/README.md.gotmpl "$@"
fi

if command -v docker >/dev/null 2>&1; then
  exec docker run --rm \
    --volume "$ROOT_DIR:/helm-docs" \
    --workdir /helm-docs \
    --user "$(id -u):$(id -g)" \
    jnorwood/helm-docs:v1.14.2 \
    --chart-search-root=. \
    --template-files=docs/README.md.gotmpl \
    "$@"
fi

echo "helm-docs hook requires either a local 'helm-docs' binary or Docker to run jnorwood/helm-docs:v1.14.2." >&2
exit 1
