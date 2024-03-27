# Changelog
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
