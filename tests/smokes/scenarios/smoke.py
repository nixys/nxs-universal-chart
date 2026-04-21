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

    @property
    def hook_annotations_values(self) -> Path:
        return self.repo_root / "tests" / "smokes" / "fixtures" / "hook-annotations.values.yaml"

    @property
    def hook_annotations_disabled_values(self) -> Path:
        return self.repo_root / "tests" / "smokes" / "fixtures" / "hook-annotations-disabled.values.yaml"

    @property
    def samples_dir(self) -> Path:
        return self.repo_root / "samples"


def rendered_document_text(manifest_path: Path, *, kind: str, name: str) -> str:
    content = manifest_path.read_text(encoding="utf-8")
    for chunk in content.split("\n---\n"):
        normalized = chunk.lstrip("-\n")
        if f"kind: {kind}" in normalized and f"name: {name}" in normalized:
            return normalized
    raise system.TestFailure(f"failed to find rendered raw document {kind}/{name}")


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
    render.assert_path(service, "metadata.labels[traffic-scope]", "shared")
    render.assert_path(service, "metadata.annotations[service.example.com/managed-by]", "general")
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
    render.assert_doc_count(documents, 27)
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
    render.assert_path(deployment, "spec.template.spec.automountServiceAccountToken", True)
    render.assert_path(deployment, "spec.template.spec.securityContext.runAsNonRoot", True)
    render.assert_path(deployment, "spec.template.spec.containers[0].securityContext.readOnlyRootFilesystem", True)
    render.assert_path(deployment, "spec.template.spec.containers[0].securityContext.allowPrivilegeEscalation", False)
    render.assert_path(deployment, "spec.template.spec.containers[0].startupProbe.httpGet.port", "http")
    render.assert_path(deployment, "spec.template.spec.topologySpreadConstraints[0].topologyKey", "topology.kubernetes.io/zone")
    render.assert_path(deployment, "spec.template.spec.volumes[1].projected.sources[0].serviceAccountToken.path", "token")
    render.assert_path(deployment, "spec.template.spec.containers[0].env[2].value", "production")

    stateful_set = render.select_document(documents, kind="StatefulSet", name="universal-blue-worker")
    render.assert_path(stateful_set, "spec.serviceName", "universal-blue-headless")

    service = render.select_document(documents, kind="Service", name="universal-blue-api")
    render.assert_path(service, "metadata.labels[traffic-scope]", "shared")
    render.assert_path(service, "metadata.annotations[service.example.com/managed-by]", "general")

    service_account = render.select_document(documents, kind="ServiceAccount", name="universal-blue-deployer")
    render.assert_path(service_account, "imagePullSecrets[0].name", "registry.example.com")
    render.assert_path(service_account, "imagePullSecrets[1].name", "registry.example.com-rw")

    daemon_set = render.select_document(documents, kind="DaemonSet", name="universal-blue-node-agent")
    render.assert_path(daemon_set, "spec.template.spec.containers[0].ports[0].name", "metrics")

    pod = render.select_document(documents, kind="Pod", name="universal-blue-toolbox")
    render.assert_path(pod, "spec.containers[0].name", "toolbox")
    render.assert_path(pod, "spec.containers[0].stdin", True)
    render.assert_path(pod, "spec.containers[0].tty", True)
    render.assert_path(pod, "spec.automountServiceAccountToken", False)

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


