# NXS Universal Chart

![Nxs Universal Chart Logo](https://github.com/nixys/nxs-universal-chart/assets/84891358/cb86062f-e5fe-467a-bd98-207fb3026194)

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/nixys)](https://artifacthub.io/packages/search?repo=nixys)

## Introduction

nxs-universal-chart is a Helm chart you can use to install any of your applications into Kubernetes/OpenShift and other orchestrators compatible with native Kubernetes API.

The chart renders through the shared `nuc-common` library chart. `Chart.yaml` points at the published dependency, and local workflows resolve it with `make deps` or `bash scripts/helm-deps.sh .`.

### Features

* Flexible way to deploy your applications.
* Supported any Ingress controllers (Ingress Nginx, Traefik, Istio).
* Easy way to template any custom resource with extraDeploy feature.
* Supported Kubernetes versions (1.23 or newer) and OpenShift versions (3.11/<4.8/4.9/4.11/4.12/4.13).
* Supported Helm versions (2/3/4)

### Who can use this tool

* Development
* DevOps engineers

## Quick Start

Login to the Nixys OCI registry:

```bash
helm repo add nixys https://registry.nixys.io/nuc
```

Install the chart:

```bash
helm install nxs-universal-chart nixys/nxs-universal-chart \
  --namespace app-system \
  --create-namespace
```

The command deploys your application with custom values on the Kubernetes/OpenShift cluster. For additional ways to customize your experience with nxs-universal-chart please check [Additional features](docs/ADDITIONAL_FEATURES.md).

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

The chart can render these Kubernetes resource families:

- `Deployment`
- `StatefulSet`
- `Service`
- `Ingress`
- `ConfigMap`
- `Secret`
- `SealedSecret`
- `PersistentVolumeClaim`
- `ServiceAccount`, `Role`, `RoleBinding`, `ClusterRoleBinding`
- `Job`
- `CronJob`
- `HorizontalPodAutoscaler`
- `PodDisruptionBudget`
- raw resources through `extraDeploy`

## Dependency Subcharts

The chart also declares reusable dependency subcharts. `nuc-common` is always loaded as the shared helper library; the remaining `nuc-*` dependencies are enabled only through their matching `.Values.<name>.enabled` flags.

| Subchart | Enabled by | Source chart | Includes |
|----------|------------|--------------|----------|
| `nuc-common` | always | [nuc-common](https://github.com/nixys/nuc-common) | Shared Helm library helpers for capability detection, pod/workload rendering, labels, templating, configmaps, secrets, ingress, volumes, and deprecation notices. |
| `nuc-traefik` | `nuc-traefik.enabled` | [nuc-traefik](https://github.com/nixys/nuc-traefik) | Traefik CRDs: `IngressRoute`, `IngressRouteTCP`, `IngressRouteUDP`, `Middleware`, `MiddlewareTCP`, `TLSOption`, `TLSStore`, `ServersTransport`, `ServersTransportTCP`, and `TraefikService`. |
| `nuc-certificates` | `nuc-certificates.enabled` | [nuc-certificates](https://github.com/nixys/nuc-certificates) | cert-manager resources: `Certificate`, `CertificateRequest`, `Issuer`, `ClusterIssuer`, `Challenge`, and `Order`. |
| `nuc-istio` | `nuc-istio.enabled` | [nuc-istio](https://github.com/nixys/nuc-istio) | Istio traffic-management resources: `Gateway`, `VirtualService`, and `DestinationRule`. |
| `nuc-knative` | `nuc-knative.enabled` | [nuc-knative](https://github.com/nixys/nuc-knative) | Knative Serving resources including `Service`, `Route`, `Configuration`, `Revision`, `Ingress`, `PodAutoscaler`, `ServerlessService`, `DomainMapping`, and related serving objects. |
| `nuc-kserve` | `nuc-kserve.enabled` | [nuc-kserve](https://github.com/nixys/nuc-kserve) | KServe resources such as `InferenceService`, `InferenceGraph`, `ServingRuntime`, `ClusterServingRuntime`, `TrainedModel`, and model cache/storage CRDs. |
| `nuc-kube-prometheus-stack` | `nuc-kube-prometheus-stack.enabled` | [nuc-kube-prometheus-stack](https://github.com/nixys/nuc-kube-prometheus-stack) | Prometheus Operator monitoring resources: `PodMonitor`, `Probe`, `PrometheusRule`, `ScrapeConfig`, and `ServiceMonitor`. |
| `nuc-native-gateway` | `nuc-native-gateway.enabled` | [nuc-native-gateway](https://github.com/nixys/nuc-native-gateway) | Gateway API resources: `GatewayClass`, `Gateway`, `HTTPRoute`, `GRPCRoute`, `TLSRoute`, `ReferenceGrant`, `BackendTLSPolicy`, and `ListenerSet`. |
| `nuc-victoria-metrics` | `nuc-victoria-metrics.enabled` | [nuc-victoria-metrics](https://github.com/nixys/nuc-victoria-metrics) | VictoriaMetrics Operator resources: `VMAlert`, `VMRule`, `VMProbe`, `VMScrapeConfig`, `VMServiceScrape`, and `VMStaticScrape`. |
| `nuc-vault-secret-operator` | `nuc-vault-secret-operator.enabled` | [nuc-vault-secret-operator](https://github.com/nixys/nuc-vault-secret-operator) | Vault Secret Operator resources: `VaultAuth` and `VaultStaticSecret`. |
| `nuc-argocd` | `nuc-argocd.enabled` | [nuc-argocd](https://github.com/nixys/nuc-argocd) | Argo CD resources: `Application`, `ApplicationSet`, and `AppProject`. |
| `nuc-keda` | `nuc-keda.enabled` | [nuc-keda](https://github.com/nixys/nuc-keda) | KEDA autoscaling resources: `ScaledObject`, `ScaledJob`, `TriggerAuthentication`, and `ClusterTriggerAuthentication`. |

## Values Model

The values contract is grouped by resource family:

- `deployments`, `statefulSets`
- `services`, `ingresses`
- `configMaps`, `secrets`, `sealedSecrets`, `pvcs`
- `jobs`, `cronJobs`, `hooks`
- `serviceAccount`
- `hpas`, `pdbs`
- `extraDeploy`

Shared controls:

- `generic.*` for common labels, annotations, selectors, pod metadata, shared mounts, templated variables, and helper capability overrides
- `envs` / `secretEnvs` for generated shared ConfigMap and Secret resources
- `defaultImage*` for container image defaults
- affinity presets and optional `generic` capability overrides

Additional keys under `generic` are available to `tpl` rendering as `.Values.generic.*`, so one shared variable set can be reused across resources without a separate `global` block.

The values contract is validated by [values.schema.json](values.schema.json).

## Helm Values

This section is generated from [values.yaml](values.yaml) by `helm-docs`. Edit [values.yaml](values.yaml) comments or [docs/README.md.gotmpl](docs/README.md.gotmpl), then run `pre-commit run helm-docs --all-files` or `make docs` if you need to refresh it outside a commit.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMaps | object | `{}` | ConfigMap resources keyed by configmap suffix. |
| cronJobs | object | `{}` | CronJobs keyed by resource suffix. |
| cronJobsGeneral | object | `{}` | Shared defaults applied to CronJobs. |
| daemonSets | object | `{}` | DaemonSet workloads keyed by resource suffix. |
| daemonSetsGeneral | object | `{}` | Shared defaults applied to DaemonSet workloads. |
| defaultImage | string | `"nginx"` | Default container image used when a container omits `image`. |
| defaultImagePullPolicy | string | `"IfNotPresent"` | Default container image pull policy used when a container omits `imagePullPolicy`. |
| defaultImageTag | string | `"latest"` | Default container image tag used when a container omits `imageTag`. |
| deployments | object | `{}` | Deployment workloads keyed by resource suffix. |
| deploymentsGeneral | object | `{}` | Shared defaults applied to Deployment workloads. |
| diagnosticMode | object | `{"args":["infinity"],"command":["sleep"],"enabled":false,"enbled":false}` | Optional diagnostic mode overriding container command and args in all workloads. |
| envs | object | `{}` | Shared ConfigMap key-value pairs rendered into the generated `envs` ConfigMap. |
| envsString | string | `""` | Raw YAML string merged into the generated `envs` ConfigMap. |
| extraDeploy | object | `{}` | Additional raw manifests rendered through `tpl`, keyed by logical name. |
| generic | object | `{"annotations":{},"apiVersions":{},"autoRolloutChecksums":true,"defaultURL":"","deterministicNames":true,"dnsPolicy":"","extraImagePullSecrets":[],"extraSelectorLabels":{},"extraVolumeMounts":[],"extraVolumes":[],"fullnameOverride":"","helmVersion":"","hostAliases":[],"kubeVersion":"","labels":{},"nameSuffix":"","podAnnotations":{},"podLabels":{},"priorityClassName":"","serviceAccountName":"","tolerations":[],"topologySpreadConstraints":[],"usePredefinedAffinity":true,"volumeMounts":[],"volumes":[]}` | Shared defaults and reusable values for all rendered templates. |
| generic.annotations | object | `{}` | Annotations merged into every resource. |
| generic.apiVersions | object | `{}` | Optional API version overrides used by capability helpers. |
| generic.autoRolloutChecksums | bool | `true` | Add checksum annotations for chart-managed ConfigMaps and Secrets to workload pod templates. |
| generic.defaultURL | string | `""` | Optional default URL override exposed through `.Values.generic.defaultURL`. |
| generic.deterministicNames | bool | `true` | Render deterministic fallback names for unnamed containers and initContainers. |
| generic.dnsPolicy | string | `""` | Shared DNS policy. |
| generic.extraImagePullSecrets | list | `[]` | Shared imagePullSecrets appended to all workload specs. |
| generic.extraSelectorLabels | object | `{}` | Extra selector labels merged into selectors and workload pod labels. |
| generic.extraVolumeMounts | list | `[]` | Deprecated alias for `volumeMounts`. |
| generic.extraVolumes | list | `[]` | Shared raw volumes appended to all workload specs. |
| generic.fullnameOverride | string | `""` | Deterministic base name override used by all rendered resources. |
| generic.helmVersion | string | `""` | Optional Helm version override used by capability helpers. |
| generic.hostAliases | list | `[]` | Shared hostAliases block. |
| generic.kubeVersion | string | `""` | Optional Kubernetes version override used by capability helpers. |
| generic.labels | object | `{}` | Labels merged into every resource. |
| generic.nameSuffix | string | `""` | Optional suffix appended to the deterministic base name. |
| generic.podAnnotations | object | `{}` | Extra annotations merged into all workload pods. |
| generic.podLabels | object | `{}` | Extra labels merged into all workload pods. |
| generic.priorityClassName | string | `""` | Shared priorityClassName. |
| generic.serviceAccountName | string | `""` | Shared serviceAccountName used when workload-level value is omitted. |
| generic.tolerations | list | `[]` | Shared pod tolerations. |
| generic.topologySpreadConstraints | list | `[]` | Shared topologySpreadConstraints applied to all workload pod specs unless overridden per workload. |
| generic.usePredefinedAffinity | bool | `true` | Enable generated affinity presets when workload affinity is not specified. |
| generic.volumeMounts | list | `[]` | Shared volume mounts appended to all containers. |
| generic.volumes | list | `[]` | Shared typed volumes appended to all workload specs. |
| gitOps | object | `{"safeMode":false}` | Legacy GitOps-safe rendering options kept for backward compatibility. Deterministic naming is enabled by default through `generic.deterministicNames`. |
| gitOps.safeMode | bool | `false` | Use deterministic fallback names for unnamed containers and initContainers. |
| gitops | object | `{"argo":{"compareOptions":[],"enabled":false,"syncOptions":[],"syncWave":null},"commonAnnotations":{},"commonLabels":{},"flux":{"annotations":{},"enabled":false,"labels":{}}}` | Shared GitOps metadata and controller-specific annotations/labels. |
| gitops.argo.compareOptions | list | `[]` | Optional Argo CD compare options joined into `argocd.argoproj.io/compare-options`. |
| gitops.argo.enabled | bool | `false` | Enable Argo CD annotations rendering. |
| gitops.argo.syncOptions | list | `[]` | Optional Argo CD sync options joined into `argocd.argoproj.io/sync-options`. |
| gitops.argo.syncWave | string | `nil` | Optional Argo CD sync wave applied to resources. |
| gitops.commonAnnotations | object | `{}` | Annotations applied to all rendered resources. |
| gitops.commonLabels | object | `{}` | Labels applied to all rendered resources. |
| gitops.flux.annotations | object | `{}` | Optional Flux annotations merged into resource metadata when enabled. |
| gitops.flux.enabled | bool | `false` | Enable Flux-specific labels and annotations rendering. |
| gitops.flux.labels | object | `{}` | Optional Flux labels merged into resource metadata when enabled. |
| hooks | object | `{}` | Helm hook Jobs keyed by resource suffix. |
| hooksGeneral | object | `{}` | Shared defaults applied to hook Jobs. |
| hpas | object | `{}` | HorizontalPodAutoscaler resources keyed by resource suffix. |
| imagePullSecrets | object | `{}` | Docker config JSON payloads rendered as imagePullSecrets. |
| ingresses | object | `{}` | Ingress resources keyed by host or logical name. |
| jobs | object | `{}` | Jobs keyed by resource suffix. |
| jobsGeneral | object | `{}` | Shared defaults applied to one-shot Jobs. |
| kubeVersion | string | `""` | Optional Kubernetes version override used by capability helpers. |
| nameOverride | string | `""` | Override the generated application name used in labels and resource names. |
| networkPolicies | object | `{}` | NetworkPolicies keyed by resource suffix. |
| nodeAffinityPreset | object | `{"key":"","type":"","values":[]}` | Node affinity preset used when generated affinities are enabled. |
| nodeAffinityPreset.key | string | `""` | Node label key used by generated node affinity. |
| nodeAffinityPreset.type | string | `""` | Node affinity type: `soft` or `hard`. |
| nodeAffinityPreset.values | list | `[]` | Node label values used by generated node affinity. |
| nuc-argocd.enabled | bool | `false` |  |
| nuc-certificates.enabled | bool | `false` |  |
| nuc-common | object | `{"enabled":false}` | Optional dependency overrides and compatibility toggles preserved from previous umbrella-chart releases. |
| nuc-fluxcd.enabled | bool | `false` |  |
| nuc-istio.enabled | bool | `false` |  |
| nuc-keda.enabled | bool | `false` |  |
| nuc-knative.enabled | bool | `false` |  |
| nuc-kserve.enabled | bool | `false` |  |
| nuc-kube-prometheus-stack.enabled | bool | `false` |  |
| nuc-native-gateway.enabled | bool | `false` |  |
| nuc-traefik.enabled | bool | `false` |  |
| nuc-vault-secret-operator.enabled | bool | `false` |  |
| nuc-victoria-metrics.enabled | bool | `false` |  |
| pdbs | object | `{}` | PodDisruptionBudget resources keyed by resource suffix. |
| podAffinityPreset | string | `"soft"` | Pod affinity preset used when generated affinities are enabled. |
| podAntiAffinityPreset | string | `"soft"` | Pod anti-affinity preset used when generated affinities are enabled. |
| pods | object | `{}` | Pod workloads keyed by resource suffix. |
| podsGeneral | object | `{}` | Shared defaults applied to Pod workloads. |
| pvcs | object | `{}` | PersistentVolumeClaim resources keyed by claim suffix. |
| pvs | object | `{}` | PersistentVolume resources keyed by volume suffix. |
| releasePrefix | string | `""` | Prefix prepended to rendered resource names. Set `"-"` to drop the release-name prefix entirely. |
| sealedSecrets | object | `{}` | SealedSecret resources keyed by secret suffix. |
| secretEnvs | object | `{}` | Shared Secret key-value pairs rendered into the generated `secret-envs` Secret. |
| secretEnvsString | string | `""` | Raw YAML string merged into the generated `secret-envs` Secret. |
| secrets | object | `{}` | Secret resources keyed by secret suffix. |
| serviceAccount | object | `{}` | ServiceAccount resources keyed by service-account suffix. |
| serviceAccountGeneral | object | `{}` | Shared defaults applied to generated ServiceAccounts. |
| services | object | `{}` | Service resources keyed by service name. |
| statefulSets | object | `{}` | StatefulSet workloads keyed by resource suffix. |
| statefulSetsGeneral | object | `{}` | Shared defaults applied to StatefulSet workloads. |
| workloadMode | string | `"auto"` | Restrict rendered workload controllers: `auto`, `deployment`, `daemonset`, `pod`, `statefulset`, `batch`, `job`, `cronjob`, `hook`, or `none`. |

## Included Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources.
- [values.yaml.example](values.yaml.example): representative example covering every supported template family.
- [tests/e2e/values/install.values.yaml](tests/e2e/values/install.values.yaml): cluster-safe installation fixture used by the local e2e runner.

## Testing

The repository uses four verification layers:

- `make lint`
- `make test-unit`
- `make test-compat`
- `make test-smoke` / `make test-smoke-fast`
- `make test-e2e`

Representative commands:

```bash
make deps
helm lint . -f values.yaml.example
make deps
helm unittest --with-subchart=false -f 'tests/units/*_test.yaml' .
sh tests/units/backward_compatibility_test.sh
python3 tests/smokes/run/smoke.py --scenario example-render
make test-e2e
```

Detailed test documentation is available in [docs/TESTS.MD](docs/TESTS.MD).

Local dependency setup instructions are available in [docs/DEPENDENCY.md](docs/DEPENDENCY.md).

## Repository Layout

| Path | Purpose |
|------|---------|
| [Chart.yaml](Chart.yaml) | Chart metadata. |
| [Chart.lock](Chart.lock) | Locked dependency metadata refreshed by `make deps` / `scripts/helm-deps.sh`. |
| [values.yaml](values.yaml) | Minimal default values and `helm-docs` source comments. |
| [values.yaml.example](values.yaml.example) | Representative example covering all template families. |
| [values.schema.json](values.schema.json) | JSON schema for chart values. |
| [templates/](templates) | Application resource templates that consume shared helpers from the `nuc-common` dependency. |
| [tests/units/](tests/units) | Helm unit suites and compatibility checks. |
| [tests/smokes/](tests/smokes) | Smoke scenarios for linting, rendering, and schema validation. |
| [tests/e2e/](tests/e2e) | kind-based end-to-end installation checks. |
| [docs/README.md.gotmpl](docs/README.md.gotmpl) | Template used by `helm-docs` to build this README. |
| [scripts/helm-docs.sh](scripts/helm-docs.sh) | Local wrapper around `helm-docs`. |

## Notes

- `SealedSecret` is a CRD-backed resource. Smoke `kubeconform` skips it by default, and e2e uses a CRD-free fixture so the local cluster flow stays lightweight.
- Shared helper behavior comes from the `nuc-common` library dependency; run `make deps` before direct `helm lint`, `helm template`, or `helm install` commands.
- Previous umbrella-chart toggles such as `nuc-common.enabled` remain in the values contract for compatibility.
- `diagnosticMode.enbled` is still accepted for backward compatibility, but `diagnosticMode.enabled` is the supported field.

## Roadmap

Following features are already in backlog for our development team and will be done soon:

* Test operability on newer versions of Kubernetes/OpenShift.
* Add samples

## Feedback

For support and feedback please contact me:

* telegram: @Peter_Rukin
* email: p.rukin@nixys.io

For news and discussions subscribe the channels:
- telegram community (news): [@nxs_universal_chart](https://t.me/nxs_universal_chart)
- telegram community (chat): [@nxs_universal_chart_chat](https://t.me/nxs_universal_chart_chat)

## License

nxs-universal-chart is released under the [Apache License 2.0](LICENSE).
