from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Callable

from tests.smokes.steps import chart, helm, kubeconform, render, system


@dataclass
class SmokeContext:
    repo_root: Path
    workdir: Path
    chart_dir: Path
    render_dir: Path
    release_name: str
    namespace: str
    kube_version: str
    kubeconform_bin: str
    schema_location: str
    skip_kinds: str

    @property
    def example_values(self) -> Path:
        return self.repo_root / "values.yaml.example"

    @property
    def rendering_contract_values(self) -> Path:
        return self.repo_root / "tests" / "smokes" / "fixtures" / "rendering-contract.values.yaml"

    @property
    def invalid_list_contract_values(self) -> Path:
        return self.repo_root / "tests" / "smokes" / "fixtures" / "invalid-list-contract.values.yaml"


def check_default_empty(context: SmokeContext) -> None:
    helm.lint(context.chart_dir, workdir=context.workdir)
    output_path = context.render_dir / "default-empty.yaml"
    helm.template(
        context.chart_dir,
        release_name=context.release_name,
        namespace=context.namespace,
        output_path=output_path,
        workdir=context.workdir,
    )
    documents = render.load_documents(output_path)
    render.assert_doc_count(documents, 0)


def check_schema_invalid_list_contract(context: SmokeContext) -> None:
    result = helm.lint(
        context.chart_dir,
        values_file=context.invalid_list_contract_values,
        workdir=context.workdir,
        check=False,
    )
    if result.returncode == 0:
        raise system.TestFailure(
            "helm lint unexpectedly succeeded for invalid list-based values"
        )

    combined_output = f"{result.stdout}\n{result.stderr}"
    if "deployments" not in combined_output or "object" not in combined_output:
        raise system.TestFailure(
            "helm lint failed for invalid values, but the error does not mention the object-based contract"
        )


def check_rendering_contract(context: SmokeContext) -> None:
    helm.lint(
        context.chart_dir,
        values_file=context.rendering_contract_values,
        workdir=context.workdir,
    )
    output_path = context.render_dir / "rendering-contract.yaml"
    helm.template(
        context.chart_dir,
        release_name=context.release_name,
        namespace=context.namespace,
        values_file=context.rendering_contract_values,
        output_path=output_path,
        workdir=context.workdir,
    )

    documents = render.load_documents(output_path)
    render.assert_doc_count(documents, 4)

    deployment = render.select_document(documents, kind="Deployment", name="platform-api")
    render.assert_path(deployment, "metadata.labels[app.kubernetes.io/name]", "platform")
    render.assert_path(deployment, "metadata.labels.platform", "shared")
    render.assert_path(deployment, "metadata.labels.component", "api")
    render.assert_path(deployment, "metadata.annotations.team", "platform")
    render.assert_path(deployment, "metadata.annotations.note", "external")
    render.assert_path(deployment, "spec.selector.matchLabels.tenant", "core")
    render.assert_path(deployment, "spec.template.metadata.annotations.environment", "prod")
    render.assert_path(deployment, "spec.template.spec.containers[0].image", "nginx:1.25.4")
    render.assert_path(deployment, "spec.template.spec.topologySpreadConstraints[0].topologyKey", "kubernetes.io/hostname")
    render.assert_path(deployment, "spec.template.spec.containers[0].env[0].value", "prod")

    service = render.select_document(documents, kind="Service", name="platform-api")
    render.assert_path(service, "spec.selector.tenant", "core")
    render.assert_path(service, "spec.selector.component", "api")

    config_map = render.select_document(documents, kind="ConfigMap", name="platform-settings")
    render.assert_path(config_map, "data.ENVIRONMENT", "prod")

    persistent_volume = render.select_document(documents, kind="PersistentVolume", name="platform-shared-data")
    render.assert_path(persistent_volume, "spec.capacity.storage", "2Gi")


