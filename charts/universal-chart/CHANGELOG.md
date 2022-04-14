# Changelog

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
