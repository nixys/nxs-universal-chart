import argparse
import os
from pathlib import Path


DEFAULT_SCHEMA_LOCATION = (
    "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/"
    "{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json"
)


def env_or_default(name: str, default: str) -> str:
    value = os.environ.get(name)
    if value is None or not value.strip():
        return default
    return value

SCENARIO_CHOICES = [
    "all",
    "default-empty",
    "schema-invalid-list-contract",
    "schema-invalid-missing-name",
    "rendering-contract",
    "null-workload-entries",
    "hook-annotations",
    "samples-render",
    "example-render",
    "example-kubeconform",
]


def build_parser() -> argparse.ArgumentParser:
    repo_root = Path(__file__).resolve().parents[3]
    parser = argparse.ArgumentParser(
        description="Run smoke tests for the nxs-universal-chart chart."
    )
    parser.add_argument(
        "--chart-dir",
        default=str(repo_root),
        help="Path to the chart repository root.",
    )
    parser.add_argument(
        "--release-name",
        default="smoke",
        help="Release name used for rendered manifests.",
    )
    parser.add_argument(
        "--namespace",
        default="smoke",
        help="Namespace used for rendered namespaced resources.",
    )
    parser.add_argument(
        "--scenario",
        action="append",
        choices=SCENARIO_CHOICES,
        help="Scenario to run. May be specified multiple times. Defaults to all.",
    )
    parser.add_argument(
        "--kube-version",
        default=env_or_default("KUBE_VERSION", "1.35.2"),
        help="Kubernetes version passed to kubeconform.",
    )
    parser.add_argument(
        "--kubeconform-bin",
        default=env_or_default("KUBECONFORM_BIN", "kubeconform"),
        help="kubeconform binary path or command name.",
    )
    parser.add_argument(
        "--schema-location",
        default=env_or_default(
            "KUBECONFORM_CRD_SCHEMA_LOCATION", DEFAULT_SCHEMA_LOCATION
        ),
        help="Additional kubeconform schema location for CRD-backed resources.",
    )
    parser.add_argument(
        "--skip-kinds",
        default=env_or_default(
            "KUBECONFORM_SKIP_KINDS", "SealedSecret"
        ),
        help="Comma-separated kinds to skip in kubeconform.",
    )
    parser.add_argument(
        "--workdir",
        default=None,
        help="Optional existing directory for staged chart and rendered manifests.",
    )
    parser.add_argument(
        "--keep-workdir",
        action="store_true",
        help="Keep the staged work directory after the run.",
    )
    return parser
