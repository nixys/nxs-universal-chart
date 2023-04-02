# Changelog

## 2.1.13 - Apr 2, 2023
* fix: disables adding hook annotations on all configmaps and secrets by default (you can setup it when you really need it, see a note `values.yaml` in parameter `generic.hookAnnotations`):
  * `helm.sh/hook: "pre-install,pre-upgrade"`
  * `helm.sh/hook-weight: "-999"`
  * `helm.sh/hook-delete-policy: before-hook-creation`

## 2.1.12 - Jan 22, 2023
* add emptyDir volume type

## 2.1.5 - Nov 19, 2022

* feature: add GitHub Actions
* feature: add enableAffinity param
* feature: add StatefulSet

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
