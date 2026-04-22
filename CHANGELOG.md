# Changelog

## [3.0.13] - April 22, 2026
### Added
* added new pre-release subchart `NUC FluxCD` to dependency list
* added new pre-release subchart `NUC External Secrets` to dependency list
* added new pre-release subchart `NUC MongoDB Percona Operator` to dependency list
* added new pre-release subchart `NUC Envoy Gateway` to dependency list
* added GitHub chart-testing and CI configuration under `.github/`, including lint, security, smoke, unit, and e2e workflows
* added contributor templates in `docs/`:
  * `docs/PULL_REQUEST_TEMPLATE.md`
  * `docs/ISSUE_TEMPLATE/bug_report.yml`
  * `docs/ISSUE_TEMPLATE/feature_request.yml`

## [3.0.12] - April 21, 2026
### Added
* added shared `generic.nodeSelector` defaults for workloads
* added shared `generic.resources` defaults for workload containers
* added `servicesGeneral` for common labels and annotations on rendered `Service` resources, including generated governing Services
* added `generic.podSecurityContext` and `generic.containerSecurityContext` defaults with optional `mergeWithGeneric: true` override semantics
* added `generic.automountServiceAccountToken` and workload-level `automountServiceAccountToken`
* added typed `projected` volumes via `volumes[].type: projected`
* added generated `ServiceAccount.imagePullSecrets` support via `serviceAccountDefaultImagePullSecretName`, `serviceAccountGeneral.imagePullSecrets`, and per-ServiceAccount overrides
* added a curated `samples/` catalog with smoke coverage for the main deployment scenarios

### Changed
* updated the local compatibility helpers and `nuc-common` helper library to support the new pod/service account/security context behavior consistently
* expanded `values.yaml`, `values.schema.json`, `values.yaml.example`, and README documentation for the new shared workload, Service, volume, and ServiceAccount options

### Testing
* extended unit and smoke coverage for:
  * `servicesGeneral`
  * generic pod/container `securityContext`
  * `automountServiceAccountToken`
  * projected typed volumes
  * generated `ServiceAccount.imagePullSecrets`

## [3.0.11] - April 20, 2026
### Fixed
* fixed error: configmaps and Secrets annotated by default hooks cannot be uninstalled

## [3.0.10] - April 20, 2026
### Changed
* `autoRolloutChecksums` now generates checksum annotations only for ConfigMaps, Secrets, and SealedSecrets that are actually referenced by a given workload (via `envConfigmaps`, `envSecrets`, `envsFromConfigmap`, `envsFromSecret`, or typed `volumes`), instead of checksumming every resource in the release. Global `envs`/`secretEnvs` checksums remain on all workloads.

### Added
* added new pre-release subchart `NUC CloudNativePG` to dependency list
* added new pre-release subchart `NUC MySQL Percona Operator` to dependency list
* added new pre-release subchart `NUC ELK` to dependency list
* added new pre-release subchart `NUC RabbitMQ` to dependency list
* added new pre-release subchart `NUC Clickhouse` to dependency list

## [3.0.8] - April 13, 2026
### Added
* added `stdin` and `tty` support for containers and initContainers

## [3.0.7] - April 13, 2026
### Added
* Add new templates for nuc-istio: AuthorizationPolicy, DestinationRule, EnvoyFilter, Gateway, PeerAuthentication, ProxyConfig, RequestAuthentication, ServiceEntry, Sidecar, Telemetry, VirtualService, WasmPlugin, WorkloadEntry, WorkloadGroup.
* Add new templates for nuc-vault-secret-operator: HCPAuth, HCPVaultSecretsApp, SecretTransformation, VaultAuthGlobal, VaultConnection, VaultDynamicSecret, VaultPKISecret.

### Fixed
* Fix error with multi env.
* Add new unit tests for this case.

## [3.0.2] - March 30, 2026

### Breaking Changes
* project migrated to the new `nuc-*` dependency model with OCI-hosted subcharts
* several previously embedded integration templates were removed from the root chart and are now expected to come from dedicated dependency subcharts
* values are now formally validated by `values.schema.json`
* the old list-based top-level values contract is no longer considered valid; object-based resource maps are now the supported format

### Added
* added a formal `values.schema.json` describing the chart values contract
* added `values.yaml.example` covering all main template families
* added a `Makefile` for local dependency management, linting, docs generation, smoke checks, and e2e execution
* added helper scripts:
  * `scripts/helm-deps.sh`
  * `scripts/helm-docs.sh`