def check_hook_annotations(context: SmokeContext) -> None:
    helm.lint(
        context.chart_dir,
        values_file=context.hook_annotations_values,
        workdir=context.workdir,
    )
    output_path = context.render_dir / "hook-annotations.yaml"
    helm.template(
        context.chart_dir,
        release_name=context.release_name,
        namespace=context.namespace,
        values_file=context.hook_annotations_values,
        output_path=output_path,
        workdir=context.workdir,
    )

    documents = render.load_documents(output_path)
    render.assert_doc_count(documents, 2)

    config_map = render.select_document(documents, kind="ConfigMap", name="smoke-merged-config")
    render.assert_path(config_map, "metadata.annotations[helm.sh/hook]", "post-install")
    render.assert_path(config_map, "metadata.annotations[helm.sh/hook-weight]", "-999")
    render.assert_path(config_map, "metadata.annotations[conflict]", "resource")
    render.assert_path(config_map, "metadata.annotations[custom]", "from-configmap")
    config_map_text = rendered_document_text(output_path, kind="ConfigMap", name="smoke-merged-config")
    if config_map_text.count("helm.sh/hook:") != 1:
        raise system.TestFailure("expected a single helm.sh/hook entry in merged ConfigMap annotations")
    if config_map_text.count("conflict:") != 1:
        raise system.TestFailure("expected a single conflict entry in merged ConfigMap annotations")

    secret = render.select_document(documents, kind="Secret", name="smoke-merged-secret")
    render.assert_path(secret, "metadata.annotations[helm.sh/hook]", "post-install")
    render.assert_path(secret, "metadata.annotations[helm.sh/hook-weight]", "-999")
    render.assert_path(secret, "metadata.annotations[conflict]", "resource")
    render.assert_path(secret, "metadata.annotations[custom]", "from-secret")
    secret_text = rendered_document_text(output_path, kind="Secret", name="smoke-merged-secret")
    if secret_text.count("helm.sh/hook:") != 1:
        raise system.TestFailure("expected a single helm.sh/hook entry in merged Secret annotations")
    if secret_text.count("conflict:") != 1:
        raise system.TestFailure("expected a single conflict entry in merged Secret annotations")

    disabled_output_path = context.render_dir / "hook-annotations-disabled.yaml"
    helm.template(
        context.chart_dir,
        release_name=context.release_name,
        namespace=context.namespace,
        values_file=context.hook_annotations_disabled_values,
        output_path=disabled_output_path,
        workdir=context.workdir,
    )

    disabled_documents = render.load_documents(disabled_output_path)
    render.assert_doc_count(disabled_documents, 2)

    disabled_config_map = render.select_document(
        disabled_documents,
        kind="ConfigMap",
        name="smoke-disabled-hooks-config",
    )
    render.assert_path_missing(disabled_config_map, "metadata.annotations[helm.sh/hook]")
    disabled_config_map_text = rendered_document_text(
        disabled_output_path,
        kind="ConfigMap",
        name="smoke-disabled-hooks-config",
    )
    if "helm.sh/hook:" in disabled_config_map_text:
        raise system.TestFailure("hook annotation unexpectedly rendered for disabled ConfigMap")

    disabled_secret = render.select_document(
        disabled_documents,
        kind="Secret",
        name="smoke-disabled-hooks-secret",
    )
    render.assert_path_missing(disabled_secret, "metadata.annotations[helm.sh/hook]")
    disabled_secret_text = rendered_document_text(
        disabled_output_path,
        kind="Secret",
        name="smoke-disabled-hooks-secret",
    )
    if "helm.sh/hook:" in disabled_secret_text:
        raise system.TestFailure("hook annotation unexpectedly rendered for disabled Secret")


def check_samples_render(context: SmokeContext) -> None:
    if not context.samples_dir.exists():
        raise system.TestFailure("samples directory is missing")

    sample_dirs = sorted(path for path in context.samples_dir.iterdir() if path.is_dir())
    if not sample_dirs:
        raise system.TestFailure("no sample directories found under samples/")

    for sample_dir in sample_dirs:
        values_file = sample_dir / "values.yaml"
        readme_file = sample_dir / "README.md"
        if not values_file.exists():
            raise system.TestFailure(f"sample {sample_dir.name} is missing values.yaml")
        if not readme_file.exists():
            raise system.TestFailure(f"sample {sample_dir.name} is missing README.md")

        helm.lint(
            context.chart_dir,
            values_file=values_file,
            workdir=context.workdir,
        )

        output_path = context.render_dir / f"sample-{sample_dir.name}.yaml"
        helm.template(
            context.chart_dir,
            release_name=context.release_name,
            namespace=context.namespace,
            values_file=values_file,
            output_path=output_path,
            workdir=context.workdir,
        )
        documents = render.load_documents(output_path)
        if not documents:
            raise system.TestFailure(f"sample {sample_dir.name} rendered zero documents")


SCENARIOS: list[tuple[str, Callable[[SmokeContext], None]]] = [
    ("default-empty", check_default_empty),
    ("schema-invalid-list-contract", check_schema_invalid_list_contract),
    ("rendering-contract", check_rendering_contract),
    ("hook-annotations", check_hook_annotations),
    ("samples-render", check_samples_render),
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
