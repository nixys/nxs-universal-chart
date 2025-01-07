![Nxs Universal Chart Logo](https://github.com/nixys/nxs-universal-chart/assets/84891358/cb86062f-e5fe-467a-bd98-207fb3026194)

# nxs-universal-chart

## Introduction

nxs-universal-chart is a Helm chart you can use to install any of your applications into Kubernetes/OpenShift and other orchestrators compatible with native Kubernetes API.

### Features

* Flexible way to deploy your applications.
* Supported any Ingress controllers (Ingress Nginx, Traefik).
* Supported basic Istio resources (Gateway, VirtualService, DestinationRule).
* Easy way to template any custom resource with extraDeploy feature.
* Supported Kubernetes versions (<1.23/1.24/1.25/1.26/1.27/1.28/1.29/1.30) and OpenShift versions (3.11/<4.8/4.9/4.11/4.12/4.13).
* Supported Helm versions (2/3)

### Who can use this tool

* Development
* DevOps engineers

Who deploy into Kubernetes/OpenShift on regular basis.

# Quickstart

## Install

### Kubernetes/OpenShift

To install the chart with the release name `my-release`:

```bash
$ helm repo add nixys https://registry.nixys.io/chartrepo/public
$ helm install my-release nixys/nxs-universal-chart -f values.yaml
```

The command deploys your application with custom values on the Kubernetes/OpenShift cluster. The [Parameters](#parameters) section lists
the parameters that can be configured during installation. To check deployment examples, please see [samples](/docs/samples/). For additional ways to customize your experience with nxs-universal-chart please check [Additional features](docs/ADDITIONAL_FEATURES.md).

> **Tip**: Get yaml manifests with `helm template`

## Settings

### Global parameters

| Name                                     | Description                                              | Value |
|------------------------------------------|----------------------------------------------------------|-------|
| `global.kubeVersion`                     | Global Override Kubernetes version                       | `""`  |
| `global.helmVersion`                     | Global Override Helm version                             | `""`  |
| `global.apiVersion.cronJob`              | Global Override CronJob API version                      | `""`  |
| `global.apiVersion.deployment`           | Global Override Deployment API version                   | `""`  |
| `global.apiVersion.statefulSet`          | Global Override StatefulSet API version                  | `""`  |
| `global.apiVersion.ingress`              | Global Override Ingress API version                      | `""`  |
| `global.apiVersion.pdb`                  | Global Override PodDisruptionBudget API version          | `""`  |
| `global.apiVersion.traefik`              | Global Override Traefik resources API version            | `""`  |
| `global.apiVersion.istioGateway`         | Global Override Istio Gateway API version                | `""`  |
| `global.apiVersion.istioVirtualService`  | Global Override Istio VirtualService API version         | `""`  |
| `global.apiVersion.istioDestinationRule` | Global Override Istio DestinationRule API version        | `""`  |

### Generic parameters

| Name                            | Description                                                                                         | Value  |
|---------------------------------|-----------------------------------------------------------------------------------------------------|--------|
| `generic.labels`                | Labels to add to all deployed objects                                                               | `{}`   |
| `generic.annotations`           | Annotations to add to all deployed objects                                                          | `{}`   |
| `generic.extraSelectorLabels`   | SelectorLabels to add to deployments and services                                                   | `{}`   |
| `generic.podLabels`             | Labels to add to all deployed pods                                                                  | `{}`   |
| `generic.podAnnotations`        | Annotations to add to all deployed pods                                                             | `{}`   |
| `generic.serviceAccountName`    | The name of the ServiceAccount to use by workload                                                   | `[]`   |
| `generic.hostAliases`           | Pods host aliases to use by workload                                                                | `[]`   |
| `generic.dnsPolicy`             | DnsPolicy for workload pods                                                                         | `[]`   |
| `generic.priorityClassName`     | priorityClassName for workload pods                                                                 | `[]`   |
| `generic.volumes`               | Array of typed Volumes to add to all deployed workloads                                             | `[]`   |
| `generic.volumeMounts`          | Array of k8s VolumeMounts to add to all deployed workloads                                          | `[]`   |
| `generic.extraVolumes`          | Array of k8s Volumes to add to all deployed workloads                                               | `[]`   |
| `generic.extraImagePullSecrets` | Array of existing pull secrets to add to all deployed workloads                                     | `[]`   |
| `generic.usePredefinedAffinity` | Use Affinity presets in all workloads by default                                                    | `true` |
| `generic.tolerations`           | Tolerations to add to all deployed workloads. It's overrided by the specific resource's tolerations | `[]`   |
| `generic.tolerations.key`       | The key that the toleration applies to                                                              | `""`   |
| `generic.tolerations.operator`  | Operator used to compare the key. Allowed values: `Exists` or `Equal`                               | `""`   |
| `generic.tolerations.value`     | The value associated with the key, used when the operator is `Equal`                                | `""`   |
| `generic.tolerations.effect`    | Effect of the toleration. Allowed values: `NoSchedule`, `PreferNoSchedule`, `NoExecute`             | `""`   |
| `generic.lifecycle`             | lifecycle hooks to add all workloads by default. Properties overridden by the specific resource's   | `{}`   |
| `generic.startupProbe`          | startupProbe to add to all workloads by default. Properties overridden by the specific resource's   | `{}`   |
| `generic.readinessProbe`        | readinessProbe to add to all workloads by default. Properties overridden by the specific resource's | `{}`   |
| `generic.livenessProbe`         | livenessProbe to add to all workloads by default. Properties overridden by the specific resource's  | `{}`   |


### Common parameters

| Name                        | Description                                                                                                   | Value            |
|-----------------------------|---------------------------------------------------------------------------------------------------------------|------------------|
| `kubeVersion`               | Override Kubernetes version                                                                                   | `""`             |
| `nameOverride`              | String to override release name                                                                               | `""`             |
| `envs`                      | Map of environment variables which will be deplyed as ConfigMap with name `RELEASE_NAME-envs`                 | `{}`             |
| `envsString`                | String with map of environment variables which will be deplyed as ConfigMap with name `RELEASE_NAME-envs`     | `""`             |
| `secretEnvs`                | Map of environment variables which will be deplyed as Secret with name `RELEASE_NAME-secret-envs`             | `{}`             |
| `secretEnvsString`          | String with map of environment variables which will be deplyed as Secret with name `RELEASE_NAME-secret-envs` | `""`             |
| `imagePullSecrets`          | Map of registry secrets in `.dockerconfigjson` format                                                         | `{}`             |
| `defaultImage`              | Docker image that will be used by default                                                                     | `[]`             |
| `defaultImageTag`           | Docker image tag that will be used by default                                                                 | `[]`             |
| `defaultImagePullPolicy`    | Docker image pull policy that will be used by default                                                         | `"IfNotPresent"` |
| `podAffinityPreset`         | Pod affinity preset. Ignored if workload `affinity` is set. Allowed values: `soft` or `hard`                  | `soft`           |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if workload `affinity` is set. Allowed values: `soft` or `hard`             | `soft`           |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if workload `affinity` is set. Allowed values: `soft` or `hard`            | `""`             |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if workload `affinity` is set                                                | `""`             |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if workload `affinity` is set                                             | `[]`             |
| `extraDeploy`               | Map of extra objects (k8s manifests or Helm templates) to deploy with the release. [Example](#example-3)      | `[]`             |
| `diagnosticMode.enabled`    | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                       | `false`          |
| `diagnosticMode.command`    | Command to override all containers in the deployment                                                          | `["sleep"]`      |
| `diagnosticMode.args`       | Args to override all containers in the deployment                                                             | `["infinity"]`   |
| `releasePrefix`             | Override prefix for all manifests names. Release name used by default. You should use `"-"` to make it empty. | `""`             |
| `parentChart.name`          | When nxs-universal-chart used as library chart as dependency, parent chart name can be used in label app.kubernetes.io/name and helm.sh/chart instead of xs-universal-char chart values. This is important to uniquely identify app's resources with selector labels. | `""`             |
| `parentChart.version`       | When nxs-universal-chart used as library chart as dependency, parent chart version can be used in label helm.sh/chart and app.kubernetes.io/version instead of xs-universal-char chart values | `""`             |


### Ingresses parameters

`ingresses` is a map of the Ingress parameters, where key is a hostname (domain) of Ingress.

| Name                     | Description                                                                                             | Value              |
|--------------------------|---------------------------------------------------------------------------------------------------------|--------------------|
| `name`                   | Custom name of the ingress, if empty ingress hostname will be used                                      | `""`               |
| `labels`                 | Extra labels for ingress                                                                                | `{}`               |
| `annotations`            | Extra annotations for ingress                                                                           | `{}`               |
| `certManager.issuerName` | CertManager issuer name for ingress TLS                                                                 | `""`               |
| `certManager.issuerType` | CertManager issuer type for ingress TLS                                                                 | `"cluster-issuer"` |
| `ingressClassName`       | The name of ingressClass to use                                                                         | `""`               |
| `tlsName`                | The name of secret to use for CertManager generated TLS                                                 | `""`               |
| `hosts`                  | Array of the ingress [hosts](#ingress-hosts-object-parameters) objects                                  | `[]`               |
| `extraTls`               | Array of the ingress [tls params](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls) | `[]`               |

#### Ingress `hosts` object parameters

| Name       | Description                                                            | Value |
|------------|------------------------------------------------------------------------|-------|
| `hostname` | Hostname to serve by ingress, if empty ingress hostname will be used   | `""`  |
| `paths`    | Array of the ingress [paths](#ingress-paths-object-parameters) objects | `[]`  |

#### Ingress `paths` object parameters

| Name          | Description                                                                                                             | Value      |
|---------------|-------------------------------------------------------------------------------------------------------------------------|------------|
| `path`        | URL path                                                                                                                | `"/"`      |
| `pathType`    | Type of the ingress path [see for details](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types) | `"Prefix"` |
| `serviceName` | Name of the service to route requests                                                                                   | `""`       |
| `servicePort` | Name or number of the service port to route requests                                                                    | `""`       |

### Services parameters

`servicesGeneral` is a map of the Services parameters, which uses for all Services.

| Name                                  | Description                                          | Value       |
|---------------------------------------|------------------------------------------------------|-------------|
| `servicesGeneral.labels`              | Labels to add to all services                        | `{}`        |
| `servicesGeneral.annotations`         | Annotations to add to all services                   | `{}`        |

`services` is a map of the Service parameters, where key is a name of Service.

| Name                       | Description                                                           | Value       |
|----------------------------|-----------------------------------------------------------------------|-------------|
| `labels`                   | Extra labels for service                                              | `{}`        |
| `annotations`              | Extra annotations for service                                         | `{}`        |
| `type`                     | Type of a service                                                     | `""`        |
| `loadBalancerIP`           | IP of a service with LoadBalancer type                                | `""`        |
| `loadBalancerSourceRanges` | Service Load Balancer sources                                         | `[]`        |
| `loadBalancerClass`        | Service Load Balancer Class                                           | `""`        |
| `allocateLoadBalancerNodePorts`  | Load Balancer NodePort allocation                               | `true`      |
| `externalTrafficPolicy`    | Service external traffic policy                                       | `"Cluster"` |
| `healthCheckNodePort`      | Health check node port (numeric port number) for the service          | ``          |
| `externalIPs`              | Array of the external IPs that route to one or more cluster nodes     | `[]`        |
| `ports`                    | Array of the service [port](#service-ports-object-parameters) objects | `[]`        |
| `extraSelectorLabels`      | Extra selectorLabels for select workload                              | `{}`        |
| `clusterIP`                | Service clusterIP parameter value                                     | `""`        |

#### Service `ports` object parameters:

| Name         | Description                  | Value   |
|--------------|------------------------------|---------|
| `name`       | Name of the service port     | `""`    |
| `protocol`   | Protocol of the service port | `"TCP"` |
| `port`       | Service port number          | ``      |
| `targetPort` | Service target port number   | ``      |
| `nodePort`   | Service NodePort number      | ``      |

### Deployments parameters

`deploymentsGeneral` is a map of the Deployments parameters, which uses for all Deployments.

| Name                                       | Description                                         | Value   |
|--------------------------------------------|-----------------------------------------------------|---------|
| `deploymentsGeneral.labels`                | Labels to add to all deployments                    | `{}`    |
| `deploymentsGeneral.annotations`           | Annotations to add to all deployments               | `{}`    |
| `deploymentsGeneral.envsFromConfigmap`     | Map of ConfigMaps and envs from it                  | `{}`    |
| `deploymentsGeneral.envsFromSecret`        | Map of Secrets and envs from it                     | `{}`    |
| `deploymentsGeneral.env`                   | Array of extra environment variables                | `[]`    |
| `deploymentsGeneral.envConfigmaps`         | Array of Configmaps names with extra envs           | `[]`    |
| `deploymentsGeneral.envSecrets`            | Array of Secrets names with extra envs              | `[]`    |
| `deploymentsGeneral.envFrom`               | Array of extra envFrom objects                      | `[]`    |
| `deploymentsGeneral.extraVolumes`          | Array of k8s Volumes to add to all deployments      | `[]`    |
| `deploymentsGeneral.volumeMounts`          | Array of k8s VolumeMounts to add to all deployments | `[]`    |
| `deploymentsGeneral.affinity`                   | Affinity for CronJob; replicas pods assignment (ignored if defined on CronJob level)       | `{}`    |
| `deploymentsGeneral.usePredefinedAffinity` | Use Affinity presets in all deployments by default  | `false` |

`deployments` is a map of the Deployment parameters, where key is a name of the Deployment.

| Name                            | Description                                                                                                                       | Value |
|---------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|-------|
| `labels`                        | Extra labels for deployment                                                                                                       | `{}`  |
| `annotations`                   | Extra annotations for deployment                                                                                                  | `{}`  |
| `replicas`                      | Deployment replicas count                                                                                                         | `1`   |
| `strategy`                      | Deployment strategy                                                                                                               | `{}`  |
| `progressDeadlineSeconds`       | The maximum time in seconds for a deployment to make progress before it is considered failed | `600`  |
| `extraSelectorLabels`           | Extra selectorLabels for deployment                                                                                               | `{}`  |
| `podLabels`                     | Extra pod labels for deployment                                                                                                   | `{}`  |
| `podAnnotations`                | Extra pod annotations for deployment                                                                                              | `{}`  |
| `serviceAccountName`            | The name of the ServiceAccount to use by deployment                                                                               | `""`  |
| `hostAliases`                   | Pods host aliases                                                                                                                 | `[]`  |
| `affinity`                      | Affinity for deployment; replicas pods assignment                                                                                 | `{}`  |
| `securityContext`               | Security Context for deployment pods                                                                                              | `{}`  |
| `dnsPolicy`                     | DnsPolicy for deployment pods                                                                                                     | `""`  |
| `priorityClassName`             | priorityClassName for deployment pods                                                                                             | `""`  |
| `nodeSelector`                  | Node labels for deployment; pods assignment                                                                                       | `{}`  |
| `tolerations`                   | Tolerations for deployment; replicas pods assignment                                                                              | `[]`  |
| `imagePullSecrets`              | DEPRECATED. Array of existing pull secrets                                                                                        | `[]`  |
| `extraImagePullSecrets`         | Array of existing pull secrets                                                                                                    | `[]`  |
| `terminationGracePeriodSeconds` | Integer setting the termination grace period for the pods                                                                         | `30`  |
| `initContainers`                | Array of the deployment initContainers ([container](#container-object-parameters) objects)                                        | `[]`  |
| `containers`                    | Array of the deployment Containers ([container](#container-object-parameters) objects)                                            | `[]`  |
| `volumes`                       | Array of the deployment typed [volume](#typed-volumes-parameters) objects                                                         | `[]`  |
| `extraVolumes`                  | Array of [k8s Volumes](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#volume-v1-core) to add to deployments | `[]`  |

### StatefulSets parameters

`statefulSetsGeneral` is a map of the StatefulSets parameters, which uses for all StatefulSets.

| Name                                        | Description                                          | Value   |
|---------------------------------------------|------------------------------------------------------|---------|
| `statefulSetsGeneral.labels`                | Labels to add to all StatefulSets                    | `{}`    |
| `statefulSetsGeneral.annotations`           | Annotations to add to all StatefulSets               | `{}`    |
| `statefulSetsGeneral.envsFromConfigmap`     | Map of ConfigMaps and envs from it                   | `{}`    |
| `statefulSetsGeneral.envsFromSecret`        | Map of Secrets and envs from it                      | `{}`    |
| `statefulSetsGeneral.env`                   | Array of extra environment variables                 | `[]`    |
| `statefulSetsGeneral.envConfigmaps`         | Array of Configmaps names with extra envs            | `[]`    |
| `statefulSetsGeneral.envSecrets`            | Array of Secrets names with extra envs               | `[]`    |
| `statefulSetsGeneral.envFrom`               | Array of extra envFrom objects                       | `[]`    |
| `statefulSetsGeneral.extraVolumes`          | Array of k8s Volumes to add to all StatefulSets      | `[]`    |
| `statefulSetsGeneral.volumeMounts`          | Array of k8s VolumeMounts to add to all StatefulSets | `[]`    |
| `statefulSetsGeneral.affinity`                   | Affinity for CronJob; replicas pods assignment (ignored if defined on CronJob level)       | `{}`    |
| `statefulSetsGeneral.usePredefinedAffinity` | Use Affinity presets in all StatefulSets by default  | `false` |

`statefulSets` is a map of the StatefulSets parameters, where key is a name of the StatefulSets.

| Name                            | Description                                                                                                                                                            | Value |
|---------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|
| `labels`                        | Extra labels for statefulSet                                                                                                                                           | `{}`  |
| `annotations`                   | Extra annotations for statefulSet                                                                                                                                      | `{}`  |
| `replicas`                      | StatefulSet replicas count                                                                                                                                             | `1`   |
| `minReadySeconds`               | StatefulSet minReadySeconds                                                                                                                                            | ``    |
| `strategy`                      | StatefulSet strategy                                                                                                                                                   | `{}`  |
| `extraSelectorLabels`           | Extra selectorLabels for statefulSet                                                                                                                                   | `{}`  |
| `podLabels`                     | Extra pod labels for statefulSet                                                                                                                                       | `{}`  |
| `podAnnotations`                | Extra pod annotations for statefulSet                                                                                                                                  | `{}`  |
| `serviceAccountName`            | The name of the ServiceAccount to use by statefulSet                                                                                                                   | `""`  |
| `hostAliases`                   | Pods host aliases                                                                                                                                                      | `[]`  |
| `affinity`                      | Affinity for statefulSet; replicas pods assignment                                                                                                                     | `{}`  |
| `securityContext`               | Security Context for statefulSet pods                                                                                                                                  | `{}`  |
| `dnsPolicy`                     | DnsPolicy for statefulSet pods                                                                                                                                         | `""`  |
| `priorityClassName`             | priorityClassName for statefulSet pods                                                                                                                                 | `""`  |
| `nodeSelector`                  | Node labels for statefulSet; pods assignment                                                                                                                           | `{}`  |
| `tolerations`                   | Tolerations for statefulSet; replicas pods assignment                                                                                                                  | `[]`  |
| `imagePullSecrets`              | DEPRECATED. Array of existing pull secrets                                                                                                                             | `[]`  |
| `extraImagePullSecrets`         | Array of existing pull secrets                                                                                                                                         | `[]`  |
| `terminationGracePeriodSeconds` | Integer setting the termination grace period for the pods                                                                                                              | `30`  |
| `initContainers`                | Array of the statefulSet initContainers ([container](#container-object-parameters) objects)                                                                            | `[]`  |
| `containers`                    | Array of the statefulSet Containers ([container](#container-object-parameters) objects)                                                                                | `[]`  |
| `volumes`                       | Array of the statefulSet typed [volume](#typed-volumes-parameters) objects                                                                                             | `[]`  |
| `extraVolumes`                  | Array of [k8s Volumes](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#volume-v1-core) to add to statefulSets                                     | `[]`  |
| `volumeClaimTemplates`          | Array of [k8s volumeClaimTemplates](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#persistentvolumeclaimtemplate-v1-core) to add to statefulSets | `[]`  |


#### Container object parameters

| Name                   | Description                                                                                                                | Value            |
|------------------------|----------------------------------------------------------------------------------------------------------------------------|------------------|
| `name`                 | The name of the container                                                                                                  | `""`             |
| `image`                | Docker image of the container                                                                                              | `""`             |
| `imageTag`             | Docker image tag of the container                                                                                          | `"latest"`       |
| `imagePullPolicy`      | Docker image pull policy                                                                                                   | `"IfNotPresent"` |
| `securityContext`      | Security Context for container                                                                                             | `{}`             |
| `command`              | Container command override (list or string)                                                                                | `[]`             |
| `commandMaxDuration`   | Duration of command execution (for jobs and cronJobs only)                                                                 | ``               |
| `commandDurationAlert` | Create Prometheus Alert on command execution time exceeded (for jobs and cronJobs only)                                    | ``               |
| `args`                 | Container arguments override                                                                                               | `[]`             |
| `envsFromConfigmap`    | Map of ConfigMaps and envs from it                                                                                         | `{}`             |
| `envsFromSecret`       | Map of Secrets and envs from it                                                                                            | `{}`             |
| `env`                  | Array of extra environment variables                                                                                       | `[]`             |
| `envConfigmaps`        | Array of Configmaps names with extra envs                                                                                  | `[]`             |
| `envSecrets`           | Array of Secrets names with extra envs                                                                                     | `[]`             |
| `envFrom`              | Array of extra envFrom objects                                                                                             | `[]`             |
| `ports`                | Array of ports to be exposed from container                                                                                | `[]`             |
| `lifecycle`            | Containers lifecycle hooks                                                                                                 | `{}`             |
| `livenessProbe`        | Liveness probe object for container                                                                                        | `{}`             |
| `readinessProbe`       | Readiness probe object for container                                                                                       | `{}`             |
| `resources`            | The resources requests and limits for container                                                                            | `{}`             |
| `volumeMounts`         | Array of the [k8s Volume mounts](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#volumemount-v1-core) | `[]`             |

### Service accounts parameters

`serviceAccountGeneral` is a map of the ServiceAccount parameters, which uses for all service accounts and its roles/clusterroles and corresponding bindings.

| Name                                         | Description                                                                                | Value   |
|----------------------------------------------|--------------------------------------------------------------------------------------------|---------|
| `serviceAccountGeneral.labels`               | Extra labels for all ServiceAccounts                                                       | `{}`    |
| `serviceAccountGeneral.annotations`          | Extra annotations for all ServiceAccounts                                                  | `{}`    |

`serviceAccount` is a map of the ServiceAccount parameters, where key is name of the service account.

| Name                         | Description                                                                                           | Value     |
|------------------------------|-------------------------------------------------------------------------------------------------------|-----------|
| `labels`                     | Extra ServiceAccount, role and binding labels                                                         | `{}`      |
| `annotations`                | Extra ServiceAccount annotations                                                                      | `{}`      |
| `roles`                      | List of [role](#role-or-clusterrole-rules-object-parameters) parameters to create and bind            | `[]`      |
| `clusterRoles`               | List of [clusterRole](#role-or-clusterrole-rules-object-parameters) parameters to create and bind     | `[]`      |

`roles/clusterRoles` are list of maps of parameters of role/clusterrole. Service account can be created without corresponding roles and bindings.

#### Role or ClusterRole rules object parameters

| Name               | Description                                  | Value      |
|--------------------|----------------------------------------------|------------|
| `name`             | Name of role/clusterRole to create/bind      | `""`       |
| `clusterScope`     | If rules not present, for RoleBinding it's possible to bind either Role or ClusterRole (clusterScope=true). This parameter is ignored for clusterRoles and roles with rules. Default value is false          | `false`    |
| `rules`            | List of rules for Role/ClusterRole           | `[]`       |

If *rules* is empty then only binding to existing role/clusterRole will be created. If any *rules* exist then corresponding role/clusterRole will be created and binded to service account.

### Secrets parameters

`secrets` is a map of the Secret parameters, where key is a name of Secret.

| Name               | Description                                  | Value      |
|--------------------|----------------------------------------------|------------|
| `type`             | Secret type                                  | `"Opaque"` |
| `labels`           | Extra secret labels                          | `{}`       |
| `annotations`      | Extra secret annotations                     | `{}`       |
| `data`             | Map of Secret data                           | `{}`       |

Secret `data` object is a map where value can be a string, json or base64 encoded string with prefix `b64:`.

### SealedSecrets paramaters

`sealedSecrets` is a map of the SealedSecret parameters, where key is a name of SealedSecret.

| Name               | Description                                  | Value      |
|--------------------|----------------------------------------------|------------|
| `labels`           | Extra SealedSecret labels                    | `{}`       |
| `annotations`      | Extra SealedSecret annotations               | `{}`       |
| `encryptedData`    | Map of SealedSecret encrypted data           | `{}`       |

### ConfigMaps parameters

`configMaps` is a map of the ConfigMap parameters, where key is a name of ConfigMap.

| Name               | Description                                     | Value     |
|--------------------|-------------------------------------------------|-----------|
| `labels`           | Extra ConfigMap labels                          | `{}`      |
| `annotations`      | Extra ConfigMap annotations                     | `{}`      |
| `data`             | Map of ConfigMap data                           | `{}`      |

### PersistentVolumeClaims parameters

`pvcs` is a map of the PersistentVolumeClaim parameters, where key is a name of PersistentVolumeClaim.

| Name               | Description                                          | Value          |
|--------------------|------------------------------------------------------|----------------|
| `labels`           | Extra Persistent Volume Claim labels                 | `{}`           |
| `annotations`      | Extra Persistent Volume Claim annotations            | `{}`           |
| `accessModes`      | Persistent Volume access modes                       | `[]`           |
| `volumeMode`       | Persistent Volume volume mode                        | `"Filesystem"` |
| `volumeName`       | Persistent Volume volume name (if already exists)    | ``             |
| `storageClassName` | Persistent Volume Storage Class name                 | `""`           |
| `selector`         | Labels selector to further filter the set of volumes | `{}`           |

### typed Volumes parameters

| Name           | Description                                                | Value |
|----------------|------------------------------------------------------------|-------|
| `type`         | Resource type of the volume ("configMap","secret","pvc")   | `""`  |
| `name`         | Name of the resource that will be used with release prefix | `""`  |
| `originalName` | Original name of the resource                              | `""`  |
| `items`        | Array of volume items                                      | `[]`  |

### Hooks parameters

`hooksGeneral` is a map of the Helm Hooks Jobs parameters, which uses for all Helm Hooks Jobs.

| Name                                   | Description                                                                             | Value   |
|----------------------------------------|-----------------------------------------------------------------------------------------|---------|
| `hooksGeneral.labels`                  | Extra labels for all Hook Job                                                           | `{}`    |
| `hooksGeneral.annotations`             | Extra annotations for all Hook Job                                                      | `{}`    |
| `hooksGeneral.envsFromConfigmap`       | Map of ConfigMaps and envs from it                                                      | `{}`    |
| `hooksGeneral.envsFromSecret`          | Map of Secrets and envs from it                                                         | `{}`    |
| `hooksGeneral.env`                     | Array of extra environment variables                                                    | `[]`    |
| `hooksGeneral.envConfigmaps`           | Array of Configmaps names with extra envs                                               | `[]`    |
| `hooksGeneral.envSecrets`              | Array of Secrets names with extra envs                                                  | `[]`    |
| `hooksGeneral.envFrom`                 | Array of extra envFrom objects                                                          | `[]`    |
| `hooksGeneral.parallelism`             | How much Jobs can be run in parallel (ignored if defined on Hook level)                 | `1`     |
| `hooksGeneral.completions`             | How much Pods should finish to finish Job (ignored if defined on Hook level)            | `1`     |
| `hooksGeneral.activeDeadlineSeconds`   | Duration of the Job (ignored if defined on Hook level)                                  | `100`   |
| `hooksGeneral.backoffLimit`            | Number of retries before considering a Job as failed (ignored if defined on Hook level) | `6`     |
| `hooksGeneral.ttlSecondsAfterFinished` | TTL for delete finished Hook Job (ignored if defined on Hook level)                     | `100`   |
| `hooksGeneral.podLabels`               | Extra pod labels for Hook Job (ignored if defined on Hook level)                        | `{}`    |
| `hooksGeneral.podAnnotations`          | Extra pod annotations for Hook Job (ignored if defined on Hook level)                   | `{}`    |
| `hooksGeneral.serviceAccountName`      | The name of the ServiceAccount to use by Hook Job (ignored if defined on Hook level)    | `""`    |
| `hooksGeneral.hostAliases`             | Pods host aliases (ignored if defined on Hook level)                                    | `[]`    |
| `hooksGeneral.affinity`                | Affinity for Hook Job; replicas pods assignment (ignored if defined on Hook level)      | `{}`    |
| `hooksGeneral.dnsPolicy`               | DnsPolicy for Hook Job pods (ignored if defined on Hook level)                          | `""`    |
| `hooksGeneral.extraVolumes`            | Array of k8s Volumes to add to all Hook Jobs                                            | `[]`    |
| `hooksGeneral.volumeMounts`            | Array of k8s VolumeMounts to add to all Hook Jobs                                       | `[]`    |
| `hooksGeneral.usePredefinedAffinity`   | Use Affinity presets in all Hook Jobs by default                                        | `false` |

`hooks` is a map of the Helm Hooks Jobs parameters, where key is name of the Helm Hook job.

| Name                      | Description                                                                              | Value                       |
|---------------------------|------------------------------------------------------------------------------------------|-----------------------------|
| `labels`                  | Extra Hook Job labels                                                                    | `{}`                        |
| `annotations`             | Extra Hook Job annotations                                                               | `{}`                        |
| `kind`                    | Kind of the Helm Hook                                                                    | `"pre-install,pre-upgrade"` |
| `weight`                  | Weight of the Helm Hook                                                                  | `"5"`                       |
| `deletePolicy`            | Delete Policy of the Helm Hook                                                           | `"before-hook-creation"`    |
| `parallelism`             | How much pods of Jobs can be run in parallel                                             | `1`                         |
| `completions`             | How much pods should finish to finish Job                                                | `1`                         |
| `activeDeadlineSeconds`   | Duration of the Job                                                                      | `100`                       |
| `backoffLimit`            | Number of retries before considering a Job as failed                                     | `6`                         |
| `ttlSecondsAfterFinished` | TTL for delete finished Hook Job                                                         | `100`                       |
| `podLabels`               | Extra pod labels for Hook Job                                                            | `{}`                        |
| `podAnnotations`          | Extra pod annotations for Hook Job                                                       | `{}`                        |
| `serviceAccountName`      | The name of the ServiceAccount to use by Hook Job                                        | `""`                        |
| `hostAliases`             | Pods host aliases                                                                        | `[]`                        |
| `affinity`                | Affinity for Hook Job; replicas pods assignment                                          | `{}`                        |
| `securityContext`         | Security Context for Hook Job pods                                                       | `{}`                        |
| `dnsPolicy`               | DnsPolicy for Hook Job pods                                                              | `""`                        |
| `priorityClassName`       | priorityClassName for Hook Job pods                                                      | `""`                        |
| `nodeSelector`            | Node labels for Hook Job; pods assignment                                                | `{}`                        |
| `tolerations`             | Tolerations for Hook Job; replicas pods assignment                                       | `[]`                        |
| `imagePullSecrets`        | DEPRECATED. Array of existing pull secrets                                               | `[]`                        |
| `extraImagePullSecrets`   | Array of existing pull secrets                                                           | `[]`                        |
| `initContainers`          | Array of the Hook Job initContainers ([container](#container-object-parameters) objects) | `[]`                        |
| `containers`              | Array of the Hook Job Containers ([container](#container-object-parameters) objects)     | `[]`                        |
| `volumes`                 | Array of the Hook Job typed volumes                                                      | `[]`                        |
| `extraVolumes`            | Array of k8s Volumes to add to Hook Job                                                  | `[]`                        |
| `restartPolicy`           | Restart Policy of the Hook Job                                                           | `"Never"`                   |

### CronJobs parameters

`cronJobsGeneral` is a map of the CronJobs parameters, which uses for all CronJobs.

| Name                                         | Description                                                                                | Value   |
|----------------------------------------------|--------------------------------------------------------------------------------------------|---------|
| `cronJobsGeneral.labels`                     | Extra labels for all CronJobs                                                              | `{}`    |
| `cronJobsGeneral.annotations`                | Extra annotations for all CronJobs                                                         | `{}`    |
| `cronJobsGeneral.envsFromConfigmap`          | Map of ConfigMaps and envs from it                                                         | `{}`    |
| `cronJobsGeneral.envsFromSecret`             | Map of Secrets and envs from it                                                            | `{}`    |
| `cronJobsGeneral.env`                        | Array of extra environment variables                                                       | `[]`    |
| `cronJobsGeneral.envConfigmaps`              | Array of Configmaps names with extra envs                                                  | `[]`    |
| `cronJobsGeneral.envSecrets`                 | Array of Secrets names with extra envs                                                     | `[]`    |
| `cronJobsGeneral.envFrom`                    | Array of extra envFrom objects                                                             | `[]`    |
| `cronJobsGeneral.startingDeadlineSeconds`    | Duration for starting all CronJobs (ignored if defined on CronJob level)                   | ``      |
| `cronJobsGeneral.successfulJobsHistoryLimit` | Limitation of completed jobs should be kept (ignored if defined on CronJob level)          | `3`     |
| `cronJobsGeneral.failedJobsHistoryLimit`     | Limitation of failed jobs should be kept (ignored if defined on CronJob level)             | `1`     |
| `cronJobsGeneral.parallelism`                | How much pods of Job can be run in parallel (ignored if defined on CronJob level)          | `1`     |
| `cronJobsGeneral.completions`                | How much pods should finish to finish Job (ignored if defined on CronJob level)            | `1`     |
| `cronJobsGeneral.activeDeadlineSeconds`      | Duration of the Job (ignored if defined on CronJob level)                                  | `100`   |
| `cronJobsGeneral.backoffLimit`               | Number of retries before considering a Job as failed (ignored if defined on CronJob level) | `6`     |
| `cronJobsGeneral.ttlSecondsAfterFinished`    | TTL for delete finished Jobs (ignored if defined on CronJob level)                         | `100`   |
| `cronJobsGeneral.podLabels`                  | Extra pod labels for CronJob (ignored if defined on CronJob level)                         | `{}`    |
| `cronJobsGeneral.podAnnotations`             | Extra pod annotations for CronJob (ignored if defined on CronJob level)                    | `{}`    |
| `cronJobsGeneral.serviceAccountName`         | The name of the ServiceAccount to use by Job (ignored if defined on CronJob level)         | `""`    |
| `cronJobsGeneral.hostAliases`                | Pods host aliases (ignored if defined on CronJob level)                                    | `[]`    |
| `cronJobsGeneral.affinity`                   | Affinity for CronJob; replicas pods assignment (ignored if defined on CronJob level)       | `{}`    |
| `cronJobsGeneral.dnsPolicy`                  | DnsPolicy for CronJob pods (ignored if defined on CronJob level)                           | `""`    |
| `cronJobsGeneral.extraVolumes`               | Array of k8s Volumes to add to all CronJobs                                                | `[]`    |
| `cronJobsGeneral.volumeMounts`               | Array of k8s VolumeMounts to add to all CronJobs                                           | `[]`    |
| `cronJobsGeneral.usePredefinedAffinity`      | Use Affinity presets in all CronJobs by default                                            | `false` |

`cronJobs` is a map of the CronJobs parameters, where key is name of the CronJob.

| Name                         | Description                                                                             | Value     |
|------------------------------|-----------------------------------------------------------------------------------------|-----------|
| `labels`                     | Extra CronJob labels                                                                    | `{}`      |
| `annotations`                | Extra CronJob annotations                                                               | `{}`      |
| `singleOnly`                 | Forbid concurrency policy                                                               | `"false"` |
| `suspend`                    | Suspend execution of Jobs                                                               | `false`   |
| `schedule`                   | Cronjob scheduling                                                                      | ``        |
| `startingDeadlineSeconds`    | Duration for starting CronJob                                                           | ``        |
| `successfulJobsHistoryLimit` | Limitation of completed jobs should be kept                                             | `3`       |
| `failedJobsHistoryLimit`     | Limitation of failed jobs should be kept                                                | `1`       |
| `parallelism`                | How much pods of CronJob can be run in parallel                                         | `1`       |
| `completions`                | How much pods should finish to finish Job                                               | `1`       |
| `activeDeadlineSeconds`      | Duration of the Job                                                                     | `100`     |
| `backoffLimit`               | Number of retries before considering a Job as failed                                    | `6`       |
| `ttlSecondsAfterFinished`    | TTL for delete finished CronJob                                                         | `100`     |
| `podLabels`                  | Extra pod labels for CronJob                                                            | `{}`      |
| `podAnnotations`             | Extra pod annotations for CronJob                                                       | `{}`      |
| `serviceAccountName`         | The name of the ServiceAccount to use by CronJob                                        | `""`      |
| `hostAliases`                | Pods host aliases                                                                       | `[]`      |
| `affinity`                   | Affinity for CronJob; replicas pods assignment                                          | `{}`      |
| `securityContext`            | Security Context for CronJob pods                                                       | `{}`      |
| `dnsPolicy`                  | DnsPolicy for CronJob pods                                                              | `""`      |
| `priorityClassName`          | priorityClassName for CronJob pods                                                      | `""`      |
| `nodeSelector`               | Node labels for CronJob; pods assignment                                                | `{}`      |
| `tolerations`                | Tolerations for CronJob; replicas pods assignment                                       | `[]`      |
| `imagePullSecrets`           | DEPRECATED. Array of existing pull secrets                                              | `[]`      |
| `extraImagePullSecrets`      | Array of existing pull secrets                                                          | `[]`      |
| `initContainers`             | Array of the CronJob initContainers ([container](#container-object-parameters) objects) | `[]`      |
| `containers`                 | Array of the CronJob Containers ([container](#container-object-parameters) objects)     | `[]`      |
| `volumes`                    | Array of the CronJob typed volumes                                                      | `[]`      |
| `extraVolumes`               | Array of k8s Volumes to add to CronJob                                                  | `[]`      |
| `restartPolicy`              | Restart Policy of the Jobs                                                              | `"Never"` |

### Jobs parameters

`jobsGeneral` is a map of the Jobs parameters, which uses for all Jobs.

| Name                                  | Description                                                                            | Value   |
|---------------------------------------|----------------------------------------------------------------------------------------|---------|
| `jobsGeneral.labels`                  | Extra labels for all Job                                                               | `{}`    |
| `jobsGeneral.annotations`             | Extra annotations for all Job                                                          | `{}`    |
| `jobsGeneral.envsFromConfigmap`       | Map of ConfigMaps and envs from it                                                     | `{}`    |
| `jobsGeneral.envsFromSecret`          | Map of Secrets and envs from it                                                        | `{}`    |
| `jobsGeneral.env`                     | Array of extra environment variables                                                   | `[]`    |
| `jobsGeneral.envConfigmaps`           | Array of Configmaps names with extra envs                                              | `[]`    |
| `jobsGeneral.envSecrets`              | Array of Secrets names with extra envs                                                 | `[]`    |
| `jobsGeneral.envFrom`                 | Array of extra envFrom objects                                                         | `[]`    |
| `jobsGeneral.parallelism`             | How much Jobs can be run in parallel (ignored if defined on Job level)                 | `1`     |
| `jobsGeneral.completions`             | How much Pods should finish to finish Job (ignored if defined on Job level)            | `1`     |
| `jobsGeneral.activeDeadlineSeconds`   | Duration of the Job (ignored if defined on Job level)                                  | `100`   |
| `jobsGeneral.backoffLimit`            | Number of retries before considering a Job as failed (ignored if defined on Job level) | `6`     |
| `jobsGeneral.ttlSecondsAfterFinished` | TTL for delete finished Job (ignored if defined on Job level)                          | `100`   |
| `jobsGeneral.podLabels`               | Extra pod labels for Job (ignored if defined on Job level)                             | `{}`    |
| `jobsGeneral.podAnnotations`          | Extra pod annotations for Job (ignored if defined on Job level)                        | `{}`    |
| `jobsGeneral.serviceAccountName`      | The name of the ServiceAccount to use by Job (ignored if defined on Job level)         | `""`    |
| `jobsGeneral.hostAliases`             | Pods host aliases (ignored if defined on Job level)                                    | `[]`    |
| `jobsGeneral.affinity`                | Affinity for Job; replicas pods assignment (ignored if defined on Job level)           | `{}`    |
| `jobsGeneral.dnsPolicy`               | DnsPolicy for Job pods (ignored if defined on Job level)                               | `""`    |
| `jobsGeneral.extraVolumes`            | Array of k8s Volumes to add to all Jobs                                                | `[]`    |
| `jobsGeneral.volumeMounts`            | Array of k8s VolumeMounts to add to all Jobs                                           | `[]`    |
| `jobsGeneral.usePredefinedAffinity`   | Use Affinity presets in all Jobs by default                                            | `false` |

`jobs` is a map of the Jobs parameters, where key is a name of the Job.

| Name                      | Description                                                                              | Value     |
|---------------------------|------------------------------------------------------------------------------------------|-----------|
| `labels`                  | Extra Job labels                                                                         | `{}`      |
| `annotations`             | Extra Job annotations                                                                    | `{}`      |
| `parallelism`             | How much pods of Job can be run in parallel                                              | `1`       |
| `completions`             | How much pods should finish to finish Job                                                | `1`       |
| `activeDeadlineSeconds`   | Duration of the Job                                                                      | `100`     |
| `backoffLimit`            | Number of retries before considering a Job as failed                                     | `6`       |
| `ttlSecondsAfterFinished` | TTL for delete finished Hook Job                                                         | `100`     |
| `podLabels`               | Extra pod labels for Hook Job                                                            | `{}`      |
| `podAnnotations`          | Extra pod annotations for Hook Job                                                       | `{}`      |
| `serviceAccountName`      | The name of the ServiceAccount to use by deployment                                      | `""`      |
| `hostAliases`             | Pods host aliases                                                                        | `[]`      |
| `affinity`                | Affinity for Hook Job; replicas pods assignment                                          | `{}`      |
| `securityContext`         | Security Context for Hook Job pods                                                       | `{}`      |
| `dnsPolicy`               | DnsPolicy for Hook Job pods                                                              | `""`      |
| `priorityClassName`       | priorityClassName for Hook Job pods                                                      | `""`      |
| `nodeSelector`            | Node labels for Hook Job; pods assignment                                                | `{}`      |
| `tolerations`             | Tolerations for Hook Job; replicas pods assignment                                       | `[]`      |
| `imagePullSecrets`        | DEPRECATED. Array of existing pull secrets                                               | `[]`      |
| `extraImagePullSecrets`   | Array of existing pull secrets                                                           | `[]`      |
| `initContainers`          | Array of the Hook Job initContainers ([container](#container-object-parameters) objects) | `[]`      |
| `containers`              | Array of the Hook Job Containers ([container](#container-object-parameters) objects)     | `[]`      |
| `volumes`                 | Array of the Hook Job typed volumes                                                      | `[]`      |
| `extraVolumes`            | Array of k8s Volumes to add to Hook Job                                                  | `[]`      |
| `restartPolicy`           | Restart Policy of the Job                                                                | `"Never"` |

### ServiceMonitors parameters

`serviceMonitors` is a map of the Prometheus ServiceMonitor parameters, where key is name of ServiceMonitor.

| Name                  | Description                              | Value |
|-----------------------|------------------------------------------|-------|
| `labels`              | Extra ServiceMonitor labels              | `{}`  |
| `endpoints`           | Array of ServiceMonitor endpoints        | `[]`  |
| `extraSelectorLabels` | Extra selectorLabels for select workload | `{}`  |

### PodDisruptionBudget parameters

`pdbs` is a map of the PDB parameters, where key is a name

| Name                  | Description                                     | Value |
|-----------------------|-------------------------------------------------|-------|
| `labels`              | Extra PDB labels                                | `{}`  |
| `minAvailable`        | Pods that must be available after the eviction  | `""`  |
| `maxUnavailable`      | Pods that can be unavailable after the eviction | `""`  |
| `extraSelectorLabels` | Extra selectorLabels for select workload        | `{}`  |

### HorizontalPodAutoscaler parameters

`hpas` is map of HPA parameters, where key is a name

| Name             | Description                                                             | Value                   |
|------------------|-------------------------------------------------------------------------|-------------------------|
| `labels`         | Extra HPA labels                                                        | `{}`                    |
| `annotations`    | Extra HPA annotations                                                   | `{}`                    |
| `apiVersion`     | apiVersion for HPA object                                               | `"autoscaling/v2"`      |
| `minReplicas`    | minimum replicas for HPA                                                | `2`                     |
| `maxReplicas`    | maximum replicas for HPA                                                | `3`                     |
| `scaleTargetRef` | Required [scaleTargetRef](#hpa-scaletargetref-object-parameters) object |                         |
| `targetCPU`      | target CPU utilization percentage                                       | `""`                    |
| `targetMemory`   | target memory utilization percentage                                    | `""`                    |
| `metrics`        | list of custom metrics                                                  | `[]`                    |

### HPA `scaleTargetRef` object parameters

| Name       | Description                      | Value        |
|------------|----------------------------------|--------------|
| apiVersion | apiVersion for target HPA object | "apps/v1"    |
| kind       | kind for target HPA object       | "Deployment" |
| name       | Required name of target object   | ""           |

### Issuers parameters

`issuers` is map of Issuers parameters, where key is a name

| Name         | Description                                                                                                               | Value           |
|--------------|---------------------------------------------------------------------------------------------------------------------------|-----------------|
| `kind`       | issuer type                                                                                                               | "ClusterIssuer" |
| `acme`       | map with [acme issuerConfig](https://cert-manager.io/docs/reference/api-docs/#acme.cert-manager.io/v1.ACMEIssuer)         | `{}`            |
| `ca`         | map with [ca issuerConfig](https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.CAIssuer)                  | `{}`            |
| `vault`      | map with [vault issuerConfig](https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.VaultIssuer)            | `{}`            |
| `selfSigned` | map with [selfSigned issuerConfig](https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.SelfSignedIssuer)  | `{}`            |
| `venafi`     | map with [venafi issuerConfig](https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.VenafiIssuer)          | `{}`            |

### Certificates parameters

 `certificates` is map of certificates parameters, where key is a name according to [CertificateSpec](https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.CertificateSpec)

| Name                      | Description                                                             | Value             |
|---------------------------|-------------------------------------------------------------------------|-------------------|
| `kind`                    | issuer type                                                             | "ClusterIssuer"   |
| `subject`                 | list of certificate subject attributes                                  | `[]`              |
| `literalSubject`          | requested certificate subject attributes                                | `""`              |
| `commonName`              | requested common name attribute                                         | `""`              |
| `duration`                | requested lifetime of certificate                                       | `""`              |
| `renewBefore`             | how long to wait before renewing                                        | `""`              |
| `dnsNames`                | list of requested dns names                                             | `[]`              |
| `ipAddresses`             | list of requested ip addresses                                          | `[]`              |
| `uris`                    | list of requested uris                                                  | `[]`              |
| `emailAddresses`          | list of requested email addresses                                       | `[]`              |
| `secretName`              | name of secret to be created for certificate                            | `""`              |
| `secretTemplate`          | [secretTemplate](#certificates-secretTemplate-object-parameters) object |                   |
| `keystores`               | additionals (certificate keystores)[https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.CertificateKeystores]| `[]` |
| `issuerRef`               | [issuerRef](#certificates-issuerRef-object-parameters) object           |                   |
| `isCA`                    | check if certificate is CA on issuing                                   | `""`              |
| `usages`                  | list of requested certificate usages                                    | `[]`              |
| `privateKey`              | set of [privatekey options](https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.CertificatePrivateKey) | `{}`              |
| `encodeUsagesInRequest`   | set whether key usage should be encoded                                  | `""`              |
| `revisionHistoryLimit`    | the number of certificate requests being stored                         | `""`              |
| `additionalOutputFormats` | extra output formats of the private key and signed certificate chain    | `""`              |

### Certificates `secretTemplate` object parameters

| Name           | Description                                                             | Value             |
|----------------|-------------------------------------------------------------------------|-------------------|
| annotations    | extra annotations for generated secrets                                 | `{}`              |
| labels         | extra labels for generated secrets                                      | `{}`              |

### Certificates `issuerRef` object parameters

| Name           | Description                                                             | Value             |
|----------------|-------------------------------------------------------------------------|-------------------|
| originalName   | original name of Issuer resource                                        | `""`              |
| name           | name of the resource that will be used with release prefix              | `""`              |
| kind           | kind of the issuer resource                                             | `""`              |
| group          | group of the issuer resource                                            | `""`              |

### IngressRoutes, IngressRoutesTCP, IngressRoutesUDP parameters

`ingressroutes`, `ingressroutesTCP`, `ingressroutesUDP` are maps of IngressRoute parameters, where key is a name

| Name          | Description                                                                                                                            | Value           |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| `entryPoints` | list of entryPoints names. [EntryPoints](https://doc.traefik.io/traefik/routing/routers/#entrypoints)                                  | `[]`            |
| `routes`      | list of routes. [Routes](#ingressroutes-routes-object-parameters) object                                                               | `[]`            |
| `tls`         | defines TLS certificate configuration. Only for ingressroutes and ingressroutesTCP. [TLS](#ingressroutes-tls-object-parameters) object | `{}`            |

### IngressRoutes `routes` object parameters

| Name                                      | Description                                                                       | Value             |
|-------------------------------------------|-----------------------------------------------------------------------------------|-------------------|
| match                                     | defines the rule corresponding to an underlying router                            | `""`              |
| priority                                  | defines the priority to disambiguate rules of the same length, for route matching | `""`              |
| middlewares                               | list of reference to [Middleware](#middlewares-middlewarestcp-parameters)         | `[]`              |
| middlewares.name                          | defines the Middleware name                                                       | `""`              |
| middlewares.namespace                     | defines the Middleware namespace                                                  | `""`              |
| services                                  | list of any combination of [TraefikService](#traefikservices-parameters) and reference to a Kubernetes service   | `[]`              |
| services.name                             | defines the name of the service                                                   | `""`              |
| services.namespace                        | defines the namespace of the service                                              | `""`              |
| services.passHostHeader                   | defines whether the Host header should be passed to the backend services          | `true`            |
| services.kind                             | defines the kind of service (e.g., `Service`, `TraefikService`)                   | `""`              |
| services.port                             | defines the port of the service. This can be a reference to a named port          | `""`              |
| services.responseForwarding.flushInterval | defines the interval for flushing response data                                   | `""`              |
| services.scheme                           | defines the scheme used to communicate with the service (`http` or `https`)       | `""`              |
| services.serversTransport                 | defines the [ServersTransport](#serverstransport-serverstransporttcp-parameters) name. See also [ServersTransport reference](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/#serverstransport-reference) | `""`              |
| services.sticky.cookie.httpOnly           | defines if the sticky cookie is HTTP only                                         | `true`            |
| services.sticky.cookie.name               | defines the name of the sticky cookie                                             | `""`              |
| services.sticky.cookie.secure             | defines if the sticky cookie is secure                                            | `true`            |
| services.sticky.cookie.sameSite           | defines the sameSite attribute of the sticky cookie (`Strict`, `Lax`, `None`)     | `""`              |
| services.sticky.cookie.maxAge             | defines the maxAge of the sticky cookie                                           | `0`               |
| services.strategy                         | defines the load balancing strategy for the service (`RoundRobin`)                | `"RoundRobin"`    |
| services.weight                           | defines the weight                                                                | `0`               |
| services.nativeLB                         | defines if native load balancing is used                                          | `false`           |

### IngressRoutes `tls` object parameters

| Name                  | Description                                                                                                                                                              | Value             |
|-----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|
| secretName            | defines the name of the secret that contains the TLS certificate                                                                                                         | `""`              |
| store.name            | defines the name of the [TLSStore](#tlsstore-parameters). See also [TLSStore](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/#kind-tlsstore)            | `""`              |
| store.namespace       | defines the namespace of the [TLSStore](#tlsstore-parameters). See also [TLSStore](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/#kind-tlsstore)       | `""`              |
| options.name          | defines the name of the [TLSOption](#tlsoptions-parameters). See also [TLSOptions](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/#kind-tlsoption)      | `""`              |
| options.namespace     | defines the namespace of the [TLSOption](#tlsoptions-parameters). See also [TLSOptions](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/#kind-tlsoption) | `""`              |
| certResolver          | defines the name of the Certificates Resolver to use. See also [Certificate Resolvers](https://doc.traefik.io/traefik/v3.1/https/acme/#certificate-resolvers)            | `""`              |
| domains               | list of domains for which the certificate should be valid                                                                                                                | `[]`              |
| passthrough           | only for ingressroutesTCP. Defines whether to enable passthrough mode for the TLS connection                                                                             | `false`           |

### Middlewares, MiddlewaresTCP parameters

`middlewares`, `middlewaresTCP` are maps of Middleware parameters, where key is a name

| Name            | Description                                                                                                                | Value           |
|-----------------|----------------------------------------------------------------------------------------------------------------------------|-----------------|
| spec            | Defines the specification for the Middleware. See also [Middlewares](https://doc.traefik.io/traefik/middlewares/overview)  | `{}`            |

### ServersTransport, ServersTransportTCP parameters

`ServersTransport`, `ServersTransportTCP` are maps of ServersTransport parameters, where key is a name

| Name            | Description                                                                                                                                                              | Value           |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| spec            | Defines the specification for the ServersTransport. See also [ServersTransport](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/#kind-serverstransport)  | `{}`            |

### TraefikServices parameters

`traefikservices` is a map of TraefikService parameters, where key is a name

| Name            | Description                                                                                                                                                         | Value           |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| spec            | Defines the specification for the TraefikService. See also [TraefikServices](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/#kind-traefikservice)  | `{}`            |

### TLSOptions parameters

`TLSOptions` is a map of TLSOption parameters, where key is a name

| Name             | Description                                                                                                                                                        | Value           |
|------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| minVersion       | defines the [minimum TLS version](https://doc.traefik.io/traefik/https/tls/#minimum-tls-version) that is acceptable                                                | `""`            |
| maxVersion       | defines the [maximum TLS version](https://doc.traefik.io/traefik/https/tls/#maximum-tls-version) that is acceptable                                                | `""`            |
| curvePreferences | list of the [elliptic curves references](https://doc.traefik.io/traefik/https/tls/#curve-preferences) that will be used in an ECDHE handshake, in preference order | `[]`            |
| cipherSuites     | list of supported [cipher suites](https://doc.traefik.io/traefik/https/tls/#cipher-suites) for TLS versions up to TLS 1.2                                          | `[]`            |
| clientAuth       | determines the server's policy for TLS [Client Authentication](https://doc.traefik.io/traefik/https/tls/#client-authentication-mtls)                               | `{}`            |
| sniStrict        | if true, Traefik won't allow connections from clients connections that do not specify a server_name extension                                                      | `false`         |
| alpnProtocols    | list of supported [application level protocols](https://doc.traefik.io/traefik/https/tls/#alpn-protocols) for the TLS handshake, in order of preference            | `[]`            |

### TLSStores parameters

`TLSStores` is a map of TLSStore parameters, where key is a name

| Name                          | Description                                                                                     | Value           |
|-------------------------------|-------------------------------------------------------------------------------------------------|-----------------|
| certificates                  | list of Kubernetes Secrets, each of them holding a key/certificate pair to add to the store     | `[]`            |
| certificates.secretName       | name of the secret containing the certificate                                                   | `""`            |
| defaultCertificate            | name of a Kubernetes Secret that holds the default key/certificate pair for the store           | `{}`            |
| defaultCertificate.secretName | name of the secret containing the default certificate                                           | `""`            |
| defaultGeneratedCert          | defines the default generated certificate settings for the TLSStore                             | `{}`            |

### Gateways parameters

`istiogateways` is a map of Gateway parameters, where key is a name

See more [Gateways](https://preliminary.istio.io/latest/docs/reference/config/networking/gateway/#Gateway)

| Name              | Description                                                                                                   | Value           |
|-------------------|---------------------------------------------------------------------------------------------------------------|-----------------|
| labels            | labels to apply                                                                                               | `{}`            |
| annotations       | annotations to apply                                                                                          | `{}`            |
| selector          | one or more labels that indicate a specific set of pods on which this gateway configuration should be applied | `{}`            |
| servers           | a list of server specifications. [Servers](#istiogateways-servers-object-parameters) object                   | `[]`            |

### Gateways `servers` object parameters

See more [Server](https://preliminary.istio.io/latest/docs/reference/config/networking/gateway/#Server)

| Name          | Description                                                                                            | Value           |
|---------------|--------------------------------------------------------------------------------------------------------|-----------------|
| hosts         | one or more hosts exposed by this gateway                                                              | `[]`            |
| port.name     | label assigned to the port                                                                             | `""`            |
| port.number   | a valid non-negative integer port number                                                               | `""`            |
| port.protocol | the protocol exposed on the port (`HTTP`, `HTTPS`, `GRPC`, `GRPC-WEB`, `HTTP2`, `MONGO`, `TCP`, `TLS`) | `""`            |
| tls           | set of TLS related options that govern the server’s behavior                                           | `{}`            |

### VirtualServices parameters

`istiovirtualservices` is a map of VirtualService paramaters, where key is a name

See more [VirtualServices](https://preliminary.istio.io/latest/docs/reference/config/networking/virtual-service/#VirtualService)

| Name                  | Description                                                                                                                | Value           |
|-----------------------|----------------------------------------------------------------------------------------------------------------------------|-----------------|
| labels           | labels to apply                                                                                                                 | `{}`            |
| annotations      | annotations to apply                                                                                                            | `{}`            |
| hosts            | the destination hosts to which traffic is being sent                                                                            | `[]`            |
| gateways         | the names of gateways and sidecars that should apply these routes                                                               | `[]`            |
| http             | an ordered list of route rules for HTTP traffic. [HTTP](#istiovirtualservices-http-object-parameters) object                    | `[]`            |
| tls              | an ordered list of route rule for non-terminated TLS & HTTPS traffic. [TLS](#istiovirtualservices-tls-object-parameters) object | `[]`            |
| tcp              | an ordered list of route rules for opaque TCP traffic                                                                           | `[]`            |
| exportTo         | a list of namespaces to which this virtual service is exported                                                                  | `[]`            |

### VirtualServices `http` object parameters

See more [HTTPRoute](https://preliminary.istio.io/latest/docs/reference/config/networking/virtual-service/#HTTPRoute)

| Name        | Description                                                                                     | Value           |
|-------------|-------------------------------------------------------------------------------------------------|-----------------|
| name        | the name assigned to the route for debugging purposes                                           | `""`            |
| match       | match conditions to be satisfied for the rule to be activated                                   | `[]`            |
| route       | a HTTP rule can either return a direct_response, redirect or forward (default) traffic          | `[]`            |
| retries     | retry policy for HTTP requests                                                                  | `{}`            |
| fault       | fault injection policy to apply on HTTP traffic at the client side                              | `{}`            |
| timeout     | timeout for HTTP requests, default is disabled                                                  | `""`            |
| rewrite     | rewrite HTTP URIs and Authority headers                                                         | `{}`            |
| corsPolicy  | Cross-Origin Resource Sharing policy (CORS)                                                     | `{}`            |

### VirtualServices `tls` object parameters

See more [TLSRoute](https://preliminary.istio.io/latest/docs/reference/config/networking/virtual-service/#TLSRoute)

| Name         | Description                                                    | Value           |
|--------------|----------------------------------------------------------------|-----------------|
| match        | match conditions to be satisfied for the rule to be activated  | `[]`            |
| route        | the destination to which the connection should be forwarded to | `[]`            |

### DestinationRules parameters

`istiodestinationrules` is a map of DestinationRule parameters, where key is a name

See more [DestinationRules](https://preliminary.istio.io/latest/docs/reference/config/networking/destination-rule/#DestinationRule)

| Name                         | Description                                                                                                                                | Value           |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| labels                       | labels to apply                                                                                                                            | `{}`            |
| annotations                  | annotations to apply                                                                                                                       | `{}`            |
| host                         | the name of a service from the service registry                                                                                            | `""`            |
| trafficPolicy                | traffic policies to apply (load balancing policy, connection pool sizes, outlier detection)                                                | `{}`            |
| subsets                      | one or more named sets that represent individual versions of a service. [Subsets](#istiodestinationrules-subsets-object-parameters) object | `[]`            |
| exportTo                     | a  list of namespaces to which this destination rule is exported                                                                           | `[]`            |
| workloadSelector             | criteria used to select the specific set of pods/VMs on which this DestinationRule configuration should be applied. [WorkloadSelector](#istiodestinationrules-workloadselector-object-parameters) object | `{}`            |

### DestinationRules `subsets` object parameters

See more [Subset](https://preliminary.istio.io/latest/docs/reference/config/networking/destination-rule/#Subset)

| Name                 | Description                                                                   | Value           |
|----------------------|-------------------------------------------------------------------------------|-----------------|
| name                 | name of the subset                                                            | `""`            |
| labels               | labels apply a filter over the endpoints of a service in the service registry | `{}`            |
| trafficPolicy        | traffic policies that apply to this subset                                    | `{}`            |

### DestinationRules `workloadSelector` object parameters

See more [Workload Selector](https://preliminary.istio.io/latest/docs/reference/config/type/workload-selector/#WorkloadSelector)

| Name         | Description                                                                                 | Value           |
|--------------|---------------------------------------------------------------------------------------------|-----------------|
| matchLabels  | one or more labels that indicate a specific set of pods on which a policy should be applied | `{}`            |

## Roadmap

Following features are already in backlog for our development team and will be done soon:

* Test operability on newer versions of Kubernetes/OpenShift.
* Support for more Pod scheduling options: PodTopologySpread.
* Support for attaching PV and assigning PVC to it.
* Disabling predefined blocks, which are enabled by default.
* Support for popular CRDs, e.g. cert-manager.
* Helm unit-testing.

## Feedback

For support and feedback please contact me:

* telegram: @remelyanov95
* email: r.emelyanov@nixys.io

For news and discussions subscribe the channels:
- telegram community (news): [@nxs_universal_chart](https://t.me/nxs_universal_chart)
- telegram community (chat): [@nxs_universal_chart_chat](https://t.me/nxs_universal_chart_chat)

## License

nxs-universal-chart is released under the [Apache License 2.0](LICENSE).