def check_example_render(context: SmokeContext) -> None:
    helm.lint(
        context.chart_dir,
        values_file=context.example_values,
        workdir=context.workdir,
    )
    output_path = context.render_dir / "example-render.yaml"
    helm.template(
        context.chart_dir,
        release_name=context.release_name,
        namespace=context.namespace,
        values_file=context.example_values,
        output_path=output_path,
        workdir=context.workdir,
    )

    documents = render.load_documents(output_path)
    render.assert_doc_count(documents, 26)
    render.assert_kinds(
        documents,
        {
            "ClusterRoleBinding",
            "ConfigMap",
            "CronJob",
            "DaemonSet",
            "Deployment",
            "HorizontalPodAutoscaler",
            "Ingress",
            "Job",
            "NetworkPolicy",
            "PersistentVolumeClaim",
            "PersistentVolume",
            "Pod",
            "PodDisruptionBudget",
            "Role",
            "RoleBinding",
            "SealedSecret",
            "Secret",
            "Service",
            "ServiceAccount",
            "StatefulSet",
        },
    )

    config_map = render.select_document(documents, kind="ConfigMap", name="universal-blue-envs")
    render.assert_path(config_map, "data.APP_MODE", "production")

    deployment = render.select_document(documents, kind="Deployment", name="universal-blue-api")
    render.assert_path(deployment, "spec.template.spec.containers[0].image", "nginx:1.27.5")
    render.assert_path(deployment, "metadata.labels.gitops-profile", "platform")
    render.assert_path(deployment, "metadata.annotations[argocd.argoproj.io/sync-wave]", "10")
    render.assert_path(deployment, "spec.template.spec.containers[0].startupProbe.httpGet.port", "http")
    render.assert_path(deployment, "spec.template.spec.topologySpreadConstraints[0].topologyKey", "topology.kubernetes.io/zone")
    render.assert_path(deployment, "spec.template.spec.containers[0].env[2].value", "production")

    stateful_set = render.select_document(documents, kind="StatefulSet", name="universal-blue-worker")
    render.assert_path(stateful_set, "spec.serviceName", "universal-blue-headless")

    daemon_set = render.select_document(documents, kind="DaemonSet", name="universal-blue-node-agent")
    render.assert_path(daemon_set, "spec.template.spec.containers[0].ports[0].name", "metrics")

    pod = render.select_document(documents, kind="Pod", name="universal-blue-toolbox")
    render.assert_path(pod, "spec.containers[0].name", "toolbox")
    render.assert_path(pod, "spec.containers[0].stdin", True)
    render.assert_path(pod, "spec.containers[0].tty", True)

    ingress = render.select_document(documents, kind="Ingress", name="universal-blue-app.example.com")
    render.assert_path(ingress, "spec.ingressClassName", "nginx")

    network_policy = render.select_document(documents, kind="NetworkPolicy", name="universal-blue-allow-api")
    render.assert_path(network_policy, "spec.policyTypes[0]", "Ingress")

    pvc = render.select_document(documents, kind="PersistentVolumeClaim", name="universal-blue-shared-data")
    render.assert_path(pvc, "spec.storageClassName", "standard")

    pv = render.select_document(documents, kind="PersistentVolume", name="universal-blue-shared-data")
    render.assert_path(pv, "spec.storageClassName", "standard")

    sealed_secret = render.select_document(documents, kind="SealedSecret", name="universal-blue-sealed-app")
    render.assert_path(sealed_secret, "spec.encryptedData.password", "AgBy7exampleencryptedpayload")


def check_example_kubeconform(context: SmokeContext) -> None:
    output_path = context.render_dir / "example-kubeconform.yaml"
    helm.template(
        context.chart_dir,
        release_name=context.release_name,
        namespace=context.namespace,
        values_file=context.example_values,
        output_path=output_path,
        workdir=context.workdir,
    )
    kubeconform.validate(
        manifest_path=output_path,
        kube_version=context.kube_version,
        kubeconform_bin=context.kubeconform_bin,
        schema_location=context.schema_location,
        skip_kinds=context.skip_kinds,
    )


SCENARIOS: list[tuple[str, Callable[[SmokeContext], None]]] = [
    ("default-empty", check_default_empty),
    ("schema-invalid-list-contract", check_schema_invalid_list_contract),
    ("rendering-contract", check_rendering_contract),
    ("example-render", check_example_render),
    ("example-kubeconform", check_example_kubeconform),
]

SCENARIO_ALIASES = {
    "schema-invalid-missing-name": "schema-invalid-list-contract",
}


def run_smoke_suite(args) -> int:
    scenario_map = dict(SCENARIOS)
    requested = args.scenario or ["all"]
    if "all" in requested:
        selected = [name for name, _ in SCENARIOS]
    else:
        selected = [SCENARIO_ALIASES.get(name, name) for name in requested]

    repo_root = Path(args.chart_dir).resolve()
    workdir, chart_dir = chart.stage_chart(repo_root, args.workdir)
    context = SmokeContext(
        repo_root=repo_root,
        workdir=workdir,
        chart_dir=chart_dir,
        render_dir=workdir / "rendered",
        release_name=args.release_name,
        namespace=args.namespace,
        kube_version=args.kube_version,
        kubeconform_bin=args.kubeconform_bin,
        schema_location=args.schema_location,
        skip_kinds=args.skip_kinds,
    )
    context.render_dir.mkdir(parents=True, exist_ok=True)

    failures: list[tuple[str, str]] = []
    try:
        for name in selected:
            system.log(f"=== scenario: {name} ===")
            try:
                scenario_map[name](context)
            except Exception as exc:
                failures.append((name, str(exc)))
                system.log(f"FAILED: {name}: {exc}")
            else:
                system.log(f"PASSED: {name}")
    finally:
        if args.keep_workdir:
            system.log(f"workdir kept at {workdir}")
        else:
            chart.cleanup(workdir)

    if failures:
        system.log("=== summary: failures ===")
        for name, message in failures:
            system.log(f"- {name}: {message}")
        return 1

    system.log("=== summary: all smoke scenarios passed ===")
    return 0
