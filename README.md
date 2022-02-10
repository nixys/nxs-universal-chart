# Nixys common Helm chart

## TL;DR

```bash
$ helm repo add nixys https://registry.nixys.ru/chartrepo/public
$ helm install my-release nixys/nxs-helm-chart
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release nixys/nxs-helm-chart -f values.yaml
```

The command deploys your app with custom values on the Kubernetes cluster. The [Parameters](#parameters) section lists
the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

# Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                              | Value |
|---------------------------|----------------------------------------------------------|-------|
| `global.kubeVersion`      | Global Override Kubernetes version                       | `""`  |

### Generic parameters

| Name                          | Description                                                | Value |
|-------------------------------|------------------------------------------------------------|-------|
| `generic.labels`              | Labels to add to all deployed objects                      | `{}`  |
| `generic.annotations`         | Annotations to add to all deployed objects                 | `{}`  |
| `generic.extraSelectorLabels` | SelectorLabels to add to deployments and services          | `{}`  |
| `generic.podLabels`           | Labels to add to all deployed pods                         | `{}`  |
| `generic.podAnnotations`      | Annotations to add to all deployed pods                    | `{}`  |
| `generic.serviceAccountName`  |                                                            | `[]`  |
| `generic.hostAliases`         |                                                            | `[]`  |
| `generic.dnsPolicy`           |                                                            | `[]`  |
| `generic.extraVolumes`        | Array of k8s Volumes to add to all deployed workloads      | `[]`  |
| `generic.extraVolumeMounts`   | Array of k8s VolumeMounts to add to all deployed workloads | `[]`  |

### Common parameters

| Name                        | Description                                                                                                   | Value          |
|-----------------------------|---------------------------------------------------------------------------------------------------------------|----------------|
| `kubeVersion`               | Override Kubernetes version                                                                                   | `""`           |
| `nameOverride`              | String to override release name                                                                               | `""`           |
| `envs`                      | Map of environment variables which will be deplyed as ConfigMap with name `RELEASE_NAME-envs`                 | `{}`           |
| `envsString`                | String with map of environment variables which will be deplyed as ConfigMap with name `RELEASE_NAME-envs`     | `""`           |
| `secretEnvs`                | Map of environment variables which will be deplyed as Secret with name `RELEASE_NAME-secret-envs`             | `{}`           |
| `secretEnvsString`          | String with map of environment variables which will be deplyed as Secret with name `RELEASE_NAME-secret-envs` | `""`           |
| `imagePullSecrets`          | Map of registry secrets in `.dockerconfigjson` format                                                         | `{}`           |
| `defaultImage`              | Docker image that will be used by default                                                                     | `[]`           |
| `defaultImageTag`           | Docker image tag that will be used by default                                                                 | `[]`           |
| `podAffinityPreset`         | Pod affinity preset. Ignored if workload `affinity` is set. Allowed values: `soft` or `hard`                  | `soft`         |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if workload `affinity` is set. Allowed values: `soft` or `hard`             | `soft`         |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if workload `affinity` is set. Allowed values: `soft` or `hard`            | `""`           |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if workload `affinity` is set                                                | `""`           |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if workload `affinity` is set                                             | `[]`           |
| `extraDeploy`               | Array of extra objects to deploy with the release                                                             | `[]`           |
| `diagnosticMode.enabled`    | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                       | `false`        |
| `diagnosticMode.command`    | Command to override all containers in the deployment                                                          | `["sleep"]`    |
| `diagnosticMode.args`       | Args to override all containers in the deployment                                                             | `["infinity"]` |

### Deployments parameters

`deploymentsGeneral` is a map of the deployments parameters, which uses for all deployments

| Name                                   | Description                                         | Value |
|----------------------------------------|-----------------------------------------------------|-------|
| `deploymentsGeneral.extraVolumes`      | Array of k8s Volumes to add to all deployments      | `[]`  |
| `deploymentsGeneral.extraVolumeMounts` | Array of k8s VolumeMounts to add to all deployments | `[]`  |

`deployments` is a map of the deployments parameters, where key is a name of deployment.

| Name                            | Description                                               | Value |
|---------------------------------|-----------------------------------------------------------|-------|
| `labels`                        | Extra labels for deployment                               | `{}`  |
| `annotations`                   | Extra annotations for deployment                          | `{}`  |
| `replicas`                      | Deployment replicas count                                 | `1`   |
| `strategy`                      | Deployment strategy                                       | `{}`  |
| `extraSelectorLabels`           | Extra selectorLabels for deployment                       | `{}`  |
| `podLabels`                     | Extra pod labels for deployment                           | `{}`  |
| `podAnnotations`                | Extra pod annotations for deployment                      | `{}`  |
| `serviceAccountName`            | The name of the ServiceAccount to use by deployment       | `""`  |
| `hostAliases`                   | Pods host aliases                                         | `[]`  |
| `affinity`                      | Affinity for deployment; replicas pods assignment         | `{}`  |
| `dnsPolicy`                     | DnsPolicy for deployment pods                             | `""`  |
| `nodeSelector`                  | Node labels for deployment; pods assignment               | `{}`  |
| `tolerations`                   | Tolerations for deployment; replicas pods assignment      | `[]`  |
| `imagePullSecrets`              | Docker registry secret names as an array                  | `[]`  |
| `terminationGracePeriodSeconds` | Integer setting the termination grace period for the pods | `30`  |
| `initContainers`                | Array of the deployment init containers                   | `[]`  |
| `containers`                    | Array of the deployment containers                        | `[]`  |
| `volumes`                       | Array of the deployment typed volumes                     | `[]`  |
| `extraVolumes`                  | Array of k8s Volumes to add to deployments                | `[]`  |

| Name                                      | Description                           | Value            |
|-------------------------------------------|---------------------------------------|------------------|
| `initContainers.name`                     | The name of the initContainer         | `""`             |
| `initContainers.image`                    | Docker image of the initContainer     | `""`             |
| `initContainers.imageTag`                 | Docker image tag of the initContainer | `"latest"`       |
| `initContainers.imagePullPolicy`          | Docker image pull policy              | `"IfNotPresent"` |
| `initContainers.containerSecurityContext` | Security Context for initContainer    | `{}`             |
| `initContainers.command`                  | InitContainer command override        | `[]`             |
| `initContainers.args`                     | InitContainer arguments override      | `[]`             |
| `initContainers.envsFromConfigmap`        |                                       | `{}`             |
| `initContainers.envsFromSecret`           |                                       | `{}`             |
| `initContainers.env`                      |                                       | `{}`             |
| `initContainers.envConfigmaps`            |                                       | `{}`             |
| `initContainers.envSecrets`               |                                       | `{}`             |
| `initContainers.envFrom`                  |                                       | `{}`             |
| `initContainers.ports`                    |                                       | `{}`             |
| `initContainers.lifecycle`                |                                       | `{}`             |
| `initContainers.livenessProbe`            |                                       | `{}`             |
| `initContainers.readinessProbe`           |                                       | `{}`             |
| `initContainers.resources`                |                                       | `{}`             |
| `initContainers.volumeMounts`             |                                       | `{}`             |
| `initContainers.extraVolumeMounts`        |                                       | `{}`             |

| Name                                  | Description                       | Value            |
|---------------------------------------|-----------------------------------|------------------|
| `containers.name`                     | The name of the container         | `""`             |
| `containers.image`                    | Docker image of the container     | `""`             |
| `containers.imageTag`                 | Docker image tag of the container | `"latest"`       |
| `containers.imagePullPolicy`          | Docker image pull policy          | `"IfNotPresent"` |
| `containers.containerSecurityContext` | Security Context for container    | `{}`             |
| `containers.command`                  | Container command override        | `{}`             |
| `containers.args`                     | Container arguments override      | `{}`             |
| `containers.envsFromConfigmap`        |                                   | `{}`             |
| `containers.envsFromSecret`           |                                   | `{}`             |
| `containers.env`                      |                                   | `{}`             |
| `containers.envConfigmaps`            |                                   | `{}`             |
| `containers.envSecrets`               |                                   | `{}`             |
| `containers.envFrom`                  |                                   | `{}`             |
| `containers.ports`                    |                                   | `{}`             |
| `containers.lifecycle`                |                                   | `{}`             |
| `containers.livenessProbe`            |                                   | `{}`             |
| `containers.readinessProbe`           |                                   | `{}`             |
| `containers.resources`                |                                   | `{}`             |
| `containers.volumeMounts`             |                                   | `{}`             |
| `containers.extraVolumeMounts`        |                                   | `{}`             |

### Services parameters

### Secrets parameters

### ConfigMaps parameters

### PersistentVolumeClaims parameters

### Hooks parameters

### Jobs parameters

### CronJobs parameters

### ServiceMonitors parameters

## Volumes

### .volumes

На уровне workload

```yaml
  volumes:
  - name: secret-file
    type: secret
  - name: app-config
    type: configMap
  - name: app-pvc
    type: pvc
    nameOverride: some-name-of-the-resource
```