* added project documentation:
  * `docs/AGENTS.md`
  * `docs/CONTRIBUTING.md`
  * `docs/DEPENDENCY.md`
  * `docs/TESTS.MD`
  * `docs/README.md.gotmpl`
  * `docs/CODE_OF_CONDUCT.md`
  * `docs/SECURITY.md`
* added a compatibility layer in `templates/_compat.tpl` to override helper behavior until the published `nuc-common` dependency catches up
* added first-class templates for:
  * `Pod`
  * `DaemonSet`
  * `NetworkPolicy`
  * `PersistentVolume`
* added unit, smoke, and end-to-end test suites

### Changed
* templates reorganized from a flat layout into domain-based directories:
  * `templates/workloads/`
  * `templates/batch/`
  * `templates/networking/`
  * `templates/security/`
  * `templates/storage/`
  * `templates/observability/`
  * `templates/rbac/`
  * `templates/misc/`
* root README fully rewritten and now generated via `helm-docs`
* `values.yaml` reworked into a documented, family-based values contract
* added `workloadMode` to limit rendering to selected workload families:
  * `auto`
  * `deployment`
  * `daemonset`
  * `pod`
  * `statefulset`
  * `batch`
  * `job`
  * `cronjob`
  * `hook`
  * `none`
* introduced a centralized GitOps metadata layer:
  * `gitops.commonLabels`
  * `gitops.commonAnnotations`
  * `gitops.argo.*`
  * `gitops.flux.*`
  * resource-level `gitops` overrides
* values/schema model unified around reusable definitions:
  * `baseWorkload`
  * `baseWorkloadGeneral`
  * specialized reusable definitions for workload, batch, and hook families
* top-level values schema moved away from generic `freeFormObject` / `objectMap` / `objectOrYamlMap` references to named resource-family definitions

### Improved
* rendering is now deterministic and GitOps-friendly:
  * `generic.fullnameOverride`
  * `generic.nameSuffix`
  * `generic.deterministicNames`
* improved Argo CD and Flux support with centralized labels and annotations
* containers and initContainers now support both `list` and `map` forms
* improved shared pod-spec helper behavior for:
  * `topologySpreadConstraints`
  * `restartPolicy`
  * `startupProbe`
  * `serviceAccountName`
  * `hostAliases`
  * `tolerations`
  * `affinity`
  * `priorityClassName`
  * `dnsPolicy`
  * `imagePullSecrets`
  * typed volumes and volume mounts
* improved batch resource support with:
  * `CronJob.spec.timeZone`
  * reusable batch/general schema definitions
* improved `StatefulSet` service behavior with automatic governing headless Service generation when no explicit Service is provided

### Fixed
* removed non-deterministic rendering behavior that caused noisy GitOps diffs
* fixed fallback naming for unnamed containers and initContainers
* fixed helper compatibility gaps before the published `nuc-common` update
* added `restartPolicy` support to the shared pod helper
* improved backward compatibility coverage against previous release tags

### Testing
* added unit coverage for:
  * workloads
  * batch resources
  * services and ingress
  * network policy
  * configmaps and secrets
  * PV/PVC
  * HPA/PDB
  * RBAC
* added smoke scenarios for:
  * empty render
  * schema validation
  * rendering contract
  * example render
  * kubeconform validation
* added kind-based e2e installation tests covering readiness of the main rendered resources

### Removed
* removed the old flat template layout from the chart root
* removed legacy sample manifests under `docs/samples/`
* removed several embedded integration templates in favor of dependency-backed `nuc-*` modules

## 2.8.3 - December 26, 2024
* feature: Made `progressDeadlineSeconds` configurable in deployments

