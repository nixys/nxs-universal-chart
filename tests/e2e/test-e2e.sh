#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
SCRIPT_DIR="${ROOT_DIR}/tests/e2e"
CLUSTER_CREATED=false
CLUSTER_NAME="${CLUSTER_NAME:-$(mktemp -u "nxs-universal-chart-e2e-XXXXXXXXXX" | tr "[:upper:]" "[:lower:]")}"
K8S_VERSION="${K8S_VERSION:-v1.35.0}"
E2E_NAMESPACE="nxs-universal-chart-e2e"
RELEASE_NAME="nxs-universal-chart-e2e"
VALUES_FILE="tests/e2e/values/install.values.yaml"

RED='\033[0;31m'
YELLOW='\033[0;33m'
RESET='\033[0m'

log_error() { echo -e "${RED}Error:${RESET} $1" >&2; }
log_info() { echo -e "$1"; }
log_warn() { echo -e "${YELLOW}Warning:${RESET} $1" >&2; }

show_help() {
  echo "Usage: $(basename "$0") [helm upgrade/install options]"
  echo ""
  echo "Create a kind cluster and run Helm install/upgrade against the root chart."
  echo "Unknown arguments are passed through to 'helm upgrade --install'."
  echo ""
  echo "Environment overrides:"
  echo "  CLUSTER_NAME          Kind cluster name"
  echo "  K8S_VERSION           kindest/node tag"
  echo ""
}

verify_prerequisites() {
  for bin in docker kind kubectl helm; do
    if ! command -v "${bin}" >/dev/null 2>&1; then
      log_error "${bin} is not installed"
      exit 1
    fi
  done
}

update_chart_dependencies() {
  log_info "Updating chart dependencies"
  bash "${ROOT_DIR}/scripts/helm-deps.sh" "${ROOT_DIR}"
  echo
}

cleanup() {
  local exit_code=$?

  if [ "${exit_code}" -ne 0 ] && [ "${CLUSTER_CREATED}" = true ]; then
    dump_cluster_state || true
  fi

  log_info "Cleaning up resources"

  if [ "${CLUSTER_CREATED}" = true ]; then
    log_info "Removing kind cluster ${CLUSTER_NAME}"
    if kind get clusters | grep -q "${CLUSTER_NAME}"; then
      kind delete cluster --name="${CLUSTER_NAME}"
    else
      log_warn "kind cluster ${CLUSTER_NAME} not found"
    fi
  fi

  exit "${exit_code}"
}

dump_cluster_state() {
  log_warn "Dumping namespace-scoped resources from ${CLUSTER_NAME}"
  kubectl get pods,daemonset,svc,ingress,job,cronjob,hpa,pdb,networkpolicy,configmap,secret -A || true
}

create_kind_cluster() {
  log_info "Creating kind cluster ${CLUSTER_NAME}"

  if kind get clusters | grep -q "${CLUSTER_NAME}"; then
    log_error "kind cluster ${CLUSTER_NAME} already exists"
    exit 1
  fi

  kind create cluster \
    --name="${CLUSTER_NAME}" \
    --config="${SCRIPT_DIR}/kind.yaml" \
    --image="kindest/node:${K8S_VERSION}" \
    --wait=60s

  CLUSTER_CREATED=true
  echo
}

ensure_namespace() {
  log_info "Ensuring namespace ${E2E_NAMESPACE} exists"
  kubectl get namespace "${E2E_NAMESPACE}" >/dev/null 2>&1 || kubectl create namespace "${E2E_NAMESPACE}"
  echo
}

install_chart() {
  local helm_args=(
    upgrade
    --install
    "${RELEASE_NAME}"
    "${ROOT_DIR}"
    --namespace "${E2E_NAMESPACE}"
    -f "${ROOT_DIR}/${VALUES_FILE}"
    --wait
    --timeout 300s
  )

  if [ "$#" -gt 0 ]; then
    helm_args+=("$@")
  fi

  log_info "Installing chart with Helm"
  helm "${helm_args[@]}"
  echo
}

verify_release_resources() {
  log_info "Verifying installed resources"
  kubectl -n "${E2E_NAMESPACE}" get deployment e2e-api
  kubectl -n "${E2E_NAMESPACE}" get daemonset e2e-node-agent
  kubectl -n "${E2E_NAMESPACE}" get pod e2e-toolbox
  kubectl -n "${E2E_NAMESPACE}" get statefulset e2e-worker
  kubectl -n "${E2E_NAMESPACE}" get service e2e-api
  kubectl -n "${E2E_NAMESPACE}" get service e2e-headless
  kubectl -n "${E2E_NAMESPACE}" get ingress e2e-e2e.example.local
  kubectl -n "${E2E_NAMESPACE}" get hpa e2e-api
  kubectl -n "${E2E_NAMESPACE}" get pdb e2e-api
  kubectl -n "${E2E_NAMESPACE}" get networkpolicy e2e-allow-api
  kubectl -n "${E2E_NAMESPACE}" get configmap e2e-envs
  kubectl -n "${E2E_NAMESPACE}" get secret e2e-secret-envs
  kubectl -n "${E2E_NAMESPACE}" get job e2e-predeploy
  kubectl -n "${E2E_NAMESPACE}" get job e2e-migration
  kubectl -n "${E2E_NAMESPACE}" get cronjob e2e-cleanup
  kubectl -n "${E2E_NAMESPACE}" rollout status deployment/e2e-api --timeout=180s
  kubectl -n "${E2E_NAMESPACE}" rollout status daemonset/e2e-node-agent --timeout=180s
  kubectl -n "${E2E_NAMESPACE}" rollout status statefulset/e2e-worker --timeout=180s
  kubectl -n "${E2E_NAMESPACE}" wait --for=condition=Ready pod/e2e-toolbox --timeout=180s
  echo
}

parse_args() {
  for arg in "$@"; do
    case "${arg}" in
      -h|--help)
        show_help
        exit 0
        ;;
    esac
  done
}

main() {
  parse_args "$@"
  verify_prerequisites

  trap cleanup EXIT

  update_chart_dependencies
  create_kind_cluster
  ensure_namespace
  install_chart "$@"
  verify_release_resources

  log_info "End-to-end checks completed successfully"
}

main "$@"
