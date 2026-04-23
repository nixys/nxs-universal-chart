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

## Table of Contents

- [Introduction](#introduction)
- [Quick Start](#quick-start)
- [Supported Resources](#supported-resources)
- [Dependency Subcharts](#dependency-subcharts)
- [Values Model](#values-model)
- [Helm Values](#helm-values)
- [Included Values Files](#included-values-files)
- [Testing](#testing)
- [Repository Layout](#repository-layout)
- [Notes](#notes)
- [Roadmap](#roadmap)
- [Feedback](#feedback)
- [License](#license)

## Quick Start

Install the chart:

```bash
helm install nxs-universal-chart oci://registry.nixys.ru/nuc/nxs-universal-chart \
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
| `nuc-cloudnativepg` | `nuc-cloudnativepg.enabled` | [nuc-cloudnativepg](https://github.com/nixys/nuc-cloudnativepg) | CloudNativePG resources: `Backup`, `ClusterImageCatalog`, `Cluster`, `Database`, `FailoverQuorum`, `ImageCatalog`, `Pooler`, `Publication`, `ScheduledBackup`, and `Subscription`. |
| `nuc-mysql-percona-operator` | `nuc-mysql-percona-operator.enabled` | [nuc-mysql-percona-operator](https://github.com/nixys/nuc-mysql-percona-operator) | Percona XtraDB Cluster Operator resources: `PerconaXtraDBCluster`, `PerconaXtraDBClusterBackup`, and `PerconaXtraDBClusterRestore`. |
| `nuc-rabbitmq` | `nuc-rabbitmq.enabled` | [nuc-rabbitmq](https://github.com/nixys/nuc-rabbitmq) | RabbitMQ Cluster Operator and Messaging Topology Operator resources: `RabbitmqCluster`, `Queue`, `Policy`, `Exchange`, `Binding`, `User`, `Permission`, `Vhost`, `Federation`, and `Shovel`. |
| `nuc-clickhouse` | `nuc-clickhouse.enabled` | [nuc-clickhouse](https://github.com/nixys/nuc-clickhouse) | Altinity ClickHouse Operator resources: `ClickHouseInstallation`, `ClickHouseInstallationTemplate`, `ClickHouseOperatorConfiguration`, and `ClickHouseKeeperInstallation`. |
| `nuc-elk` | `nuc-elk.enabled` | [nuc-elk](https://github.com/nixys/nuc-elk) | Elastic Cloud on Kubernetes resources: `Elasticsearch`, `Kibana`, `ApmServer`, `Beat`, `Agent`, `EnterpriseSearch`, `ElasticMapsServer`, and `Logstash`. |

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

This section contains a resource-oriented values reference. It is grouped by resource families and shared contracts to make day-to-day editing easier.

Quick links to value tables:
- [Global Controls](#global-controls)
- [GitOps Metadata](#gitops-metadata)
- [Shared Generic Contract](#shared-generic-contract)
- [Runtime Defaults and Shared Generated Resources](#runtime-defaults-and-shared-generated-resources)
- [Workload Families (Top-Level Maps)](#workload-families-top-level-maps)
- [Common Workload Entry Fields](#common-workload-entry-fields)
- [Container Entry Fields](#container-entry-fields)
- [Workload-Specific Fields](#workload-specific-fields)
- [Workload General Fields](#workload-general-fields)
- [Networking Resources](#networking-resources)
- [Config and Secret Resources](#config-and-secret-resources)
- [RBAC, Storage, and Observability](#rbac-storage-and-observability)
- [Dependency Toggle Fields](#dependency-toggle-fields)
- [Reusable Schema Contracts (Exact Definitions)](#reusable-schema-contracts-exact-definitions)

Schema matching note:
- Field names below follow `values.schema.json` 1:1, including legacy aliases (`diagnosticMode.enbled`) and `string|map` contracts.
- Where schema has `additionalProperties: true`, extra keys are allowed and passed through to templates/helpers.
- `Default` reflects chart runtime defaults from `values.yaml`/templates; `schema default` exists only where explicitly defined in `values.schema.json`.

### Global Controls

| Field | Example | Default | Description |
|---|---|---|---|
| `nameOverride` | `nameOverride: "platform"` | `""` | Overrides generated application name used in labels and resource names. |
| `releasePrefix` | `releasePrefix: "prod"` | `""` | Prefix for rendered names. Use `"-"` to disable release-name prefixing. |
| `kubeVersion` | `kubeVersion: "1.31.0"` | `""` | Optional Kubernetes version override used by capability helpers. |
| `workloadMode` | `workloadMode: "batch"` | `"auto"` | Limits which workload families are rendered (`auto`, `deployment`, `daemonset`, `pod`, `statefulset`, `batch`, `job`, `cronjob`, `hook`, `none`). |
| `extraDeploy` | `extraDeploy.my-crd: "apiVersion: v1\nkind: ConfigMap\n..."` | `{}` | Additional raw manifests rendered via `tpl`. |

### GitOps Metadata

| Field | Example | Default | Description |
|---|---|---|---|
| `gitops.commonLabels` | `gitops.commonLabels.team: "platform"` | `{}` | Labels merged into metadata for all resources. |
| `gitops.commonAnnotations` | `gitops.commonAnnotations.owner: "platform"` | `{}` | Annotations merged into metadata for all resources. |
| `gitops.argo.enabled` | `gitops.argo.enabled: true` | `false` | Enables Argo CD metadata annotations rendering. |
| `gitops.argo.syncWave` | `gitops.argo.syncWave: "10"` | `null` | Global Argo sync wave (`argocd.argoproj.io/sync-wave`). |
| `gitops.argo.syncOptions` | `["ServerSideApply=true"]` | `[]` | Global Argo sync options joined into a comma-separated annotation. |
| `gitops.argo.compareOptions` | `["IgnoreExtraneous"]` | `[]` | Global Argo compare options annotation value. |
| `gitops.flux.enabled` | `gitops.flux.enabled: true` | `false` | Enables Flux-specific metadata overlays. |
| `gitops.flux.labels` | `gitops.flux.labels.kustomize.toolkit.fluxcd.io/name: "app"` | `{}` | Flux labels merged when Flux mode is enabled. |
| `gitops.flux.annotations` | `gitops.flux.annotations.kustomize.toolkit.fluxcd.io/namespace: "flux-system"` | `{}` | Flux annotations merged when Flux mode is enabled. |
| `gitOps.safeMode` | `gitOps.safeMode: true` | `false` | Legacy alias for deterministic naming behavior. |

### Shared Generic Contract

| Field | Example | Default | Description |
|---|---|---|---|
| `generic.labels` | `generic.labels.environment: "prod"` | `{}` | Global labels merged into every rendered object. |
| `generic.annotations` | `generic.annotations.contact: "platform@corp"` | `{}` | Global annotations merged into every rendered object. |
| `generic.hookAnnotations` | `generic.hookAnnotations.helm.sh/hook: "pre-install,pre-upgrade"` | `{"helm.sh/hook":"pre-install,pre-upgrade","helm.sh/hook-weight":"-999","helm.sh/hook-delete-policy":"before-hook-creation"}` | Default hook annotations for generated ConfigMaps and Secrets. Set to `null` to disable them. |
| `generic.fullnameOverride` | `generic.fullnameOverride: "platform-core"` | `""` | Deterministic base name override for all resources. |
| `generic.nameSuffix` | `generic.nameSuffix: "blue"` | `""` | Suffix appended to deterministic base name. |
| `generic.deterministicNames` | `generic.deterministicNames: true` | `true` | Enables deterministic fallback names for unnamed containers/initContainers. |
| `generic.autoRolloutChecksums` | `generic.autoRolloutChecksums: true` | `true` | Adds checksum pod annotations for ConfigMaps/Secrets referenced by each workload. |
| `generic.extraSelectorLabels` | `generic.extraSelectorLabels.tenant: "shared"` | `{}` | Extra labels merged into selectors and pod labels. |
| `generic.podLabels` | `generic.podLabels.tier: "backend"` | `{}` | Labels applied to all workload pod templates. |
| `generic.podAnnotations` | `generic.podAnnotations.rendered-from: "values"` | `{}` | Annotations applied to all workload pod templates. |
| `generic.podSecurityContext` | `generic.podSecurityContext.runAsNonRoot: true` | `{}` | Default pod security context applied when workload-level `securityContext` is omitted. |
| `generic.containerSecurityContext` | `generic.containerSecurityContext.readOnlyRootFilesystem: true` | `{}` | Default container security context applied when container-level `securityContext` is omitted. |
| `generic.defaultURL` | `generic.defaultURL: "https://app.example.com"` | `""` | Optional shared URL value for templates and `tpl` usage. |
| `generic.helmVersion` | `generic.helmVersion: "v3.17.1"` | `""` | Optional Helm version override for capability checks. |
| `generic.kubeVersion` | `generic.kubeVersion: "1.31.0"` | `""` | Optional Kubernetes version override for capability checks. |
| `generic.apiVersions` | `generic.apiVersions.networking.k8s.io/v1/Ingress: true` | `{}` | Extra API-version availability overrides. |
| `generic.volumes` | `generic.volumes: [{name: shared, type: configMap}]` | `[]` | Typed volumes appended to all workloads. |
| `generic.extraVolumes` | `generic.extraVolumes: [{name: cache, emptyDir: {}}]` | `[]` | Raw volume specs appended to all workloads. |
| `generic.volumeMounts` | `generic.volumeMounts: [{name: shared, mountPath: /etc/shared}]` | `[]` | Volume mounts appended to all containers. |
| `generic.extraVolumeMounts` | `generic.extraVolumeMounts: [{name: old, mountPath: /old}]` | `[]` | Deprecated alias for `generic.volumeMounts`. |
| `generic.extraImagePullSecrets` | `generic.extraImagePullSecrets: [{name: regcred}]` | `[]` | Extra pull secrets appended to workload pod specs. |
| `generic.resources` | `generic.resources.requests.cpu: 100m` | `{}` | Last-resort container resources fallback. Applied when neither the container nor its workload `*General` sets `resources`. Allowed keys: `requests`, `limits`, `claims`. |
| `generic.tolerations` | `generic.tolerations: [{key: dedicated, operator: Exists}]` | `[]` | Shared pod tolerations. |
| `generic.nodeSelector` | `generic.nodeSelector.nodepool: apps` | `{}` | Shared node selector applied to workloads when omitted per workload. |
| `generic.topologySpreadConstraints` | `generic.topologySpreadConstraints: [{maxSkew: 1, topologyKey: kubernetes.io/hostname, whenUnsatisfiable: ScheduleAnyway}]` | `[]` | Shared topology spread constraints for workloads. |
| `generic.hostAliases` | `generic.hostAliases: [{ip: 10.0.0.1, hostnames: [internal.local]}]` | `[]` | Shared host aliases block. |
| `generic.priorityClassName` | `generic.priorityClassName: "high-priority"` | `""` | Shared priority class for workload pods. |
| `generic.dnsPolicy` | `generic.dnsPolicy: "ClusterFirst"` | `""` | Shared DNS policy for workload pods. |
| `generic.serviceAccountName` | `generic.serviceAccountName: "deployer"` | `""` | Default service account name when workload-level field is omitted. |
| `generic.automountServiceAccountToken` | `generic.automountServiceAccountToken: false` | `n/a` | Default `automountServiceAccountToken` for workload pods when omitted per workload. |
| `generic.usePredefinedAffinity` | `generic.usePredefinedAffinity: true` | `true` | Enables generated affinity presets when explicit affinity is not set. |

### Runtime Defaults and Shared Generated Resources

| Field | Example | Default | Description |
|---|---|---|---|
| `podAffinityPreset` | `podAffinityPreset: "soft"` | `"soft"` | Preset used by generated pod affinity helper. |
| `podAntiAffinityPreset` | `podAntiAffinityPreset: "hard"` | `"soft"` | Preset used by generated pod anti-affinity helper. |
| `nodeAffinityPreset.type` | `nodeAffinityPreset.type: "hard"` | `""` | Node affinity mode (`soft`/`hard`) for generated affinity. |
| `nodeAffinityPreset.key` | `nodeAffinityPreset.key: "nodepool"` | `""` | Node label key for generated node affinity. |
| `nodeAffinityPreset.values` | `nodeAffinityPreset.values: ["apps"]` | `[]` | Node label values for generated node affinity. |
| `envs` | `envs.APP_MODE: "prod"` | `{}` | Shared key-values for generated `envs` ConfigMap. |
| `envsString` | `envsString: "LOG_LEVEL: info"` | `""` | Raw YAML merged into generated `envs` ConfigMap. |
| `secretEnvs` | `secretEnvs.API_TOKEN: "secret"` | `{}` | Shared key-values for generated `secret-envs` Secret. |
| `secretEnvsString` | `secretEnvsString: "PASSWORD: strong"` | `""` | Raw YAML merged into generated `secret-envs` Secret. |
| `imagePullSecrets` | `imagePullSecrets.registry.example.com: '{"auths":{...}}'` | `{}` | Generates `kubernetes.io/dockerconfigjson` Secrets by name. |
| `serviceAccountDefaultImagePullSecretName` | `serviceAccountDefaultImagePullSecretName: "registry.example.com"` | `""` | Optional default imagePullSecret name that generated ServiceAccounts can reference. |
| `diagnosticMode.enabled` | `diagnosticMode.enabled: true` | `false` | Enables diagnostic command/args override for all workload containers. |
| `diagnosticMode.enbled` | `diagnosticMode.enbled: true` | `false` | Backward-compatible typo alias for `diagnosticMode.enabled`. |
| `diagnosticMode.command` | `diagnosticMode.command: ["sleep"]` | `["sleep"]` | Command used in diagnostic mode. |
| `diagnosticMode.args` | `diagnosticMode.args: ["infinity"]` | `["infinity"]` | Args used in diagnostic mode. |
| `defaultImage` | `defaultImage: "nginx"` | `"nginx"` | Default image when a container omits `image`. |
| `defaultImageTag` | `defaultImageTag: "latest"` | `"latest"` | Default tag when a container omits `imageTag`. |
| `defaultImagePullPolicy` | `defaultImagePullPolicy: "IfNotPresent"` | `"IfNotPresent"` | Default pull policy when container-level field is omitted. |

### Workload Families (Top-Level Maps)

| Field | Example | Default | Description |
|---|---|---|---|
| `deploymentsGeneral` | `deploymentsGeneral.resources.requests.cpu: 100m` | `{}` | Shared defaults applied to all Deployment entries. Supports all [Common Workload Entry Fields](#common-workload-entry-fields) plus `strategy`, `progressDeadlineSeconds`. |
| `deployments` | `deployments.api.replicas: 2` | `{}` | Deployment resources keyed by suffix. |
| `daemonSetsGeneral` | `daemonSetsGeneral.resources.requests.cpu: 100m` | `{}` | Shared defaults applied to all DaemonSet entries. Supports all [Common Workload Entry Fields](#common-workload-entry-fields) plus `strategy`, `minReadySeconds`. |
| `daemonSets` | `daemonSets.node-agent.containers.agent.image: busybox` | `{}` | DaemonSet resources keyed by suffix. |
| `podsGeneral` | `podsGeneral.resources.requests.cpu: 100m` | `{}` | Shared defaults applied to all Pod entries. Supports all [Common Workload Entry Fields](#common-workload-entry-fields). |
| `pods` | `pods.toolbox.containers.toolbox.image: busybox` | `{}` | Pod resources keyed by suffix. |
| `statefulSetsGeneral` | `statefulSetsGeneral.resources.requests.cpu: 100m` | `{}` | Shared defaults applied to all StatefulSet entries. Supports all [Common Workload Entry Fields](#common-workload-entry-fields) plus `strategy`, `minReadySeconds`, `volumeClaimTemplates`. |
| `statefulSets` | `statefulSets.worker.serviceName: headless` | `{}` | StatefulSet resources keyed by suffix. |
| `jobsGeneral` | `jobsGeneral.backoffLimit: 1` | `{}` | Shared defaults applied to one-shot Jobs. Supports all [Common Workload Entry Fields](#common-workload-entry-fields) plus `parallelism`, `completions`, `activeDeadlineSeconds`, `backoffLimit`, `ttlSecondsAfterFinished`, `restartPolicy`, `commandDurationAlert`, `commandDurationAlertNamespace`. |
| `jobs` | `jobs.migrate.containers.migrate.image: busybox` | `{}` | One-shot batch jobs keyed by suffix, or one raw templated YAML string. |
| `cronJobsGeneral` | `cronJobsGeneral.timeZone: UTC` | `{}` | Shared defaults applied to all CronJobs. Supports all [Common Workload Entry Fields](#common-workload-entry-fields) and all jobsGeneral fields plus `suspend`, `timeZone`, `singleOnly`, `startingDeadlineSeconds`, `successfulJobsHistoryLimit`, `failedJobsHistoryLimit`. See [cronJobsGeneral](#cronJobsGeneral) for details. |
| `cronJobs` | `cronJobs.cleanup.schedule: "*/30 * * * *"` | `{}` | CronJobs keyed by suffix, or one raw templated YAML string. |
| `hooksGeneral` | `hooksGeneral.backoffLimit: 1` | `{}` | Shared defaults for Helm hook jobs. Supports all jobsGeneral fields plus `kind`, `weight`, `deletePolicy`. |
| `hooks` | `hooks.predeploy.kind: pre-install` | `{}` | Helm hook jobs keyed by suffix, or one raw templated YAML string. |

### Common Workload Entry Fields

These fields are shared by individual workload entries (`deployments.<name>`, `daemonSets.<name>`, `pods.<name>`, `statefulSets.<name>`, `jobs.<name>`, `cronJobs.<name>`, `hooks.<name>`) **and** their corresponding `*General` defaults objects (`deploymentsGeneral`, `cronJobsGeneral`, etc.).

Fields set on a `*General` object act as defaults for every workload in that family. A field on an individual workload entry overrides the `*General` value.

| Field | Example | Default | Description |
|---|---|---|---|
| `disabled` | `disabled: true` | `false` | Disables rendering of a specific entry. |
| `labels` / `annotations` | `labels.component: api` | `n/a` | Extra metadata on top-level resource object. |
| `podLabels` / `podAnnotations` | `podLabels.tier: backend` | `n/a` | Extra metadata for rendered pod template/pod. |
| `extraSelectorLabels` | `extraSelectorLabels.component: api` | `n/a` | Additional labels for selectors and selected pods. |
| `gitops` | `gitops.argo.syncWave: "20"` | `n/a` | Resource-level GitOps overrides (Argo/Flux/common labels/annotations). |
| `serviceAccountName` | `serviceAccountName: deployer` | `""` (via generic fallback) | ServiceAccount used by workload pods. |
| `automountServiceAccountToken` | `automountServiceAccountToken: false` | `n/a` (or generic fallback) | Controls mounting of the pod service-account token. |
| `hostAliases` | `hostAliases: [{ip: 10.0.0.1, hostnames: [db.local]}]` | `[]` (or generic fallback) | Pod host aliases. |
| `affinity` | `affinity.nodeAffinity: {...}` | `generated` when enabled | Explicit affinity; overrides generated presets. |
| `topologySpreadConstraints` | `topologySpreadConstraints: [{...}]` | `[]` (or generic fallback) | Per-workload topology spread constraints. |
| `priorityClassName` | `priorityClassName: high-priority` | `""` (or generic fallback) | Priority class assigned to pods. |
| `dnsPolicy` | `dnsPolicy: ClusterFirst` | `""` (or generic fallback) | DNS policy for pods. |
| `restartPolicy` | `restartPolicy: Never` | `n/a` | Restart policy; typically set explicitly for Pod/Job-like workloads. |
| `nodeSelector` | `nodeSelector.nodepool: apps` | `n/a` (or generic fallback) | Node selector labels for scheduling. |
| `tolerations` | `tolerations: [{key: dedicated, operator: Exists}]` | `[]` (or generic fallback) | Pod tolerations list. |
| `securityContext` | `securityContext.runAsNonRoot: true` | `n/a` | Pod-level security context. Add `mergeWithGeneric: true` to merge with `generic.podSecurityContext`. |
| `imagePullSecrets` / `extraImagePullSecrets` | `extraImagePullSecrets: [{name: regcred}]` | `[]` | Additional pull secrets for workload pod specs. |
| `terminationGracePeriodSeconds` | `terminationGracePeriodSeconds: 30` | `n/a` | Grace period before forced pod termination. |
| `initContainers` | `initContainers.prepare.image: busybox` | `n/a` | Init containers, supports both map and array forms. |
| `containers` | `containers.api.image: nginx` | `required per workload` | Main containers, supports both map and array forms. |
| `resources` | `resources.requests.cpu: 100m` | `n/a` | Default container resources for this workload. When set on a `*General` object, acts as a fallback for all containers in that family that omit their own `resources`. Overrides `generic.resources`. Allowed keys: `requests`, `limits`, `claims`. |
| `volumes` / `extraVolumes` | `volumes: [{name: app, type: configMap}]` | `[]` | Typed and raw volumes for workload pods. |
| `usePredefinedAffinity` | `usePredefinedAffinity: false` | `true` (via generic) | Enables/disables generated affinity presets for this workload. |

### Container Entry Fields

These fields apply to each entry in `containers` and `initContainers`.

| Field | Example | Default | Description |
|---|---|---|---|
| `name` | `name: api` | deterministic fallback | Explicit container name. |
| `image` / `imageTag` | `image: nginx`, `imageTag: "1.27.5"` | `defaultImage` / `defaultImageTag` | Image and tag for container. |
| `imagePullPolicy` | `imagePullPolicy: IfNotPresent` | `defaultImagePullPolicy` | Pull policy override for container. |
| `command` / `args` | `command: ["sh","-c"]`, `args: ["sleep 3600"]` | `n/a` | Command and args (also overridden by diagnostic mode). |
| `env`, `envFrom` | `env: [{name: APP_MODE, value: prod}]` | `n/a` | Native env/envFrom blocks. |
| `envConfigmaps`, `envSecrets` | `envConfigmaps: [envs]` | `n/a` | Includes all keys from named ConfigMaps/Secrets. |
| `envsFromConfigmap`, `envsFromSecret` | `envsFromConfigmap.app-settings: [APP_MODE]` | `n/a` | Includes selected keys from named ConfigMaps/Secrets. |
| `ports` | `ports: [{name: http, containerPort: 8080}]` | `n/a` | Exposed container ports. |
| `lifecycle` | `lifecycle.preStop.exec.command: ["sleep","5"]` | `n/a` | Lifecycle hook settings. |
| `startupProbe`, `livenessProbe`, `readinessProbe` | `startupProbe.httpGet.path: /healthz` | `n/a` | Probe configuration blocks. |
| `resources` | `resources.requests.cpu: 100m` | `n/a` | CPU/memory requests and limits. Resolved with three-level fallback: container `resources` → workload `*General.resources` → `generic.resources`. Allowed keys: `requests`, `limits`, `claims`. |
| `securityContext` | `securityContext.readOnlyRootFilesystem: true` | `n/a` | Container-level security context. Add `mergeWithGeneric: true` to merge with `generic.containerSecurityContext`. |
| `volumeMounts`, `extraVolumeMounts` | `volumeMounts: [{name: app, mountPath: /etc/app}]` | `[]` | Volume mounts merged with shared/global mounts. |
| `stdin` | `stdin: true` | `false` | Whether this container should allocate a buffer for stdin in the container runtime. |
| `tty` | `tty: true` | `false` | Whether this container should allocate a TTY for itself, also requires `stdin` to be true. |

### Workload-Specific Fields

These tables list only fields that are unique to a workload family. Shared knobs still belong to `Common Workload Entry Fields` and `Container Entry Fields`.

#### Deployments

| Field | Example | Default | Description |
|---|---|---|---|
| `deployments.<name>.replicas` | `replicas: 3` | `1` | Number of desired deployment replicas. |
| `deployments.<name>.strategy` | `strategy.rollingUpdate.maxUnavailable: 1` | `n/a` | Deployment strategy block. |
| `deployments.<name>.progressDeadlineSeconds` | `progressDeadlineSeconds: 600` | `600` | Rollout progress deadline in seconds. |

#### DaemonSets

| Field | Example | Default | Description |
|---|---|---|---|
| `daemonSets.<name>.strategy` | `strategy.type: RollingUpdate` | `n/a` | DaemonSet update strategy. |
| `daemonSets.<name>.minReadySeconds` | `minReadySeconds: 10` | `n/a` | Minimum seconds for pod readiness before considered available. |

#### Pods

| Field | Example | Default | Description |
|---|---|---|---|
| `pods.<name>` | `pods.toolbox.containers.toolbox.image: busybox` | `n/a` | Pod entries do not add resource-specific fields beyond `Common Workload Entry Fields` and `Container Entry Fields`. |

#### StatefulSets

| Field | Example | Default | Description |
|---|---|---|---|
| `statefulSets.<name>.replicas` | `replicas: 2` | `1` | Number of desired StatefulSet replicas. |
| `statefulSets.<name>.strategy` | `strategy.type: RollingUpdate` | `n/a` | StatefulSet update strategy. |
| `statefulSets.<name>.serviceName` | `serviceName: headless` | `<resource key>` | Governing service name used by StatefulSet. |
| `statefulSets.<name>.minReadySeconds` | `minReadySeconds: 10` | `n/a` | Minimum ready time per pod. |
| `statefulSets.<name>.volumeClaimTemplates` | `volumeClaimTemplates: [{...}]` | `n/a` | PVC templates for StatefulSet pods. |

#### Jobs

| Field | Example | Default | Description |
|---|---|---|---|
| `jobs.<name>.parallelism` | `parallelism: 1` | `n/a` | Maximum parallel pods for the job. |
| `jobs.<name>.completions` | `completions: 1` | `n/a` | Number of successful completions required. |
| `jobs.<name>.activeDeadlineSeconds` | `activeDeadlineSeconds: 600` | `n/a` | Job timeout in seconds. |
| `jobs.<name>.backoffLimit` | `backoffLimit: 1` | `n/a` | Retry limit for failed pods. |
| `jobs.<name>.ttlSecondsAfterFinished` | `ttlSecondsAfterFinished: 3600` | `n/a` | Cleanup TTL after job completion. |
| `jobs.<name>.restartPolicy` | `restartPolicy: Never` | `"Never"` | Pod restart policy for job pods. |
| `jobs.<name>.commandDurationAlert` | `commandDurationAlert: "900"` | `n/a` | Optional long-running command alert threshold. |
| `jobs.<name>.commandDurationAlertNamespace` | `commandDurationAlertNamespace: monitoring` | release namespace | Optional namespace override for generated alert rule. |

#### CronJobs

| Field | Example | Default | Description |
|---|---|---|---|
| `cronJobs.<name>.schedule` | `schedule: "*/15 * * * *"` | `required` | Cron schedule expression. |
| `cronJobs.<name>.suspend` | `suspend: false` | `false` | Pauses or resumes cron execution. |
| `cronJobs.<name>.timeZone` | `timeZone: UTC` | `n/a` | Optional cron timezone. |
| `cronJobs.<name>.singleOnly` | `singleOnly: true` | `false` | If true, sets `concurrencyPolicy: Forbid`. |
| `cronJobs.<name>.startingDeadlineSeconds` | `startingDeadlineSeconds: 120` | `n/a` | Late start deadline for missed runs. |
| `cronJobs.<name>.successfulJobsHistoryLimit` | `successfulJobsHistoryLimit: 3` | `n/a` | Number of successful jobs to retain. |
| `cronJobs.<name>.failedJobsHistoryLimit` | `failedJobsHistoryLimit: 1` | `n/a` | Number of failed jobs to retain. |

#### Hooks

| Field | Example | Default | Description |
|---|---|---|---|
| `hooks.<name>.kind` | `kind: "pre-install,pre-upgrade"` | `"pre-install,pre-upgrade"` | Hook phase list for Helm execution. |
| `hooks.<name>.weight` | `weight: "5"` | `"5"` | Hook ordering weight. |
| `hooks.<name>.deletePolicy` | `deletePolicy: "before-hook-creation"` | `"before-hook-creation"` | Hook resource deletion policy. |

### Workload General Fields

Each `*General` object accepts all fields from [Common Workload Entry Fields](#common-workload-entry-fields) (including `resources`, `nodeSelector`, `tolerations`, `podLabels`, `imagePullSecrets`, etc.) as defaults for every workload in that family. In addition, some `*General` objects accept the extra family-specific fields listed below.

#### deploymentsGeneral

All [Common Workload Entry Fields](#common-workload-entry-fields) plus:

| Field | Example | Default | Description |
|---|---|---|---|
| `deploymentsGeneral.strategy` | `strategy.type: RollingUpdate` | `n/a` | Default deployment strategy for all Deployments. |
| `deploymentsGeneral.progressDeadlineSeconds` | `progressDeadlineSeconds: 600` | `n/a` | Default rollout progress deadline in seconds. |

#### daemonSetsGeneral

All [Common Workload Entry Fields](#common-workload-entry-fields) plus:

| Field | Example | Default | Description |
|---|---|---|---|
| `daemonSetsGeneral.strategy` | `strategy.type: RollingUpdate` | `n/a` | Default update strategy for all DaemonSets. |
| `daemonSetsGeneral.minReadySeconds` | `minReadySeconds: 10` | `n/a` | Default minimum ready seconds before pod is considered available. |

#### podsGeneral

Accepts all [Common Workload Entry Fields](#common-workload-entry-fields). No additional family-specific fields.

#### statefulSetsGeneral

All [Common Workload Entry Fields](#common-workload-entry-fields) plus:

| Field | Example | Default | Description |
|---|---|---|---|
| `statefulSetsGeneral.strategy` | `strategy.type: RollingUpdate` | `n/a` | Default update strategy for all StatefulSets. |
| `statefulSetsGeneral.minReadySeconds` | `minReadySeconds: 10` | `n/a` | Default minimum ready seconds per pod. |
| `statefulSetsGeneral.volumeClaimTemplates` | `volumeClaimTemplates: [{...}]` | `n/a` | Default PVC templates applied to all StatefulSets. |

#### jobsGeneral

All [Common Workload Entry Fields](#common-workload-entry-fields) plus:

| Field | Example | Default | Description |
|---|---|---|---|
| `jobsGeneral.parallelism` | `parallelism: 2` | `n/a` | Default maximum parallel pods for Jobs. |
| `jobsGeneral.completions` | `completions: 1` | `n/a` | Default number of successful completions required. |
| `jobsGeneral.activeDeadlineSeconds` | `activeDeadlineSeconds: 600` | `n/a` | Default job timeout in seconds. |
| `jobsGeneral.backoffLimit` | `backoffLimit: 1` | `n/a` | Default retry limit for failed pods. |
| `jobsGeneral.ttlSecondsAfterFinished` | `ttlSecondsAfterFinished: 3600` | `n/a` | Default cleanup TTL after job completion. |
| `jobsGeneral.restartPolicy` | `restartPolicy: Never` | `"Never"` | Default pod restart policy for Job pods. |
| `jobsGeneral.commandDurationAlert` | `commandDurationAlert: "900"` | `n/a` | Default long-running command alert threshold (seconds) for all Jobs. |
| `jobsGeneral.commandDurationAlertNamespace` | `commandDurationAlertNamespace: monitoring` | release namespace | Default namespace for generated PrometheusRule alert. |

#### cronJobsGeneral

All [Common Workload Entry Fields](#common-workload-entry-fields) and all [jobsGeneral](#jobsgeneral) fields plus:

| Field | Example | Default | Description |
|---|---|---|---|
| `cronJobsGeneral.suspend` | `suspend: false` | `false` | Default suspend flag for all CronJobs. |
| `cronJobsGeneral.timeZone` | `timeZone: UTC` | `n/a` | Default cron timezone for all CronJobs. |
| `cronJobsGeneral.singleOnly` | `singleOnly: true` | `false` | If true, sets `concurrencyPolicy: Forbid` on all CronJobs by default. |
| `cronJobsGeneral.startingDeadlineSeconds` | `startingDeadlineSeconds: 120` | `n/a` | Default late-start deadline for missed runs. |
| `cronJobsGeneral.successfulJobsHistoryLimit` | `successfulJobsHistoryLimit: 3` | `n/a` | Default number of successful job runs to retain. |
| `cronJobsGeneral.failedJobsHistoryLimit` | `failedJobsHistoryLimit: 1` | `n/a` | Default number of failed job runs to retain. |

Example — set default resources and timezone for all CronJobs:

```yaml
cronJobsGeneral:
  timeZone: UTC
  restartPolicy: Never
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
    limits:
      cpu: 200m
      memory: 256Mi
```

A container with its own `resources` block overrides `cronJobsGeneral.resources`. If neither the container nor `cronJobsGeneral` sets resources, `generic.resources` is used as the last resort.

#### hooksGeneral

All [Common Workload Entry Fields](#common-workload-entry-fields) and all [jobsGeneral](#jobsgeneral) fields plus:

| Field | Example | Default | Description |
|---|---|---|---|
| `hooksGeneral.kind` | `kind: "pre-install,pre-upgrade"` | `"pre-install,pre-upgrade"` | Default hook phase list for all hook jobs. |
| `hooksGeneral.weight` | `weight: "5"` | `"5"` | Default hook ordering weight. |
| `hooksGeneral.deletePolicy` | `deletePolicy: "before-hook-creation"` | `"before-hook-creation"` | Default hook resource deletion policy. |

### Networking Resources

#### Services

| Field | Example | Default | Description |
|---|---|---|---|
| `servicesGeneral` | `servicesGeneral.labels.traffic-scope: "shared"` | `{}` | Shared metadata defaults applied to rendered Service resources, including generated governing Services. |
| `services` | `services.api.ports: [{port: 8080, targetPort: http}]` | `{}` | Service objects keyed by name. |
| `services.<name>.disabled` | `disabled: true` | `false` | Disables rendering of a service entry. |
| `services.<name>.labels` / `annotations` | `labels.tier: backend` | `{}` | Extra metadata for the service resource. |
| `services.<name>.gitops` | `gitops.argo.syncWave: "5"` | `{}` | Resource-level GitOps metadata overlay. |
| `services.<name>.clusterIP` | `clusterIP: None` | `n/a` | ClusterIP value (including headless service). |
| `services.<name>.type` | `type: LoadBalancer` | `n/a` | Service type. |
| `services.<name>.loadBalancerIP` | `loadBalancerIP: 10.0.0.10` | `n/a` | Static LB IP for LoadBalancer services. |
| `services.<name>.loadBalancerClass` | `loadBalancerClass: internal` | `n/a` | Optional LoadBalancer class. |
| `services.<name>.allocateLoadBalancerNodePorts` | `allocateLoadBalancerNodePorts: false` | `n/a` | Enables/disables node port allocation for LB services. |
| `services.<name>.externalTrafficPolicy` | `externalTrafficPolicy: Local` | `Cluster` for LB/NodePort | Traffic policy for external traffic. |
| `services.<name>.loadBalancerSourceRanges` | `loadBalancerSourceRanges: ["10.0.0.0/8"]` | `n/a` | Allowed CIDRs for LoadBalancer traffic. |
| `services.<name>.externalIPs` | `externalIPs: ["192.168.10.10"]` | `n/a` | External IPs for service exposure. |
| `services.<name>.healthCheckNodePort` | `healthCheckNodePort: 31000` | `n/a` | Health check node port for NodePort service with local policy. |
| `services.<name>.ports` | `ports: [{name: http, port: 8080, targetPort: http}]` | `required` | Service ports list. |
| `services.<name>.extraSelectorLabels` | `extraSelectorLabels.component: api` | `{}` | Extra selector labels appended to default selector. |

#### Ingresses

| Field | Example | Default | Description |
|---|---|---|---|
| `ingresses` | `ingresses.app.example.com.hosts: [...]` | `{}` | Ingress resources keyed by host/logical name. |
| `ingresses.<name>.disabled` | `disabled: true` | `false` | Disables rendering of an ingress entry. |
| `ingresses.<name>.name` | `name: public` | key/host | Optional explicit ingress resource name suffix. |
| `ingresses.<name>.labels` / `annotations` | `annotations.nginx.ingress.kubernetes.io/rewrite-target: "/"` | `{}` | Extra metadata for ingress resource. |
| `ingresses.<name>.gitops` | `gitops.argo.syncOptions: ["ServerSideApply=true"]` | `{}` | Resource-level GitOps metadata overlay. |
| `ingresses.<name>.ingressClassName` | `ingressClassName: nginx` | `n/a` | Ingress class name. |
| `ingresses.<name>.hosts` | `hosts: [{hostname: app.example.com, paths: [...]}]` | `required` | Hosts and path mappings. |
| `ingresses.<name>.certManager` | `certManager.issuerName: letsencrypt` | `n/a` | Cert-manager integration block. |
| `ingresses.<name>.tlsName` | `tlsName: app-tls` | auto `<name>-tls` | Optional TLS secret name override. |
| `ingresses.<name>.extraTls` | `extraTls: [{hosts:[...], secretName: tls2}]` | `n/a` | Additional TLS entries. |

#### NetworkPolicies

| Field | Example | Default | Description |
|---|---|---|---|
| `networkPolicies` | `networkPolicies.allow-api.spec: {...}` | `{}` | Network policy resources keyed by suffix. |
| `networkPolicies.<name>.disabled` | `disabled: true` | `false` | Disables rendering of a network policy entry. |
| `networkPolicies.<name>.labels` / `annotations` | `labels.policy: baseline` | `{}` | Extra metadata for network policy resource. |
| `networkPolicies.<name>.gitops` | `gitops.commonAnnotations.team: platform` | `{}` | Resource-level GitOps metadata overlay. |
| `networkPolicies.<name>.spec` | `spec.podSelector.matchLabels.app: api` | `n/a` | Full spec override. |
| `networkPolicies.<name>.podSelector` | `podSelector.matchLabels.component: api` | `{}` | Shortcut pod selector when `spec` is not provided. |
| `networkPolicies.<name>.policyTypes` | `policyTypes: ["Ingress"]` | `n/a` | List of policy types. |
| `networkPolicies.<name>.ingress` / `egress` | `ingress: [{from:[...]}]` | `n/a` | Ingress/egress rules when `spec` is not provided. |

### Config and Secret Resources

| Field | Example | Default | Description |
|---|---|---|---|
| `configMaps` | `configMaps.app-settings.data.APP_MODE: prod` | `{}` | ConfigMap resources keyed by suffix. |
| `configMaps.<name>.disabled` | `disabled: true` | `false` | Disables rendering of a ConfigMap entry. |
| `configMaps.<name>.labels` / `annotations` | `labels.config: app` | `{}` | Extra metadata for ConfigMap resource. |
| `configMaps.<name>.gitops` | `gitops.flux.enabled: true` | `{}` | Resource-level GitOps metadata overlay. |
| `configMaps.<name>.data` | `data.LOG_LEVEL: info` | `n/a` | Plain string data entries. |
| `configMaps.<name>.binaryData` | `binaryData.cert.pem: LS0t...` | `n/a` | Binary/base64 data entries. |
| `secrets` | `secrets.app-secret.data.password: supersecret` | `{}` | Secret resources keyed by suffix. |
| `secrets.<name>.disabled` | `disabled: true` | `false` | Disables rendering of a Secret entry. |
| `secrets.<name>.labels` / `annotations` | `labels.secret: app` | `{}` | Extra metadata for Secret resource. |
| `secrets.<name>.gitops` | `gitops.argo.enabled: true` | `{}` | Resource-level GitOps metadata overlay. |
| `secrets.<name>.type` | `type: Opaque` | `"Opaque"` | Secret type. |
| `secrets.<name>.data` | `data.apiToken: mytoken` | `n/a` | Secret data entries (rendered through helper). |
| `sealedSecrets` | `sealedSecrets.app.encryptedData.password: Ag...` | `{}` | SealedSecret resources keyed by suffix. |
| `sealedSecrets.<name>.disabled` | `disabled: true` | `false` | Disables rendering of a SealedSecret entry. |
| `sealedSecrets.<name>.labels` / `annotations` | `labels.secret: sealed` | `{}` | Extra metadata for SealedSecret resource. |
| `sealedSecrets.<name>.gitops` | `gitops.commonLabels.team: secops` | `{}` | Resource-level GitOps metadata overlay. |
| `sealedSecrets.<name>.encryptedData` | `encryptedData.password: Ag...` | `n/a` | Encrypted key-values for SealedSecret payload. |

### RBAC, Storage, and Observability

| Field | Example | Default | Description |
|---|---|---|---|
| `serviceAccountGeneral` | `serviceAccountGeneral.labels.team: platform` | `{}` | Shared defaults for all service accounts and generated bindings. |
| `serviceAccountGeneral.imagePullSecrets` | `includePlatformDefault: true` | `{includePlatformDefault: false, additional: []}` | Shared imagePullSecrets defaults for generated ServiceAccounts. |
| `serviceAccount` | `serviceAccount.deployer.role.name: deployer-role` | `{}` | Service accounts keyed by suffix, with optional Role/ClusterRole settings. |
| `serviceAccount.<name>.disabled` | `disabled: true` | `false` | Disables rendering of a service account entry. |
| `serviceAccount.<name>.labels` / `annotations` | `labels.app: worker` | `{}` | Extra metadata for ServiceAccount resource. |
| `serviceAccount.<name>.gitops` | `gitops.argo.syncWave: "1"` | `{}` | Resource-level GitOps metadata overlay. |
| `serviceAccount.<name>.imagePullSecrets` | `additional: [{name: regcred}]` | `n/a` | Per-ServiceAccount imagePullSecrets override; supports config object or direct list shorthand. |
| `serviceAccount.<name>.role` | `role.rules: [{apiGroups:[""], resources:["pods"], verbs:["get"]}]` | `n/a` | Namespaced role configuration. |
| `serviceAccount.<name>.clusterRole` | `clusterRole.name: view` | `n/a` | Cluster-level role configuration. |
| `pvs` | `pvs.shared.spec.capacity.storage: 10Gi` | `{}` | PersistentVolume resources keyed by suffix. |
| `pvs.<name>.disabled` | `disabled: true` | `false` | Disables rendering of a PV entry. |
| `pvs.<name>.labels` / `annotations` | `labels.storage: fast` | `{}` | Extra metadata for PV resource. |
| `pvs.<name>.gitops` | `gitops.flux.enabled: true` | `{}` | Resource-level GitOps metadata overlay. |
| `pvs.<name>.spec` | `spec.storageClassName: standard` | `n/a` | Full PV spec override. |
| `pvs.<name>.size` | `size: 10Gi` | `"1Gi"` | Storage size when full `spec` is not provided. |
| `pvs.<name>.accessModes` | `accessModes: ["ReadWriteOnce"]` | `n/a` | Access modes when full `spec` is not provided. |
| `pvs.<name>.volumeMode` | `volumeMode: Filesystem` | `n/a` | Optional PV volume mode. |
| `pvs.<name>.storageClassName` | `storageClassName: standard` | `n/a` | Storage class for PV. |
| `pvs.<name>.persistentVolumeReclaimPolicy` | `persistentVolumeReclaimPolicy: Retain` | `n/a` | Reclaim policy for released volumes. |
| `pvs.<name>.mountOptions` | `mountOptions: ["nfsvers=4.1"]` | `n/a` | Mount options list. |
| `pvs.<name>.claimRef` | `claimRef.name: data-pvc` | `n/a` | Optional claim reference for pre-binding. |
| `pvs.<name>.nodeAffinity` | `nodeAffinity.required.nodeSelectorTerms: [...]` | `n/a` | Node affinity constraints for local/static volumes. |
| `pvs.<name>.hostPath` / `local` / `nfs` / `csi` | `nfs.server: 10.0.0.10` | `n/a` | Storage backend blocks used when `spec` is not passed as full object. |
| `pvcs` | `pvcs.data.size: 20Gi` | `{}` | PVC resources keyed by suffix. |
| `pvcs.<name>.disabled` | `disabled: true` | `false` | Disables rendering of a PVC entry. |
| `pvcs.<name>.labels` / `annotations` | `labels.storage: app` | `{}` | Extra metadata for PVC resource. |
| `pvcs.<name>.gitops` | `gitops.commonLabels.team: platform` | `{}` | Resource-level GitOps metadata overlay. |
| `pvcs.<name>.accessModes` | `accessModes: ["ReadWriteOnce"]` | `required` | PVC access modes list. |
| `pvcs.<name>.volumeMode` | `volumeMode: Filesystem` | `n/a` | Optional PVC volume mode. |
| `pvcs.<name>.size` | `size: 20Gi` | `"1Gi"` | Requested storage size. |
| `pvcs.<name>.volumeName` | `volumeName: my-pv` | `n/a` | Optional pre-bound PV name. |
| `pvcs.<name>.storageClassName` | `storageClassName: standard` | `n/a` | Optional storage class override. |
| `pvcs.<name>.selector` | `selector.matchLabels.tier: fast` | `n/a` | Label selector for binding to matching PVs. |
| `pdbs` | `pdbs.api.minAvailable: 1` | `{}` | PDB resources keyed by suffix. |
| `pdbs.<name>.disabled` | `disabled: true` | `false` | Disables rendering of a PDB entry. |
| `pdbs.<name>.labels` / `annotations` | `labels.app: api` | `{}` | Extra metadata for PDB resource. |
| `pdbs.<name>.gitops` | `gitops.argo.compareOptions: ["IgnoreExtraneous"]` | `{}` | Resource-level GitOps metadata overlay. |
| `pdbs.<name>.minAvailable` / `maxUnavailable` | `minAvailable: 1` | `n/a` | Availability policy for disruptions. |
| `pdbs.<name>.extraSelectorLabels` | `extraSelectorLabels.component: api` | `{}` | Additional selector labels for PDB target pods. |
| `hpas` | `hpas.api.scaleTargetRef.name: api` | `{}` | HPA resources keyed by suffix. |
| `hpas.<name>.disabled` | `disabled: true` | `false` | Disables rendering of an HPA entry. |
| `hpas.<name>.apiVersion` | `apiVersion: autoscaling/v2` | `"autoscaling/v2"` | API version used for HPA resource. |
| `hpas.<name>.labels` / `annotations` | `labels.autoscaling: enabled` | `{}` | Extra metadata for HPA resource. |
| `hpas.<name>.gitops` | `gitops.flux.enabled: true` | `{}` | Resource-level GitOps metadata overlay. |
| `hpas.<name>.scaleTargetRef` | `scaleTargetRef: {name: api, kind: Deployment}` | `required` | Target object for scaling. |
| `hpas.<name>.minReplicas` / `maxReplicas` | `minReplicas: 2`, `maxReplicas: 6` | `2` / `3` | Replica bounds for autoscaling. |
| `hpas.<name>.targetCPU` / `targetMemory` | `targetCPU: 70` | `n/a` | Convenience CPU/memory utilization targets. |
| `hpas.<name>.metrics` | `metrics: [{type: Pods, ...}]` | `n/a` | Custom metrics list; can be used with or without shortcuts. |

### Dependency Toggle Fields

| Field | Example | Default | Description |
|---|---|---|---|
| `nuc-common.enabled` | `nuc-common.enabled: false` | `false` | Compatibility toggle retained for legacy umbrella behavior. |
| `nuc-traefik.enabled` | `nuc-traefik.enabled: true` | `false` | Enables `nuc-traefik` subchart resources. |
| `nuc-certificates.enabled` | `nuc-certificates.enabled: true` | `false` | Enables `nuc-certificates` subchart resources. |
| `nuc-istio.enabled` | `nuc-istio.enabled: true` | `false` | Enables `nuc-istio` subchart resources. |
| `nuc-knative.enabled` | `nuc-knative.enabled: true` | `false` | Enables `nuc-knative` subchart resources. |
| `nuc-kserve.enabled` | `nuc-kserve.enabled: true` | `false` | Enables `nuc-kserve` subchart resources. |
| `nuc-kube-prometheus-stack.enabled` | `nuc-kube-prometheus-stack.enabled: true` | `false` | Enables monitoring subchart resources. |
| `nuc-native-gateway.enabled` | `nuc-native-gateway.enabled: true` | `false` | Enables native Gateway API subchart resources. |
| `nuc-victoria-metrics.enabled` | `nuc-victoria-metrics.enabled: true` | `false` | Enables Victoria Metrics subchart resources. |
| `nuc-vault-secret-operator.enabled` | `nuc-vault-secret-operator.enabled: true` | `false` | Enables Vault secret operator subchart resources. |
| `nuc-argocd.enabled` | `nuc-argocd.enabled: true` | `false` | Enables Argo CD subchart resources. |
| `nuc-fluxcd.enabled` | `nuc-fluxcd.enabled: true` | `false` | Enables Flux CD subchart resources. |
| `nuc-keda.enabled` | `nuc-keda.enabled: true` | `false` | Enables KEDA subchart resources. |

### Reusable Schema Contracts (Exact Definitions)

These reusable definitions are referenced across multiple value blocks and match `values.schema.json` field-for-field.

| Definition | Used By | Fields |
|---|---|---|
| `resourceGitopsConfig` | `gitops` in most resources (`services`, `ingresses`, workload entries, storage, RBAC, observability) | `commonLabels`, `commonAnnotations`, `argo.enabled`, `argo.syncWave`, `argo.syncOptions`, `argo.compareOptions`, `flux.enabled`, `flux.labels`, `flux.annotations` |
| `baseWorkload` | `deployments.<name>`, `daemonSets.<name>`, `pods.<name>`, `statefulSets.<name>`, `jobs.<name>`, `cronJobs.<name>`, `hooks.<name>` | `disabled`, `labels`, `annotations`, `podLabels`, `podAnnotations`, `extraSelectorLabels`, `gitops`, `serviceAccountName`, `automountServiceAccountToken`, `hostAliases`, `affinity`, `topologySpreadConstraints`, `priorityClassName`, `dnsPolicy`, `restartPolicy`, `nodeSelector`, `tolerations`, `securityContext`, `imagePullSecrets`, `extraImagePullSecrets`, `terminationGracePeriodSeconds`, `resources`, `initContainers`, `containers`, `volumes`, `extraVolumes`, `usePredefinedAffinity` |
| `baseWorkloadGeneral` | `deploymentsGeneral`, `daemonSetsGeneral`, `podsGeneral`, `statefulSetsGeneral`, `jobsGeneral`, `cronJobsGeneral`, `hooksGeneral` | Same fields as `baseWorkload`. The `resources` field on a `*General` object sets the default container resources for all workloads in that family, overriding `generic.resources` but overridden by container-level `resources`. |
| `workloadContainer` | each item in `containers` and `initContainers` | `name`, `image`, `imageTag`, `imagePullPolicy`, `command`, `args`, `env`, `envFrom`, `envConfigmaps`, `envSecrets`, `envsFromConfigmap`, `envsFromSecret`, `ports`, `lifecycle`, `startupProbe`, `livenessProbe`, `readinessProbe`, `resources`, `securityContext`, `volumeMounts`, `extraVolumeMounts`, `stdin`, `tty` |
| `workloadContainerListOrMap` | `containers`, `initContainers` | `array` of `workloadContainer` or `map` of `<containerKey> -> workloadContainer`. |
| `typedVolume` / `typedVolumeList` | `*.volumes`, `generic.volumes` | `name`, `type`, `originalName`, `defaultMode`, `items`, `sources`, `sizeLimit`, `medium`; list is `array` of these objects. |

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
- Generated `ConfigMap` and `Secret` resources keep Helm hook annotations by default for backward compatibility; set `generic.hookAnnotations: null` to disable them cleanly.
- Previous umbrella-chart toggles such as `nuc-common.enabled` remain in the values contract for compatibility.
- `diagnosticMode.enbled` is still accepted for backward compatibility, but `diagnosticMode.enabled` is the supported field.

## Roadmap

Following features are already in backlog for our development team and will be done soon:

* Add a catalog of ready-to-use examples: `Deployment`, `StatefulSet`, `CronJob`, `Job`, `Ingress`, `PVC`, `HPA`, `PDB`, and `extraDeploy`.
* Add examples for enabling dependency subcharts: `nuc-traefik`, `nuc-istio`, `nuc-native-gateway`, `nuc-keda`, and `nuc-kube-prometheus-stack`.
* Introduce a compatibility matrix and CI validation for Kubernetes, OpenShift, and Helm across multiple supported versions.
* Extend e2e and smoke scenarios with dedicated profiles for CRD-based resources and dependency subcharts.
* Tighten `values.schema.json`: add more resource-specific validation, reduce implicit contracts, and define explicit deprecation paths.
* Prepare a migration guide for legacy values and aliases: list-based contract, old umbrella toggles, and deprecated fields.
* Add a set of production recommendations: naming, selectors, probes, `securityContext`, affinity, `PDB`, `HPA`, and rollout-safe defaults.
* Improve the documentation for `generic.*` with practical scenarios for shared variables, `tpl`, labels/annotations, volumes, and capability overrides.
* Add release automation: automatic validation of README, schema, lint, unit/smoke/e2e checks, and chart publishing to the registry.

## Feedback

For support and feedback please contact me:

* telegram: @Peter_Rukin

For news and discussions subscribe the channels:
- telegram community (news): [@nxs_universal_chart](https://t.me/nxs_universal_chart)
- telegram community (chat): [@nxs_universal_chart_chat](https://t.me/nxs_universal_chart_chat)

## License

nxs-universal-chart is released under the [Apache License 2.0](LICENSE).