## 2.8.2 - December 09, 2024
* feature: Implemented support for SealedSecrets ([#77](https://github.com/nixys/nxs-universal-chart/issues/77))
* feature: Added cronjob suspend parameter
* docs update

## 2.8.1 - August 30, 2024
* feature: Added the ability to set k8s version, helm version, API versions of k8s-resources via values.yaml (global.helmVersion etc.)
* feature: Added the ability to set tolerations at the level of all deployed workloads. It's important to note that tolerations at the level of a specific resource will override global tolerations
* fix: Fixed syntax errors in _app.tpl that caused lines to stick together (helpers.app.selectorLabels, helpers.app.genericSelectorLabels)
* fix: Fixed template for Istio DestinationRule: added conditions to check if subsets and exportTo are set in values.yaml

## 2.8.0 - August 06, 2024
* feature: Implemented native support for Istio resources. ([#71]https://github.com/nixys/nxs-universal-chart/issues/71)
* docs update

## 2.7.0 - June 06, 2024
* feature: Implemented native support for Traefik resources. ([#68]https://github.com/nixys/nxs-universal-chart/issues/68)
* feature: BinaryData configmaps ([#67](https://github.com/nixys/nxs-universal-chart/pull/67))
* fix: jobsGeneral.labels not specified in template ([#69](https://github.com/nixys/nxs-universal-chart/issues/69))
* TODO: Add readme to new resources

## 2.6.0 - March 15, 2024
* feature: Better rendering for ConfigMap resources, added support for b64 encoded strings for easier setting of values via CLI. 
* feature: Support for certmanager custom resources ([#48](https://github.com/nixys/nxs-universal-chart/issues/48))
* feature: Support loadBalancerClass, allocateLoadBalancerNodePorts and externalTrafficPolicy for LoadBalancer type services ([#63](https://github.com/nixys/nxs-universal-chart/issues/63))
* fix: PVC name rendering ([#64](https://github.com/nixys/nxs-universal-chart/issues/64))
* TODO: Add readme to new resources

## 2.5.1 - January 10, 2024
* feature: add priorityClassName as option for every workload
* fix: statefulset typos

## 2.5.0 - November 17, 2023
* feature: add affinity as general option for every resourse
* fix: added missing options to readme
* fix: attaching pvc to existing pv

## 2.4.1 - August 23, 2023
* fix: render serviceaccount names
* fix: merging env if both general and container envs are used ([#50](https://github.com/nixys/nxs-universal-chart/issues/50))
* fix: deploymentsGeneral.annotation applying to deployment ([#49](https://github.com/nixys/nxs-universal-chart/issues/49))


## 2.4.0 - July 21, 2023
* feature: add Service Account workload to create serviceaccount and coresponding roles/clusterroles with bindings
* fix: default container and init-container names
* docs update
* feature: add emptyDir type in `volumes`

## 2.3.0 - Mar 07, 2023

* feature: add typed volumes via generic and workloads generals parameter `volumes` 
* feature: add labels form workload `extraSelectorLabels` parameter to pod affinity preset
* feature: add generic and workloads generals parameter `volumeMounts`
* deprecation: generic and workloads generals parameter `extraVolumeMounts` is marked as deprecated
* fix: increased affinity weight for "soft" rules

## 2.2.1 - Unreleased
* feature: add `Certificate` and `Issuser/ClusterIssuer` rendering ([cert-manager](https://cert-manager.io/docs/reference/api-docs) resources)

## 2.2.0 - Feb 20, 2023

* changed license to Apache2.0
* feature: add StatefilSet workload
* feature: add `startupProbe` to containers
* feature: add generic parameter `usePredefinedAffinity` for enable/disable predefined affinity usage in workloads (`true` by default)
* feature: add workloads parameter `usePredefinedAffinity` for enable/disable predefined affinity usage (not used by default)
* feature: add `env`, `envsFromConfigmap`, `envsFromSecret`, `envFrom`, `envConfigmaps`, `envSecrets` parameters to workloads generals
* deprecation: generic parameter `usePredefinedAffinity` will change default value to `false` in version 3.0
* improvement: pod template moved to helper
* docs update

## 2.1.4 - Aug 29, 2022

* feature: add clusterIP parameter for service

## 2.1.3 - Aug 1, 2022

* fix: rolled back parameter `servicemonitors` and marked as deprecated

## 2.1.2 - Aug 1, 2022

* fix: parameter `servicemonitors` has been renamed to `serviceMonitors`

## 2.1.1 - Jul 18, 2022

* fix: templating for ingress hostnames with empty values

## 2.1.0 - Jul 14, 2022

* fix: quotes to string values in ConfigMap
* fix: for random container name by lowercase
* feature: add templating for ingress hostnames
* feature: add generic parameter `extraImagePullSecrets` for workloads
* feature: add workloads parameter `extraImagePullSecrets`
* deprecation: workloads parameter `imagePullSecrets` is marked as deprecated
* docs update

## 2.0.1 - Jun 9, 2022

* added `defaultImagePullPolicy`
* docs minor fix

## 2.0.0 - May 30, 2022

* feature: add HPA support
* feature: add PDB support
* using `maps` instead of `list` for declare manifests
* docs update
* samples update

## 1.0.6 - May 6, 2022

* fix nindent for `securityContext`

## 1.0.5 - May 5, 2022

* feature: add template for workloads images
* fix `securityContext` for pod and container levels
* set default protocol TCP for service port
* set default service port name
* doc update

## 1.0.4 - April 15, 2022

* fix Service nodePort

## 1.0.3 - April 12, 2022

* fix helm hooks annotations custom annotations

## 1.0.2 - April 5, 2022

* fix helm hooks annotations for PVC

## 1.0.1 - April 4, 2022

* fix servicemonitor's selector rendering
