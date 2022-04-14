# Nixys universal Helm chart

## TL;DR

```bash
$ helm repo add evgkrsk-universal-chart https://evgkrsk.github.io/nxs-universal-chart
$ helm install my-release evgkrsk-universal-chart/universal-chart
```

Use the `--devel` flag to access release candidate versions.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release evgkrsk-universal-chart/universal-chart -f values.yaml
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
| `generic.serviceAccountName`  | The name of the ServiceAccount to use by workload          | `[]`  |
| `generic.hostAliases`         | Pods host aliases to use by workload                       | `[]`  |
| `generic.dnsPolicy`           | DnsPolicy for workload pods                                | `[]`  |
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
| `defaultImagePullPolicy`    | Docker image pull policy that will be used by default                                                         |`"IfNotPresent"`|
| `podAffinityPreset`         | Pod affinity preset. Ignored if workload `affinity` is set. Allowed values: `soft` or `hard`                  | `soft`         |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if workload `affinity` is set. Allowed values: `soft` or `hard`             | `soft`         |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if workload `affinity` is set. Allowed values: `soft` or `hard`            | `""`           |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if workload `affinity` is set                                                | `""`           |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if workload `affinity` is set                                             | `[]`           |
| `extraDeploy`               | Array of extra objects to deploy with the release                                                             | `[]`           |
| `diagnosticMode.enabled`    | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                       | `false`        |
| `diagnosticMode.command`    | Command to override all containers in the deployment                                                          | `["sleep"]`    |
| `diagnosticMode.args`       | Args to override all containers in the deployment                                                             | `["infinity"]` |
| `releasePrefix`             | Override prefix for all manifests names. Release name used by default. You should use `"-"` to make it empty. | `""`           |

### Deployments parameters

`deploymentsGeneral` is a map of the deployments parameters, which uses for all deployments

| Name                                   | Description                                         | Value |
|----------------------------------------|-----------------------------------------------------|-------|
| `deploymentsGeneral.labels`            | Labels to add to all deployments                    | `{}`  |
| `deploymentsGeneral.annotations`       | Annotations to add to all deployments               | `{}`  |
| `deploymentsGeneral.extraVolumes`      | Array of k8s Volumes to add to all deployments      | `[]`  |
| `deploymentsGeneral.extraVolumeMounts` | Array of k8s VolumeMounts to add to all deployments | `[]`  |

`deployments` is a map of the deployment parameters, where key is a name of deployment.

