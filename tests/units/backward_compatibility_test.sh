#!/bin/sh
set -eu

CHART_VERSION="$(awk '/^version:/ {print $2}' Chart.yaml)"
CURRENT_MAJOR="$(echo "$CHART_VERSION" | cut -d. -f1)"
CURRENT_MINOR="$(echo "$CHART_VERSION" | cut -d. -f2)"
CURRENT_PATCH="$(echo "$CHART_VERSION" | cut -d. -f3 | cut -d- -f1)"

if [ -z "$CURRENT_MAJOR" ] || [ -z "$CURRENT_MINOR" ] || [ -z "$CURRENT_PATCH" ]; then
  echo "ERROR: Failed to parse chart version from Chart.yaml"
  exit 1
fi

latest_stable_tag_for_major() {
  major="$1"
  git tag --list "v${major}.*" \
    | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' \
    | sort -V \
    | tail -n 1
}

latest_stable_tag_for_major_minor() {
  major="$1"
  minor="$2"
  git tag --list "v${major}.${minor}.*" \
    | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' \
    | sort -V \
    | tail -n 1
}

latest_previous_patch_tag() {
  major="$1"
  minor="$2"
  patch="$3"

  git tag --list "v${major}.${minor}.*" \
    | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' \
    | awk -F'[v.]' -v p="$patch" '$4 < p' \
    | sort -V \
    | tail -n 1
}

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

bash ./scripts/helm-deps.sh . >/dev/null

run_compat_check() {
  tag="$1"
  values_file="$TMP_DIR/values-${tag}.yaml"

  git show "${tag}:values.yaml" > "$values_file"

  echo "Checking compatibility with ${tag} values.yaml"
  helm lint . -f "$values_file"
  helm template "compat-${tag}" . -f "$values_file" > /dev/null
}

PREV_MAJOR_TAG=""
if [ "$CURRENT_MAJOR" -eq 0 ]; then
  echo "Skipping previous major compatibility check for ${CHART_VERSION}: no previous major version exists"
else
  PREVIOUS_MAJOR=$((CURRENT_MAJOR - 1))
  PREV_MAJOR_TAG="$(latest_stable_tag_for_major "$PREVIOUS_MAJOR")"
  if [ -z "$PREV_MAJOR_TAG" ]; then
    echo "Skipping previous major compatibility check: no stable tag found for previous major ${PREVIOUS_MAJOR}.x"
  fi
fi

PREV_MINOR_TAG=""
if [ "$CURRENT_MINOR" -eq 0 ]; then
  echo "Skipping previous minor compatibility check for ${CHART_VERSION}: no previous minor version exists"
else
  PREVIOUS_MINOR=$((CURRENT_MINOR - 1))
  PREV_MINOR_TAG="$(latest_stable_tag_for_major_minor "$CURRENT_MAJOR" "$PREVIOUS_MINOR")"
  if [ -z "$PREV_MINOR_TAG" ]; then
    echo "Skipping previous minor compatibility check: no stable tag found for previous minor ${CURRENT_MAJOR}.${PREVIOUS_MINOR}.x"
  fi
fi

PREV_PATCH_TAG=""
if [ "$CURRENT_PATCH" -eq 0 ]; then
  echo "Skipping previous patch compatibility check for ${CHART_VERSION}: no previous patch version exists"
else
  PREV_PATCH_TAG="$(latest_previous_patch_tag "$CURRENT_MAJOR" "$CURRENT_MINOR" "$CURRENT_PATCH")"
  if [ -z "$PREV_PATCH_TAG" ]; then
    echo "Skipping previous patch compatibility check: no stable tag found for previous patch ${CURRENT_MAJOR}.${CURRENT_MINOR}.x below ${CHART_VERSION}"
  fi
fi

CHECKED_TAGS=""
CHECK_COUNT=0

run_compat_check_if_available() {
  tag="$1"

  if [ -z "$tag" ]; then
    return
  fi

  run_compat_check "$tag"

  if [ -n "$CHECKED_TAGS" ]; then
    CHECKED_TAGS="${CHECKED_TAGS}, ${tag}"
  else
    CHECKED_TAGS="$tag"
  fi

  CHECK_COUNT=$((CHECK_COUNT + 1))
}

run_compat_check_if_available "$PREV_MAJOR_TAG"
run_compat_check_if_available "$PREV_MINOR_TAG"
run_compat_check_if_available "$PREV_PATCH_TAG"

if [ "$CHECK_COUNT" -eq 0 ]; then
  echo "No previous stable chart versions found for ${CHART_VERSION}; skipping backward compatibility checks"
  exit 0
fi

echo "Backward compatibility checks passed for: ${CHECKED_TAGS}"
