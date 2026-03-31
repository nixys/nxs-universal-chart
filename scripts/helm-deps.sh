#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

CHART_DIR="${1:-.}"

if helm dependency list "${CHART_DIR}" | awk 'NR == 1 { next } NF && $NF != "ok" { exit 1 }'; then
  exit 0
fi

helm dependency update "${CHART_DIR}"
