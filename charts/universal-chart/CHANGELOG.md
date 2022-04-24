# Changelog
## 3.1.0 - April 24, 2022

* feat: add PDB support and tests

## 3.0.4 - April 15, 2022

* Fix Helm hooks custom annotations
* Fix Service nodePort
* Removed helm hooks annotations for PVC

## 3.0.3 - April 14, 2022

* fix: nindent in securityContext:

## 3.0.2 - April 14, 2022

* fix: typos in podSecurityContext/containerSecurityContext

## 3.0.1 - April 14, 2022

* technical release without changes

## 3.0.0 - April 14, 2022

* `jobs`, `cronJobs` and `servicemonitors` now is maps, where key is a name

## 2.0.1 - April 8, 2022

* quote integer/float values in configmaps

## 2.0.0 - April 3, 2022

* `hooks` is a map of the Helm Hooks Jobs parameters, where key is a name of job.

## 1.1.0 - April 3, 2022

* feat: `defaultImagePullPolicy`
* fix: make sure that hook-weight is string

## 1.0.1 - April 3, 2022

* fix typo: `diagnosticMode.enbled` -> `diagnosticMode.enabled`
* fix command: usage in `jobs.containers`
* fix servicemonitor's selector rendering
* add yamllint config