| Name                            | Description                                                                                | Value |
|---------------------------------|--------------------------------------------------------------------------------------------|-------|
| `labels`                        | Extra labels for deployment                                                                | `{}`  |
| `annotations`                   | Extra annotations for deployment                                                           | `{}`  |
| `replicas`                      | Deployment replicas count                                                                  | `1`   |
| `strategy`                      | Deployment strategy                                                                        | `{}`  |
| `extraSelectorLabels`           | Extra selectorLabels for deployment                                                        | `{}`  |
| `podLabels`                     | Extra pod labels for deployment                                                            | `{}`  |
| `podAnnotations`                | Extra pod annotations for deployment                                                       | `{}`  |
| `serviceAccountName`            | The name of the ServiceAccount to use by deployment                                        | `""`  |
| `hostAliases`                   | Pods host aliases                                                                          | `[]`  |
| `affinity`                      | Affinity for deployment; replicas pods assignment                                          | `{}`  |
| `podSecurityContext`            | Security Context for deployment pods                                                       | `{}`  |
| `dnsPolicy`                     | DnsPolicy for deployment pods                                                              | `""`  |
| `nodeSelector`                  | Node labels for deployment; pods assignment                                                | `{}`  |
| `tolerations`                   | Tolerations for deployment; replicas pods assignment                                       | `[]`  |
| `imagePullSecrets`              | Docker registry secret names as an array                                                   | `[]`  |
| `terminationGracePeriodSeconds` | Integer setting the termination grace period for the pods                                  | `30`  |
| `initContainers`                | Array of the deployment initContainers ([container](#container-object-parameters) objects) | `[]`  |
| `containers`                    | Array of the deployment Containers ([container](#container-object-parameters) objects)     | `[]`  |
| `volumes`                       | Array of the deployment typed [volume](#typed-volumes-parameters) objects                  | `[]`  |
| `extraVolumes`                  | Array of k8s Volumes to add to deployments                                                 | `[]`  |

#### Container object parameters

| Name                       | Description                                                           | Value            |
|----------------------------|-----------------------------------------------------------------------|------------------|
| `name`                     | The name of the container                                             | `""`             |
| `image`                    | Docker image of the container                                         | `""`             |
| `imageTag`                 | Docker image tag of the container                                     | `"latest"`       |
| `imagePullPolicy`          | Docker image pull policy                                              | `"IfNotPresent"` |
| `containerSecurityContext` | Security Context for container                                        | `{}`             |
| `command`                  | Container command override (list or string)                           | `[]`             |
| `commandMaxDuration`       | Duration of command execution (for jobs and cronJobs only)            | ``               |
| `commandDurationAlert`     | Alert on command execution time exceeded (for jobs and cronJobs only) | ``               |
| `args`                     | Container arguments override                                          | `[]`             |
| `envsFromConfigmap`        | Map of ConfigMaps and envs from it                                    | `{}`             |
| `envsFromSecret`           | Map of Secrets and envs from it                                       | `{}`             |
| `env`                      | Array of extra environment variables                                  | `[]`             |
| `envConfigmaps`            | Array of Configmaps names with extra envs                             | `[]`             |
| `envSecrets`               | Array of Secrets names with extra envs                                | `[]`             |
| `envFrom`                  | Array of extra envFrom objects                                        | `[]`             |
| `ports`                    | Array of ports to be exposed from container                           | `[]`             |
| `lifecycle`                | Containers lifecycle hooks                                            | `{}`             |
| `livenessProbe`            | Liveness probe object for container                                   | `{}`             |
| `readinessProbe`           | Readiness probe object for container                                  | `{}`             |
| `resources`                | The resources requests and limits for container                       | `{}`             |
| `volumeMounts`             | Array of the volume mounts                                            | `[]`             |

### Services parameters

`services` is a map of the service parameters, where key is a name of service.

| Name                       | Description                                                           | Value       |
|----------------------------|-----------------------------------------------------------------------|-------------|
| `labels`                   | Extra labels for service                                              | `{}`        |
| `annotations`              | Extra annotations for service                                         | `{}`        |
| `type`                     | Type of a service                                                     | `""`        |
| `loadBalancerIP`           | IP of a service with LoadBalancer type                                | `""`        |
| `loadBalancerSourceRanges` | Service Load Balancer sources                                         | `[]`        |
| `externalTrafficPolicy`    | Service external traffic policy                                       | `"Cluster"` |
| `healthCheckNodePort`      | Health check node port (numeric port number) for the service          | ``          |
| `externalIPs`              | Array of the external IPs that route to one or more cluster nodes     | `[]`        | 
| `ports`                    | Array of the service [port](#service-ports-object-parameters) objects | `[]`        | 
| `extraSelectorLabels`      | Extra selectorLabels for select workload                              | `{}`        | 

#### Service `ports` object parameters:

| Name         | Description                  | Value   |
|--------------|------------------------------|---------|
| `name`       | Name of the service port     | `""`    | 
| `protocol`   | Protocol of the service port | `"TCP"` | 
| `port`       | Service port number          | ``      | 
| `targetPort` | Service target port number   | ``      | 

### Ingresses parameters

`ingresses` is a map of the ingress parameters, where key is a hostname (domain) of ingress.

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

### Ingress `hosts` object parameters

| Name       | Description                                                            | Value |
|------------|------------------------------------------------------------------------|-------|
| `hostname` | Hostname to serve by ingress, if empty ingress hostname will be used   | `""`  |
| `paths`    | Array of the ingress [paths](#ingress-paths-object-parameters) objects | `[]`  |

### Ingress `paths` object parameters


| Name          | Description                                                                                                             | Value |
|---------------|-------------------------------------------------------------------------------------------------------------------------|-------|
| `path`        | URL path                                                                                                                | `"/"` |
| `pathType`    | Type of the ingress path [see for details](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types) | `[]`  |
| `serviceName` | Name of the service to route requests                                                                                   | `""`  |
| `servicePort` | Name or number of the service port to route requests                                                                    | `""`  |

### Secrets parameters

`secrets` is a map of the secret parameters, where key is a name of secret.

| Name               | Description                                  | Value      |
|--------------------|----------------------------------------------|------------|
| `type`             | Secret type                                  | `"Opaque"` | 
| `labels`           | Extra secret labels                          | `{}`       | 
| `annotations`      | Extra secret annotations                     | `{}`       | 
| `data`             | Map of Secret data                           | `{}`       | 

Secret `data` object is a map where value can be a string, json or base64 encoded string with prefix `b64:`.

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
| `storageClassName` | Persistent Volume Storage Class name                 | `""`           | 
| `selector`         | Labels selector to further filter the set of volumes | `{}`           | 

### Hooks parameters

`hooksGeneral` is a map of the Helm Hooks Jobs parameters, which uses for all Helm Hooks Jobs.

| Name                                   | Description                                                                             | Value |
|----------------------------------------|-----------------------------------------------------------------------------------------|-------|
| `hooksGeneral.labels`                  | Extra labels for all Hook Job                                                           | `{}`  |
| `hooksGeneral.annotations`             | Extra annotations for all Hook Job                                                      | `{}`  |
| `hooksGeneral.parallelism`             | How much Jobs can be run in parallel (ignored if defined on Hook level)                 | `1`   | 
| `hooksGeneral.completions`             | How much Pods should finish to finish Job (ignored if defined on Hook level)            | `1`   | 
| `hooksGeneral.activeDeadlineSeconds`   | Duration of the Job (ignored if defined on Hook level)                                  | `100` | 
| `hooksGeneral.backoffLimit`            | Number of retries before considering a Job as failed (ignored if defined on Hook level) | `6`   | 
| `hooksGeneral.ttlSecondsAfterFinished` | TTL for delete finished Hook Job (ignored if defined on Hook level)                     | `100` | 
| `hooksGeneral.podLabels`               | Extra pod labels for Hook Job (ignored if defined on Hook level)                        | `{}`  |
| `hooksGeneral.podAnnotations`          | Extra pod annotations for Hook Job (ignored if defined on Hook level)                   | `{}`  |
| `hooksGeneral.serviceAccountName`      | The name of the ServiceAccount to use by Hook Job (ignored if defined on Hook level)    | `""`  |
| `hooksGeneral.hostAliases`             | Pods host aliases (ignored if defined on Hook level)                                    | `[]`  |
| `hooksGeneral.affinity`                | Affinity for Hook Job; replicas pods assignment (ignored if defined on Hook level)      | `{}`  |
| `hooksGeneral.dnsPolicy`               | DnsPolicy for Hook Job pods (ignored if defined on Hook level)                          | `""`  |

`hooks` is a map of the Helm Hooks Jobs parameters, where key is a name of hook.

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
| `podSecurityContext`      | Security Context for Hook Job pods                                                       | `{}`                        |
| `dnsPolicy`               | DnsPolicy for Hook Job pods                                                              | `""`                        |
| `nodeSelector`            | Node labels for Hook Job; pods assignment                                                | `{}`                        |
| `tolerations`             | Tolerations for Hook Job; replicas pods assignment                                       | `[]`                        |
| `imagePullSecrets`        | Docker registry secret names as an array                                                 | `[]`                        |
| `initContainers`          | Array of the Hook Job initContainers ([container](#container-object-parameters) objects) | `[]`                        |
| `containers`              | Array of the Hook Job Containers ([container](#container-object-parameters) objects)     | `[]`                        |
| `volumes`                 | Array of the Hook Job typed volumes                                                      | `[]`                        |
| `extraVolumes`            | Array of k8s Volumes to add to Hook Job                                                  | `[]`                        |
| `restartPolicy`           | Restart Policy of the Hook Job                                                           | `"Never"`                   |

### Jobs parameters

`jobsGeneral` is a map of the Jobs parameters, which uses for all Jobs.

| Name                                  | Description                                                                            | Value |
|---------------------------------------|----------------------------------------------------------------------------------------|-------|
| `jobsGeneral.labels`                  | Extra labels for all Job                                                               | `{}`  |
| `jobsGeneral.annotations`             | Extra annotations for all Job                                                          | `{}`  |
| `jobsGeneral.parallelism`             | How much Jobs can be run in parallel (ignored if defined on Job level)                 | `1`   | 
| `jobsGeneral.completions`             | How much Pods should finish to finish Job (ignored if defined on Job level)            | `1`   | 
| `jobsGeneral.activeDeadlineSeconds`   | Duration of the Job (ignored if defined on Job level)                                  | `100` | 
| `jobsGeneral.backoffLimit`            | Number of retries before considering a Job as failed (ignored if defined on Job level) | `6`   | 
| `jobsGeneral.ttlSecondsAfterFinished` | TTL for delete finished Job (ignored if defined on Job level)                          | `100` | 
| `jobsGeneral.podLabels`               | Extra pod labels for Job (ignored if defined on Job level)                             | `{}`  |
| `jobsGeneral.podAnnotations`          | Extra pod annotations for Job (ignored if defined on Job level)                        | `{}`  |
| `jobsGeneral.serviceAccountName`      | The name of the ServiceAccount to use by Job (ignored if defined on Job level)         | `""`  |
| `jobsGeneral.hostAliases`             | Pods host aliases (ignored if defined on Job level)                                    | `[]`  |
| `jobsGeneral.affinity`                | Affinity for Job; replicas pods assignment (ignored if defined on Job level)           | `{}`  |
| `jobsGeneral.dnsPolicy`               | DnsPolicy for Job pods (ignored if defined on Job level)                               | `""`  |

`jobs` is a map of the Jobs parameters, where key is a name of job.

| Name                      | Description                                                                              | Value     |
|---------------------------|------------------------------------------------------------------------------------------|-----------|
| `name`                    | Name of the Job                                                                          | `""`      | 
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
| `podSecurityContext`      | Security Context for Hook Job pods                                                       | `{}`      |
| `dnsPolicy`               | DnsPolicy for Hook Job pods                                                              | `""`      |
| `nodeSelector`            | Node labels for Hook Job; pods assignment                                                | `{}`      |
| `tolerations`             | Tolerations for Hook Job; replicas pods assignment                                       | `[]`      |
| `imagePullSecrets`        | Docker registry secret names as an array                                                 | `[]`      |
| `initContainers`          | Array of the Hook Job initContainers ([container](#container-object-parameters) objects) | `[]`      |
| `containers`              | Array of the Hook Job Containers ([container](#container-object-parameters) objects)     | `[]`      |
| `volumes`                 | Array of the Hook Job typed volumes                                                      | `[]`      |
| `extraVolumes`            | Array of k8s Volumes to add to Hook Job                                                  | `[]`      |
| `restartPolicy`           | Restart Policy of the Job                                                                | `"Never"` |

### CronJobs parameters

`cronJobsGeneral` is a map of the Jobs parameters, which uses for all Jobs.

| Name                                         | Description                                                                                | Value |
|----------------------------------------------|--------------------------------------------------------------------------------------------|-------|
| `cronJobsGeneral.labels`                     | Extra labels for all CronJobs                                                              | `{}`  |
| `cronJobsGeneral.annotations`                | Extra annotations for all CronJobs                                                         | `{}`  |
| `cronJobsGeneral.startingDeadlineSeconds`    | Duration for starting all CronJobs (ignored if defined on CronJob level)                   | ``    | 
| `cronJobsGeneral.successfulJobsHistoryLimit` | Limitation of completed jobs should be kept (ignored if defined on CronJob level)          | `3`   | 
| `cronJobsGeneral.failedJobsHistoryLimit`     | Limitation of failed jobs should be kept (ignored if defined on CronJob level)             | `1`   |
| `cronJobsGeneral.parallelism`                | How much pods of Job can be run in parallel (ignored if defined on CronJob level)          | `1`   | 
| `cronJobsGeneral.completions`                | How much pods should finish to finish Job (ignored if defined on CronJob level)            | `1`   | 
| `cronJobsGeneral.activeDeadlineSeconds`      | Duration of the Job (ignored if defined on CronJob level)                                  | `100` | 
| `cronJobsGeneral.backoffLimit`               | Number of retries before considering a Job as failed (ignored if defined on CronJob level) | `6`   | 
| `cronJobsGeneral.ttlSecondsAfterFinished`    | TTL for delete finished Jobs (ignored if defined on CronJob level)                         | `100` | 
| `cronJobsGeneral.podLabels`                  | Extra pod labels for CronJob (ignored if defined on CronJob level)                         | `{}`  |
| `cronJobsGeneral.podAnnotations`             | Extra pod annotations for CronJob (ignored if defined on CronJob level)                    | `{}`  |
| `cronJobsGeneral.serviceAccountName`         | The name of the ServiceAccount to use by Job (ignored if defined on CronJob level)         | `""`  |
| `cronJobsGeneral.hostAliases`                | Pods host aliases (ignored if defined on CronJob level)                                    | `[]`  |
| `cronJobsGeneral.affinity`                   | Affinity for CronJob; replicas pods assignment (ignored if defined on CronJob level)       | `{}`  |
| `cronJobsGeneral.dnsPolicy`                  | DnsPolicy for CronJob pods (ignored if defined on CronJob level)                           | `""`  |

`cronJobs` is a map of the Cronjobs parameters, where key is a name of cronjob.

| Name                         | Description                                                                             | Value     |
|------------------------------|-----------------------------------------------------------------------------------------|-----------|
| `name`                       | Name of the CronJob                                                                     | `""`      | 
| `labels`                     | Extra CronJob labels                                                                    | `{}`      | 
| `annotations`                | Extra CronJob annotations                                                               | `{}`      | 
| `singleOnly`                 | Forbid concurrency policy                                                               | `"false"` | 
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
| `podSecurityContext`         | Security Context for CronJob pods                                                       | `{}`      |
| `dnsPolicy`                  | DnsPolicy for CronJob pods                                                              | `""`      |
| `nodeSelector`               | Node labels for CronJob; pods assignment                                                | `{}`      |
| `tolerations`                | Tolerations for CronJob; replicas pods assignment                                       | `[]`      |
| `imagePullSecrets`           | Docker registry secret names as an array                                                | `[]`      |
| `initContainers`             | Array of the CronJob initContainers ([container](#container-object-parameters) objects) | `[]`      |
| `containers`                 | Array of the CronJob Containers ([container](#container-object-parameters) objects)     | `[]`      |
| `volumes`                    | Array of the CronJob typed volumes                                                      | `[]`      |
| `extraVolumes`               | Array of k8s Volumes to add to CronJob                                                  | `[]`      |
| `restartPolicy`              | Restart Policy of the Jobs                                                              | `"Never"` |

### ServiceMonitors parameters

`servicemonitors` is a map of the ServiceMonitor parameters, where key is a name.

| Name                  | Description                              | Value |
|-----------------------|------------------------------------------|-------|
| `labels`              | Extra ServiceMonitor labels              | `{}`  | 
| `endpoints`           | Array of ServiceMonitor endpoints        | `[]`  | 
| `extraSelectorLabels` | Extra selectorLabels for select workload | `{}`  | 

### typed Volumes parameters

| Name           | Description                                                | Value |
|----------------|------------------------------------------------------------|-------|
| `type`         | Resource type of the volume ("configMap","secret","pvc")   | `""`  | 
| `name`         | Name of the resource that will be used with release prefix | `""`  | 
| `originalName` | Original name of the resource                              | `""`  | 
| `items`        | Array of volume items                                      | `[]`  | 

## Configuration and installation details

### Using private registries

To use images from private registers, add your ".dockerauthconfig" to `imagePullSecrets` in the common block. This will
create secrets that include auth from the register and will be used in all workloads.

```yaml
imagePullSecrets:
  my-registry: |
    {"auths":{"registry.org":{"auth":"cnd1c2VyOnNlY3VyZVBANXM="}}}
  some-private-hub: b64:eyJhdXRocyI6eyJyZWdpc3RyeS5vcmciOnsiYXV0aCI6ImNuZDFjMlZ5T25ObFkzVnlaVkJBTlhNPSJ9fX0=
```

If a secret with auth was added earlier, you can use `imagePullSecrets` directly in the workload as in the k8s manifest
by specifying the name of the corresponding secret.

```yaml
deployments:
  my-app:
    ...
    imagePullSecrets:
    - name: my-registry-secret-name
    ...
```

## Additional features

### Secrets features

Working with the secrets data you can use values with the next types

* string - usual string values will be encoded to base64 string
* base64 encoded string with `b64:` prefix - value will be used as is without prefix
* json - json will be encoded to base64 string

#### Secret from string

Values file:

```yaml
secrets:
  secret-file:
    data:
      api.key: "JFczZwReBkJFczZwReBkJFczZwReBkJFczZwReBk"
  extra-envs:
    data:
      BAR: foo
```

`--set` analog:

```bash
--set "secrets.secret-file.data.api\.key=$SOME_ENV_WITH_STRING"
--set "secrets.extra-envs.data.BAR=foo"
```

#### Secret from base64 encoded string

Values file:

```yaml
secrets:
  secret-file:
    data:
      api.key: "b64:SkZjelp3UmVCa0pGY3pad1JlQmtKRmN6WndSZUJrSkZjelp3UmVCaw=="
```

`--set` analog:

```bash
--set "secrets.secret-file.data.api\.key=b64:$(echo -n $SOME_ENV|base64 -w0)"
```

#### Secret from json

Values file:

```yaml
secrets:
  json-file:
    data:
      file.json: {
        "arg": "value"
      }
```

`--set` analog:

```bash
--set "secrets.json-file.data.file\.json=$(printf %q $(cat file.json))"
```

or

```bash
--set-file "secrets.json-file.data.file\.json=path/to/file.json"
```
