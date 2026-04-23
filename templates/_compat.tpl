{{/*
Compatibility overrides for the published nuc-common version referenced by this chart.
Remove these once the dependency includes the same fixes.
*/}}

{{- define "helpers.app.name" -}}
{{- $name := default .Release.Name .Values.nameOverride -}}
{{- if and .Values.generic (hasKey .Values.generic "fullnameOverride") .Values.generic.fullnameOverride -}}
{{- $name = include "helpers.tplvalues.render" (dict "value" .Values.generic.fullnameOverride "context" .) -}}
{{- end -}}
{{- if and .Values.generic (hasKey .Values.generic "nameSuffix") .Values.generic.nameSuffix -}}
{{- $name = printf "%s-%s" $name (include "helpers.tplvalues.render" (dict "value" .Values.generic.nameSuffix "context" .)) -}}
{{- end -}}
{{- $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "helpers.app.fullname" -}}
{{- if .name -}}
{{- if eq .context.Values.releasePrefix "-" -}}
{{- .name | trunc 63 | trimSuffix "-" -}}
{{- else if .context.Values.releasePrefix -}}
{{- printf "%s-%s" .context.Values.releasePrefix .name | trunc 63 | trimAll "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "helpers.app.name" .context) .name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- include "helpers.app.name" .context -}}
{{- end -}}
{{- end -}}

{{- define "helpers.app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "helpers.app.genericSelectorLabels" -}}
{{- if and $.Values.generic (hasKey $.Values.generic "extraSelectorLabels") -}}
{{- with $.Values.generic.extraSelectorLabels -}}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $) }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helpers.app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{ include "helpers.app.genericSelectorLabels" $ }}
{{- end -}}

{{- define "helpers.app.labels" -}}
{{ include "helpers.app.selectorLabels" . }}
helm.sh/chart: {{ include "helpers.app.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- if and .Values.generic (hasKey .Values.generic "labels") -}}
{{- with .Values.generic.labels }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $) }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.app.genericAnnotations" -}}
{{- if and .Values.generic (hasKey .Values.generic "annotations") -}}
{{- with .Values.generic.annotations }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $) }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Default hook annotations for generated ConfigMaps and Secrets.

Backward compatibility:
- if generic.hookAnnotations is not defined, keep the historical defaults
- if generic.hookAnnotations is defined as null, disable default hook annotations
*/}}
{{- define "helpers.app.defaultHookAnnotations" -}}
{{- $defaultHookAnnotations := dict "helm.sh/hook" "pre-install,pre-upgrade" "helm.sh/hook-weight" "-999" "helm.sh/hook-delete-policy" "before-hook-creation" -}}
{{- if and .Values.generic (hasKey .Values.generic "hookAnnotations") -}}
  {{- with .Values.generic.hookAnnotations }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $) }}
  {{- end -}}
{{- else -}}
{{ toYaml $defaultHookAnnotations }}
{{- end -}}
{{- end -}}

{{/*
Backward-compatible alias retained for older charts.
*/}}
{{- define "helpers.app.hooksAnnotations" -}}
{{- $ctx := .context | default . -}}
{{- include "helpers.app.defaultHookAnnotations" $ctx -}}
{{- end -}}

{{- define "helpers.app.gitopsLabels" -}}
{{- $ctx := .context -}}
{{- $general := .general | default dict -}}
{{- $value := .value | default dict -}}
{{- $labels := dict -}}
{{- $globalGitops := $ctx.Values.gitops | default dict -}}
{{- $generalGitops := get $general "gitops" | default dict -}}
{{- $valueGitops := get $value "gitops" | default dict -}}
{{- with (get $globalGitops "commonLabels") }}{{- $labels = mergeOverwrite $labels ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- with (get $generalGitops "commonLabels") }}{{- $labels = mergeOverwrite $labels ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- with (get $valueGitops "commonLabels") }}{{- $labels = mergeOverwrite $labels ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- $fluxEnabled := false -}}
{{- $globalFlux := get $globalGitops "flux" | default dict -}}
{{- $generalFlux := get $generalGitops "flux" | default dict -}}
{{- $valueFlux := get $valueGitops "flux" | default dict -}}
{{- if hasKey $globalFlux "enabled" }}{{- $fluxEnabled = $globalFlux.enabled -}}{{- end -}}
{{- if hasKey $generalFlux "enabled" }}{{- $fluxEnabled = $generalFlux.enabled -}}{{- end -}}
{{- if hasKey $valueFlux "enabled" }}{{- $fluxEnabled = $valueFlux.enabled -}}{{- end -}}
{{- if $fluxEnabled -}}
{{- with (get $globalFlux "labels") }}{{- $labels = mergeOverwrite $labels ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- with (get $generalFlux "labels") }}{{- $labels = mergeOverwrite $labels ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- with (get $valueFlux "labels") }}{{- $labels = mergeOverwrite $labels ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- end -}}
{{- if $labels }}{{ toYaml $labels }}{{- end -}}
{{- end -}}

{{- define "helpers.app.gitopsAnnotations" -}}
{{- $ctx := .context -}}
{{- $general := .general | default dict -}}
{{- $value := .value | default dict -}}
{{- $annotations := dict -}}
{{- $globalGitops := $ctx.Values.gitops | default dict -}}
{{- $generalGitops := get $general "gitops" | default dict -}}
{{- $valueGitops := get $value "gitops" | default dict -}}
{{- with (get $globalGitops "commonAnnotations") }}{{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- with (get $generalGitops "commonAnnotations") }}{{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- with (get $valueGitops "commonAnnotations") }}{{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- $argoEnabled := false -}}
{{- $syncWave := "" -}}
{{- $syncOptions := list -}}
{{- $compareOptions := list -}}
{{- $globalArgo := get $globalGitops "argo" | default dict -}}
{{- $generalArgo := get $generalGitops "argo" | default dict -}}
{{- $valueArgo := get $valueGitops "argo" | default dict -}}
{{- if hasKey $globalArgo "enabled" }}{{- $argoEnabled = $globalArgo.enabled -}}{{- end -}}
{{- if hasKey $generalArgo "enabled" }}{{- $argoEnabled = $generalArgo.enabled -}}{{- end -}}
{{- if hasKey $valueArgo "enabled" }}{{- $argoEnabled = $valueArgo.enabled -}}{{- end -}}
{{- if hasKey $globalArgo "syncWave" }}{{- $syncWave = get $globalArgo "syncWave" -}}{{- end -}}
{{- if hasKey $generalArgo "syncWave" }}{{- $syncWave = get $generalArgo "syncWave" -}}{{- end -}}
{{- if hasKey $valueArgo "syncWave" }}{{- $syncWave = get $valueArgo "syncWave" -}}{{- end -}}
{{- if hasKey $globalArgo "syncOptions" }}{{- $syncOptions = get $globalArgo "syncOptions" | default list -}}{{- end -}}
{{- if hasKey $generalArgo "syncOptions" }}{{- $syncOptions = get $generalArgo "syncOptions" | default list -}}{{- end -}}
{{- if hasKey $valueArgo "syncOptions" }}{{- $syncOptions = get $valueArgo "syncOptions" | default list -}}{{- end -}}
{{- if hasKey $globalArgo "compareOptions" }}{{- $compareOptions = get $globalArgo "compareOptions" | default list -}}{{- end -}}
{{- if hasKey $generalArgo "compareOptions" }}{{- $compareOptions = get $generalArgo "compareOptions" | default list -}}{{- end -}}
{{- if hasKey $valueArgo "compareOptions" }}{{- $compareOptions = get $valueArgo "compareOptions" | default list -}}{{- end -}}
{{- if $argoEnabled -}}
{{- with $syncWave }}{{- $_ := set $annotations "argocd.argoproj.io/sync-wave" (include "helpers.tplvalues.render" (dict "value" . "context" $ctx)) -}}{{- end -}}
{{- if $syncOptions }}
{{- $renderedSyncOptions := fromYamlArray (include "helpers.tplvalues.render" (dict "value" $syncOptions "context" $ctx)) | default list -}}
{{- $_ := set $annotations "argocd.argoproj.io/sync-options" (join "," $renderedSyncOptions) -}}
{{- end -}}
{{- if $compareOptions }}
{{- $renderedCompareOptions := fromYamlArray (include "helpers.tplvalues.render" (dict "value" $compareOptions "context" $ctx)) | default list -}}
{{- $_ := set $annotations "argocd.argoproj.io/compare-options" (join "," $renderedCompareOptions) -}}
{{- end -}}
{{- end -}}
{{- $fluxEnabled := false -}}
{{- $globalFlux := get $globalGitops "flux" | default dict -}}
{{- $generalFlux := get $generalGitops "flux" | default dict -}}
{{- $valueFlux := get $valueGitops "flux" | default dict -}}
{{- if hasKey $globalFlux "enabled" }}{{- $fluxEnabled = $globalFlux.enabled -}}{{- end -}}
{{- if hasKey $generalFlux "enabled" }}{{- $fluxEnabled = $generalFlux.enabled -}}{{- end -}}
{{- if hasKey $valueFlux "enabled" }}{{- $fluxEnabled = $valueFlux.enabled -}}{{- end -}}
{{- if $fluxEnabled -}}
{{- with (get $globalFlux "annotations") }}{{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- with (get $generalFlux "annotations") }}{{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- with (get $valueFlux "annotations") }}{{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}{{- end -}}
{{- end -}}
{{- if $annotations }}{{ toYaml $annotations }}{{- end -}}
{{- end -}}

{{/*
Merge resource metadata annotations without duplicate keys.

Order of precedence (later wins):
- default hook annotations when includeHooks=true
- fixedAnnotations
- generic annotations
- gitops annotations
- general.annotations
- value.annotations
- extraAnnotations
*/}}
{{- define "helpers.app.annotations" -}}
{{- $ctx := .context -}}
{{- $general := .general | default dict -}}
{{- $value := .value | default dict -}}
{{- $annotations := dict -}}
{{- if .includeHooks -}}
  {{- with (include "helpers.app.defaultHookAnnotations" $ctx | fromYaml) -}}
    {{- $annotations = mergeOverwrite $annotations . -}}
  {{- end -}}
{{- end -}}
{{- with .fixedAnnotations -}}
  {{- if kindIs "string" . -}}
    {{- $annotations = mergeOverwrite $annotations ((fromYaml .) | default dict) -}}
  {{- else -}}
    {{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}
  {{- end -}}
{{- end -}}
{{- with (include "helpers.app.genericAnnotations" $ctx | fromYaml) -}}
  {{- $annotations = mergeOverwrite $annotations . -}}
{{- end -}}
{{- with (include "helpers.app.gitopsAnnotations" (dict "context" $ctx "general" $general "value" $value) | fromYaml) -}}
  {{- $annotations = mergeOverwrite $annotations . -}}
{{- end -}}
{{- with (get $general "annotations") -}}
  {{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}
{{- end -}}
{{- with (get $value "annotations") -}}
  {{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}
{{- end -}}
{{- with .extraAnnotations -}}
  {{- if kindIs "string" . -}}
    {{- $annotations = mergeOverwrite $annotations ((fromYaml .) | default dict) -}}
  {{- else -}}
    {{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}
  {{- end -}}
{{- end -}}
{{- if $annotations }}{{ toYaml $annotations }}{{- end -}}
{{- end -}}

{{/*
Merge pod-level annotations without duplicate keys.

Order of precedence (later wins):
- automatic checksum annotations
- generic pod annotations
- general.podAnnotations
- value.podAnnotations
- extraAnnotations
*/}}
{{- define "helpers.workloads.podAnnotations" -}}
{{- $ctx := .context -}}
{{- $general := .general | default dict -}}
{{- $value := .value | default dict -}}
{{- $annotations := dict -}}
{{- with (include "helpers.workloads.autoChecksumAnnotations" (dict "context" $ctx "general" $general "value" $value) | fromYaml) -}}
  {{- $annotations = mergeOverwrite $annotations . -}}
{{- end -}}
{{- if and $ctx.Values.generic (hasKey $ctx.Values.generic "podAnnotations") -}}
  {{- with $ctx.Values.generic.podAnnotations -}}
    {{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}
  {{- end -}}
{{- end -}}
{{- with (get $general "podAnnotations") -}}
  {{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}
{{- end -}}
{{- with (get $value "podAnnotations") -}}
  {{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}
{{- end -}}
{{- with .extraAnnotations -}}
  {{- if kindIs "string" . -}}
    {{- $annotations = mergeOverwrite $annotations ((fromYaml .) | default dict) -}}
  {{- else -}}
    {{- $annotations = mergeOverwrite $annotations ((fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx))) | default dict) -}}
  {{- end -}}
{{- end -}}
{{- if $annotations }}{{ toYaml $annotations }}{{- end -}}
{{- end -}}

{{- define "helpers.workloads.gitOpsSafeMode" -}}
{{ include "helpers.workloads.deterministicNames" . }}
{{- end -}}

{{- define "helpers.workloads.deterministicNames" -}}
{{- $ctx := .context -}}
{{- $deterministicNames := true -}}
{{- if and $ctx.Values.generic (hasKey $ctx.Values.generic "deterministicNames") -}}
{{- $deterministicNames = $ctx.Values.generic.deterministicNames -}}
{{- else if and $ctx.Values.gitOps (hasKey $ctx.Values.gitOps "safeMode") -}}
{{- $deterministicNames = $ctx.Values.gitOps.safeMode -}}
{{- end -}}
{{- if $deterministicNames -}}true{{- else -}}false{{- end -}}
{{- end -}}

{{- define "helpers.workloads.modeEnabled" -}}
{{- $mode := default "auto" .context.Values.workloadMode | lower -}}
{{- $kind := .kind | lower -}}
{{- if eq $mode "auto" -}}
true
{{- else if eq $mode "none" -}}
false
{{- else if and (eq $mode "deployment") (eq $kind "deployment") -}}
true
{{- else if and (eq $mode "daemonset") (eq $kind "daemonset") -}}
true
{{- else if and (eq $mode "pod") (eq $kind "pod") -}}
true
{{- else if and (eq $mode "statefulset") (eq $kind "statefulset") -}}
true
{{- else if and (or (eq $mode "batch") (eq $mode "jobs") (eq $mode "jobs-only") (eq $mode "jobsonly")) (or (eq $kind "job") (eq $kind "cronjob") (eq $kind "hook")) -}}
true
{{- else if and (eq $mode "job") (eq $kind "job") -}}
true
{{- else if and (eq $mode "cronjob") (eq $kind "cronjob") -}}
true
{{- else if and (eq $mode "hook") (eq $kind "hook") -}}
true
{{- else -}}
false
{{- end -}}
{{- end -}}

{{- define "helpers.workloads.containerEntries" -}}
{{- $entries := list -}}
{{- if kindIs "map" .value -}}
  {{- range $entryName := keys .value | sortAlpha -}}
    {{- $entry := (fromYaml (toYaml (get $.value $entryName | default dict))) | default dict -}}
    {{- if not (hasKey $entry "name") }}{{- $_ := set $entry "name" $entryName -}}{{- end -}}
    {{- $entries = append $entries $entry -}}
  {{- end -}}
{{- else if kindIs "slice" .value -}}
  {{- range .value -}}
    {{- $entries = append $entries ((fromYaml (toYaml (. | default dict))) | default dict) -}}
  {{- end -}}
{{- end -}}
{{ toYaml $entries }}
{{- end -}}

{{- define "helpers.resources.isEnabled" -}}
{{- $value := .value | default dict -}}
{{- if and $value (not ($value.disabled | default false)) -}}true{{- else -}}false{{- end -}}
{{- end -}}

{{- define "helpers.statefulsets.governingServiceName" -}}
{{- $serviceName := .statefulSet.serviceName | default .name -}}
{{- include "helpers.app.fullname" (dict "name" $serviceName "context" .context) -}}
{{- end -}}

{{- define "helpers.statefulsets.governingServicePorts" -}}
{{- $ports := list -}}
{{- $containers := fromYamlArray (include "helpers.workloads.containerEntries" (dict "value" .statefulSet.containers)) | default list -}}
{{- range $container := $containers }}
  {{- range $port := (get $container "ports" | default list) }}
    {{- $servicePort := dict -}}
    {{- if hasKey $port "name" }}
      {{- $_ := set $servicePort "name" (get $port "name") -}}
    {{- else }}
      {{- $_ := set $servicePort "name" (printf "port-%v" (get $port "containerPort")) -}}
    {{- end }}
    {{- $_ := set $servicePort "port" (get $port "containerPort") -}}
    {{- $_ := set $servicePort "targetPort" ((get $port "name") | default (get $port "containerPort")) -}}
    {{- $_ := set $servicePort "protocol" ((get $port "protocol") | default "TCP") -}}
    {{- $ports = append $ports $servicePort -}}
  {{- end }}
{{- end }}
{{- if not $ports -}}
  {{- fail (printf "StatefulSet %q requires at least one container port to render the governing Service automatically" .name) -}}
{{- end -}}
{{ toYaml $ports }}
{{- end -}}

{{- define "helpers.workloads.referencedResources" -}}
{{- $ctx := .context -}}
{{- $general := .general | default dict -}}
{{- $value := .value | default dict -}}
{{- $referencedConfigMaps := dict -}}
{{- $referencedSecrets := dict -}}
{{- /* Collect referenced names from all containers and initContainers */ -}}
{{- $containers := list -}}
{{- $containers = concat $containers (fromYamlArray (include "helpers.workloads.containerEntries" (dict "value" $value.containers)) | default list) -}}
{{- $containers = concat $containers (fromYamlArray (include "helpers.workloads.containerEntries" (dict "value" $value.initContainers)) | default list) -}}
{{- range $container := $containers -}}
  {{- /* envConfigmaps: list of configmap names */ -}}
  {{- range (get $container "envConfigmaps" | default list) -}}
    {{- $_ := set $referencedConfigMaps . true -}}
  {{- end -}}
  {{- /* envSecrets: list of secret names */ -}}
  {{- range (get $container "envSecrets" | default list) -}}
    {{- $_ := set $referencedSecrets . true -}}
  {{- end -}}
  {{- /* envsFromConfigmap: map keyed by configmap name */ -}}
  {{- range $configMapName := keys (get $container "envsFromConfigmap" | default dict) -}}
    {{- $_ := set $referencedConfigMaps $configMapName true -}}
  {{- end -}}
  {{- /* envsFromSecret: map keyed by secret name */ -}}
  {{- range $secretName := keys (get $container "envsFromSecret" | default dict) -}}
    {{- $_ := set $referencedSecrets $secretName true -}}
  {{- end -}}
{{- end -}}
{{- /* Collect referenced names from workload, general and generic volumes */ -}}
{{- $volumes := concat ($value.volumes | default list) ($general.volumes | default list) ($ctx.Values.generic.volumes | default list) -}}
{{- range $vol := $volumes -}}
  {{- $volType := get $vol "type" | default "" -}}
  {{- $volName := get $vol "name" | default "" -}}
  {{- if and (eq $volType "configMap") $volName -}}
    {{- $_ := set $referencedConfigMaps $volName true -}}
  {{- end -}}
  {{- if and (eq $volType "secret") $volName -}}
    {{- $_ := set $referencedSecrets $volName true -}}
  {{- end -}}
{{- end -}}
configMaps: {{ toJson $referencedConfigMaps }}
secrets: {{ toJson $referencedSecrets }}
{{- end -}}

{{- define "helpers.workloads.autoChecksumAnnotations" -}}
{{- $ctx := .context -}}
{{- $general := .general | default dict -}}
{{- $value := .value | default dict -}}
{{- $annotations := dict -}}
{{- $reserved := dict -}}
{{- $enabled := true -}}
{{- if and $ctx.Values.generic (hasKey $ctx.Values.generic "autoRolloutChecksums") -}}
  {{- $enabled = $ctx.Values.generic.autoRolloutChecksums -}}
{{- end -}}
{{- with $ctx.Values.generic.podAnnotations -}}
  {{- $rendered := fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx)) | default dict -}}
  {{- range $annotationName := keys $rendered -}}
    {{- $_ := set $reserved $annotationName true -}}
  {{- end -}}
{{- end -}}
{{- with $general.podAnnotations -}}
  {{- $rendered := fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx)) | default dict -}}
  {{- range $annotationName := keys $rendered -}}
    {{- $_ := set $reserved $annotationName true -}}
  {{- end -}}
{{- end -}}
{{- with $value.podAnnotations -}}
  {{- $rendered := fromYaml (include "helpers.tplvalues.render" (dict "value" . "context" $ctx)) | default dict -}}
  {{- range $annotationName := keys $rendered -}}
    {{- $_ := set $reserved $annotationName true -}}
  {{- end -}}
{{- end -}}
{{- if $enabled -}}
  {{- /* Resolve referenced resources for this workload */ -}}
  {{- $referencedResources := fromYaml (include "helpers.workloads.referencedResources" (dict "context" $ctx "general" $general "value" $value)) | default dict -}}
  {{- if or (not (empty $ctx.Values.envs)) (not (empty $ctx.Values.envsString)) -}}
    {{- if not (hasKey $reserved "checksum/envs") -}}
      {{- $_ := set $annotations "checksum/envs" (sha256sum (printf "%s\n%s" ($ctx.Values.envs | toYaml) (include "helpers.tplvalues.render" (dict "value" $ctx.Values.envsString "context" $ctx)))) -}}
    {{- end -}}
  {{- end -}}
  {{- if or (not (empty $ctx.Values.secretEnvs)) (not (empty $ctx.Values.secretEnvsString)) -}}
    {{- if not (hasKey $reserved "checksum/secret-envs") -}}
      {{- $_ := set $annotations "checksum/secret-envs" (sha256sum (printf "%s\n%s" ($ctx.Values.secretEnvs | toYaml) (include "helpers.tplvalues.render" (dict "value" $ctx.Values.secretEnvsString "context" $ctx)))) -}}
    {{- end -}}
  {{- end -}}
  {{- range $name := keys ($ctx.Values.configMaps | default dict) | sortAlpha }}
    {{- if hasKey (get $referencedResources "configMaps" | default dict) $name -}}
      {{- $configMap := get $ctx.Values.configMaps $name -}}
      {{- if eq "true" (include "helpers.resources.isEnabled" (dict "value" $configMap)) -}}
        {{- $annotationName := printf "checksum/configmap-%s" $name -}}
        {{- if not (hasKey $reserved $annotationName) -}}
          {{- $_ := set $annotations $annotationName (sha256sum (($configMap | toYaml) | trim)) -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- range $name := keys ($ctx.Values.secrets | default dict) | sortAlpha }}
    {{- if hasKey (get $referencedResources "secrets" | default dict) $name -}}
      {{- $secret := get $ctx.Values.secrets $name -}}
      {{- if eq "true" (include "helpers.resources.isEnabled" (dict "value" $secret)) -}}
        {{- $annotationName := printf "checksum/secret-%s" $name -}}
        {{- if not (hasKey $reserved $annotationName) -}}
          {{- $_ := set $annotations $annotationName (sha256sum (($secret | toYaml) | trim)) -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- range $name := keys ($ctx.Values.sealedSecrets | default dict) | sortAlpha }}
    {{- if hasKey (get $referencedResources "secrets" | default dict) $name -}}
      {{- $secret := get $ctx.Values.sealedSecrets $name -}}
      {{- if eq "true" (include "helpers.resources.isEnabled" (dict "value" $secret)) -}}
        {{- $annotationName := printf "checksum/sealed-secret-%s" $name -}}
        {{- if not (hasKey $reserved $annotationName) -}}
          {{- $_ := set $annotations $annotationName (sha256sum (($secret | toYaml) | trim)) -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if $annotations -}}
{{ toYaml $annotations }}
{{- end -}}
{{- end -}}

{{/*
Render pod/container securityContext with optional generic defaults.

If mergeWithGeneric=true is set on the specific securityContext, generic keys are
merged first and the specific keys override them. Otherwise the specific value
replaces the generic default.
*/}}
{{- define "helpers.securityContext" -}}
{{- $ctx := .context -}}
{{- $specific := .securityContext -}}
{{- $generic := .genericSecurityContext -}}
{{- $final := dict -}}
{{- if and $specific (kindIs "map" $specific) (get $specific "mergeWithGeneric") $generic -}}
  {{- $final = mergeOverwrite $final ($generic | default dict) (omit $specific "mergeWithGeneric") -}}
{{- else if $specific -}}
  {{- if and (kindIs "map" $specific) (hasKey $specific "mergeWithGeneric") -}}
    {{- $final = omit $specific "mergeWithGeneric" -}}
  {{- else -}}
    {{- $final = $specific -}}
  {{- end -}}
{{- else if $generic -}}
  {{- $final = $generic -}}
{{- end -}}
{{- if $final }}
securityContext: {{- include "helpers.tplvalues.render" (dict "value" $final "context" $ctx) | nindent 2 }}
{{- end -}}
{{- end -}}

{{/*
Render imagePullSecrets for generated ServiceAccounts.

The general and local imagePullSecrets blocks support:
- includePlatformDefault: bool
- additional: [{name: regcred}] or ["regcred"]

The local value can also be provided directly as a list for convenience.
*/}}
{{- define "helpers.serviceAccounts.imagePullSecrets" -}}
{{- $ctx := .context -}}
{{- $general := .general | default dict -}}
{{- $value := .value | default dict -}}
{{- $generalConfig := get $general "imagePullSecrets" | default dict -}}
{{- $valueConfig := get $value "imagePullSecrets" -}}
{{- $includeDefault := false -}}
{{- if and (kindIs "map" $generalConfig) (hasKey $generalConfig "includePlatformDefault") -}}
  {{- $includeDefault = $generalConfig.includePlatformDefault -}}
{{- end -}}
{{- if and (kindIs "map" $valueConfig) (hasKey $valueConfig "includePlatformDefault") -}}
  {{- $includeDefault = $valueConfig.includePlatformDefault -}}
{{- end -}}
{{- $items := list -}}
{{- if and (kindIs "map" $generalConfig) (kindIs "slice" ($generalConfig.additional | default list)) -}}
  {{- $items = concat $items ($generalConfig.additional | default list) -}}
{{- end -}}
{{- if kindIs "slice" $valueConfig -}}
  {{- $items = concat $items $valueConfig -}}
{{- else if and (kindIs "map" $valueConfig) (kindIs "slice" ($valueConfig.additional | default list)) -}}
  {{- $items = concat $items ($valueConfig.additional | default list) -}}
{{- end -}}
{{- $names := list -}}
{{- if and $includeDefault $ctx.Values.serviceAccountDefaultImagePullSecretName -}}
  {{- $names = append $names $ctx.Values.serviceAccountDefaultImagePullSecretName -}}
{{- end -}}
{{- range $item := $items -}}
  {{- if kindIs "string" $item -}}
    {{- $names = append $names $item -}}
  {{- else if and (kindIs "map" $item) (hasKey $item "name") -}}
    {{- $names = append $names ($item.name | toString) -}}
  {{- end -}}
{{- end -}}
{{- $seen := dict -}}
{{- $rendered := list -}}
{{- range $name := $names -}}
  {{- $resolvedName := include "helpers.tplvalues.render" (dict "value" $name "context" $ctx) -}}
  {{- if and $resolvedName (not (hasKey $seen $resolvedName)) -}}
    {{- $_ := set $seen $resolvedName true -}}
    {{- $rendered = append $rendered (dict "name" $resolvedName) -}}
  {{- end -}}
{{- end -}}
{{- if $rendered }}
imagePullSecrets:
{{- range $entry := $rendered }}
  - name: {{ $entry.name | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.volumes.typed" -}}
{{- $ctx := .context -}}
{{- range .volumes -}}
{{- if eq .type "configMap" }}
- name: {{ .name }}
  configMap:
    {{- with .originalName }}
    name: {{ . }}
    {{- else }}
    name: {{ include "helpers.app.fullname" (dict "name" .name "context" $ctx) }}
    {{- end }}
    {{- with .defaultMode }}
    defaultMode: {{ . }}
    {{- end }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 6 }}
    {{- end }}
{{- else if eq .type "secret" }}
- name: {{ .name }}
  secret:
    {{- with .originalName }}
    secretName: {{ . }}
    {{- else }}
    secretName: {{ include "helpers.app.fullname" (dict "name" .name "context" $ctx) }}
    {{- end }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 6 }}
    {{- end }}
{{- else if eq .type "pvc" }}
- name: {{ .name }}
  persistentVolumeClaim:
    {{- with .originalName }}
    claimName: {{ . }}
    {{- else }}
    claimName: {{ include "helpers.app.fullname" (dict "name" .name "context" $ctx) }}
    {{- end }}
{{- else if eq .type "emptyDir" }}
- name: {{ .name }}
  {{- if or .sizeLimit .medium }}
  emptyDir:
    {{- if .sizeLimit }}
    sizeLimit: {{ .sizeLimit }}
    {{- end }}
    {{- if .medium }}
    medium: {{ .medium }}
    {{- end }}
  {{- else }}
  emptyDir: {}
  {{- end }}
{{- else if eq .type "projected" }}
- name: {{ .name }}
  projected:
    {{- with .defaultMode }}
    defaultMode: {{ . }}
    {{- end }}
    sources: {{- include "helpers.tplvalues.render" (dict "value" (.sources | default list) "context" $ctx) | nindent 6 }}
{{- end }}
{{- end -}}
{{- end -}}

{{- define "helpers.volumes.renderVolume" -}}
{{- $ctx := .context -}}
{{- $general := .general | default dict -}}
{{- $val := .value | default dict -}}
{{- if or $val.volumes $general.volumes $ctx.Values.generic.volumes $val.extraVolumes $general.extraVolumes $ctx.Values.generic.extraVolumes -}}
{{- with $val.volumes }}
{{ include "helpers.volumes.typed" (dict "volumes" . "context" $ctx) }}
{{- end }}
{{- with $general.volumes }}
{{ include "helpers.volumes.typed" (dict "volumes" . "context" $ctx) }}
{{- end }}
{{- with $ctx.Values.generic.volumes }}
{{ include "helpers.volumes.typed" (dict "volumes" . "context" $ctx) }}
{{- end }}
{{- with $val.extraVolumes }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
{{- end }}
{{- with $general.extraVolumes }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
{{- end }}
{{- with $ctx.Values.generic.extraVolumes }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
{{- end }}
{{- else -}}
[]
{{- end -}}
{{- end -}}

{{- define "helpers.volumes.renderVolumeMounts" -}}
{{- $ctx := .context -}}
{{- $general := .general | default dict -}}
{{- $val := .value | default dict -}}
{{- if or $val.volumeMounts $val.extraVolumeMounts $general.volumeMounts $general.extraVolumeMounts $ctx.Values.generic.volumeMounts $ctx.Values.generic.extraVolumeMounts -}}
{{- with $val.volumeMounts }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
{{- end }}
{{- with $val.extraVolumeMounts }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
{{- end }}
{{- with $general.volumeMounts }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
{{- end }}
{{- with $general.extraVolumeMounts }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
{{- end }}
{{- with $ctx.Values.generic.volumeMounts }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
{{- end }}
{{- with $ctx.Values.generic.extraVolumeMounts }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
{{- end }}
{{- else -}}
[]
{{- end -}}
{{- end -}}

{{- define "helpers.pod" -}}
{{- $ := .context -}}
{{- $general := .general | default dict -}}
{{- $extraLabels := .extraLabels | default dict -}}
{{- $usePredefinedAffinity := $.Values.generic.usePredefinedAffinity -}}
{{- if ne $general.usePredefinedAffinity nil }}{{- $usePredefinedAffinity = $general.usePredefinedAffinity -}}{{- end -}}
{{- $name := .name -}}
{{- $diagnosticEnabled := false -}}
{{- if $.Values.diagnosticMode -}}
{{- $diagnosticEnabled = or $.Values.diagnosticMode.enabled $.Values.diagnosticMode.enbled -}}
{{- end -}}
{{- with .value -}}
{{- $serviceAccountName := "" -}}
{{- if .serviceAccountName -}}
{{- $serviceAccountName = include "helpers.tplvalues.render" (dict "value" .serviceAccountName "context" $) -}}
{{- else if $.Values.generic.serviceAccountName -}}
{{- $serviceAccountName = include "helpers.tplvalues.render" (dict "value" $.Values.generic.serviceAccountName "context" $) -}}
{{- end -}}
{{- if $serviceAccountName }}
{{- if and (kindIs "map" $.Values.serviceAccount) (hasKey $.Values.serviceAccount $serviceAccountName) }}
serviceAccountName: {{ include "helpers.app.fullname" (dict "name" $serviceAccountName "context" $) }}
{{- else }}
serviceAccountName: {{ $serviceAccountName }}
{{- end }}
{{- end }}
{{- if hasKey . "automountServiceAccountToken" }}
automountServiceAccountToken: {{ .automountServiceAccountToken }}
{{- else if and $.Values.generic (hasKey $.Values.generic "automountServiceAccountToken") }}
automountServiceAccountToken: {{ $.Values.generic.automountServiceAccountToken }}
{{- end }}
{{- if .hostAliases }}
hostAliases: {{- include "helpers.tplvalues.render" (dict "value" .hostAliases "context" $) | nindent 2 }}
{{- else if $.Values.generic.hostAliases }}
hostAliases: {{- include "helpers.tplvalues.render" (dict "value" $.Values.generic.hostAliases "context" $) | nindent 2 }}
{{- end }}
{{- if .affinity }}
affinity: {{- include "helpers.tplvalues.render" (dict "value" .affinity "context" $) | nindent 2 }}
{{- else if $general.affinity }}
affinity: {{- include "helpers.tplvalues.render" (dict "value" $general.affinity "context" $) | nindent 2 }}
{{- else if $usePredefinedAffinity }}
affinity:
  nodeAffinity: {{- include "helpers.affinities.nodes" (dict "type" $.Values.nodeAffinityPreset.type "key" $.Values.nodeAffinityPreset.key "values" $.Values.nodeAffinityPreset.values "context" $) | nindent 4 }}
  podAffinity: {{- include "helpers.affinities.pods" (dict "type" $.Values.podAffinityPreset "extraLabels" $extraLabels "context" $) | nindent 4 }}
  podAntiAffinity: {{- include "helpers.affinities.pods" (dict "type" $.Values.podAntiAffinityPreset "extraLabels" $extraLabels "context" $) | nindent 4 }}
{{- end }}
{{- $topologySpreadConstraints := $.Values.generic.topologySpreadConstraints -}}
{{- if ne $general.topologySpreadConstraints nil }}{{- $topologySpreadConstraints = $general.topologySpreadConstraints -}}{{- end -}}
{{- if ne .topologySpreadConstraints nil }}{{- $topologySpreadConstraints = .topologySpreadConstraints -}}{{- end -}}
{{- with $topologySpreadConstraints }}
topologySpreadConstraints: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
{{- end }}
{{- if .priorityClassName }}
priorityClassName: {{ .priorityClassName }}
{{- else if $.Values.generic.priorityClassName }}
priorityClassName: {{ $.Values.generic.priorityClassName }}
{{- end }}
{{- if .dnsPolicy }}
dnsPolicy: {{ .dnsPolicy }}
{{- else if $.Values.generic.dnsPolicy }}
dnsPolicy: {{ $.Values.generic.dnsPolicy }}
{{- end }}
{{- with .restartPolicy }}
restartPolicy: {{ . }}
{{- end }}
{{- if .nodeSelector }}
nodeSelector: {{- include "helpers.tplvalues.render" (dict "value" .nodeSelector "context" $) | nindent 2 }}
{{- else if $.Values.generic.nodeSelector }}
nodeSelector: {{- include "helpers.tplvalues.render" (dict "value" $.Values.generic.nodeSelector "context" $) | nindent 2 }}
{{- end }}
{{- $combinedTolerations := list -}}
{{- if .tolerations }}
{{- $combinedTolerations = .tolerations -}}
{{- else if $.Values.generic.tolerations }}
{{- $combinedTolerations = $.Values.generic.tolerations -}}
{{- end }}
{{- if $combinedTolerations }}
tolerations:
{{ toYaml $combinedTolerations | nindent 2 }}
{{- end }}
{{- include "helpers.securityContext" (dict "securityContext" .securityContext "genericSecurityContext" $.Values.generic.podSecurityContext "context" $) }}
{{- if or $.Values.imagePullSecrets $.Values.generic.extraImagePullSecrets .imagePullSecrets .extraImagePullSecrets }}
imagePullSecrets:
{{- range $sName := keys $.Values.imagePullSecrets | sortAlpha }}
- name: {{ $sName }}
{{- end }}
{{- with .imagePullSecrets }}{{ include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 0 }}{{- end }}
{{- with .extraImagePullSecrets }}{{ include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 0 }}{{- end }}
{{- with $.Values.generic.extraImagePullSecrets }}{{ include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 0 }}{{- end }}
{{- end }}
{{- if .terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ .terminationGracePeriodSeconds }}
{{- end }}
{{- $initContainers := fromYamlArray (include "helpers.workloads.containerEntries" (dict "value" .initContainers)) | default list -}}
{{- if $initContainers }}
initContainers:
{{- range $index, $container := $initContainers }}
  {{- $containerName := get $container "name" -}}
  {{- if $containerName }}
- name: {{ include "helpers.tplvalues.render" (dict "value" $containerName "context" $) }}
  {{- else }}
- name: {{ printf "%s-init-%d" $name $index }}
  {{- end }}
  {{- $image := $.Values.defaultImage -}}
  {{- with (get $container "image") }}{{- $image = include "helpers.tplvalues.render" (dict "value" . "context" $) -}}{{- end }}
  {{- $imageTag := $.Values.defaultImageTag -}}
  {{- with (get $container "imageTag") }}{{- $imageTag = include "helpers.tplvalues.render" (dict "value" . "context" $) -}}{{- end }}
  image: {{ $image }}:{{ $imageTag }}
  imagePullPolicy: {{ get $container "imagePullPolicy" | default $.Values.defaultImagePullPolicy }}
  {{- if get $container "stdin" }}
  stdin: {{ get $container "stdin" }}
  {{- end }}
  {{- if get $container "tty" }}
  tty: {{ get $container "tty" }}
  {{- end }}
  {{- include "helpers.securityContext" (dict "securityContext" (get $container "securityContext") "genericSecurityContext" $.Values.generic.containerSecurityContext "context" $) | nindent 2 }}
  {{- if $diagnosticEnabled }}
  args: {{- include "helpers.tplvalues.render" (dict "value" $.Values.diagnosticMode.args "context" $) | nindent 2 }}
  {{- else if (get $container "args") }}
  args: {{- include "helpers.tplvalues.render" (dict "value" (get $container "args") "context" $) | nindent 2 }}
  {{- end }}
  {{- if $diagnosticEnabled }}
  command: {{- include "helpers.tplvalues.render" (dict "value" $.Values.diagnosticMode.command "context" $) | nindent 2 }}
  {{- else if (get $container "command") }}
    {{- if typeIs "string" (get $container "command") }}
  command: {{ printf "[\"%s\"]" (join "\", \"" (without (splitList " " (get $container "command")) "")) }}
    {{- else }}
  command: {{- include "helpers.tplvalues.render" (dict "value" (get $container "command") "context" $) | nindent 2 }}
    {{- end }}
  {{- end }}
{{ include "helpers.workloads.envs" (dict "value" $container "context" $) | nindent 2 }}
{{ include "helpers.workloads.envsFrom" (dict "value" $container "context" $) | nindent 2 }}
  {{- with (get $container "ports") }}
  ports: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
  {{- end }}
  {{- with (get $container "lifecycle") }}
  lifecycle: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with (get $container "startupProbe") }}
  startupProbe: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with (get $container "livenessProbe") }}
  livenessProbe: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with (get $container "readinessProbe") }}
  readinessProbe: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- $containerResources := get $container "resources" -}}
  {{- if $containerResources }}
  resources: {{- include "helpers.tplvalues.render" (dict "value" $containerResources "context" $) | nindent 4 }}
  {{- else if $general.resources }}
  resources: {{- include "helpers.tplvalues.render" (dict "value" $general.resources "context" $) | nindent 4 }}
  {{- else if $.Values.generic.resources }}
  resources: {{- include "helpers.tplvalues.render" (dict "value" $.Values.generic.resources "context" $) | nindent 4 }}
  {{- end }}
  volumeMounts: {{- include "helpers.volumes.renderVolumeMounts" (dict "value" $container "general" $general "context" $) | nindent 4 }}
{{- end }}
{{- end }}
{{- $containers := fromYamlArray (include "helpers.workloads.containerEntries" (dict "value" .containers)) | default list -}}
{{- if $containers }}
containers:
{{- range $index, $container := $containers }}
  {{- $containerName := get $container "name" -}}
  {{- if $containerName }}
- name: {{ include "helpers.tplvalues.render" (dict "value" $containerName "context" $) }}
  {{- else }}
- name: {{ printf "%s-%d" $name $index }}
  {{- end }}
  {{- $image := $.Values.defaultImage -}}
  {{- with (get $container "image") }}{{- $image = include "helpers.tplvalues.render" (dict "value" . "context" $) -}}{{- end }}
  {{- $imageTag := $.Values.defaultImageTag -}}
  {{- with (get $container "imageTag") }}{{- $imageTag = include "helpers.tplvalues.render" (dict "value" . "context" $) -}}{{- end }}
  image: {{ $image }}:{{ $imageTag }}
  imagePullPolicy: {{ get $container "imagePullPolicy" | default $.Values.defaultImagePullPolicy }}
  {{- if get $container "stdin" }}
  stdin: {{ get $container "stdin" }}
  {{- end }}
  {{- if get $container "tty" }}
  tty: {{ get $container "tty" }}
  {{- end }}
  {{- include "helpers.securityContext" (dict "securityContext" (get $container "securityContext") "genericSecurityContext" $.Values.generic.containerSecurityContext "context" $) | nindent 2 }}
  {{- if $diagnosticEnabled }}
  args: {{- include "helpers.tplvalues.render" (dict "value" $.Values.diagnosticMode.args "context" $) | nindent 2 }}
  {{- else if (get $container "args") }}
  args: {{- include "helpers.tplvalues.render" (dict "value" (get $container "args") "context" $) | nindent 2 }}
  {{- end }}
  {{- if $diagnosticEnabled }}
  command: {{- include "helpers.tplvalues.render" (dict "value" $.Values.diagnosticMode.command "context" $) | nindent 2 }}
  {{- else if (get $container "command") }}
    {{- if typeIs "string" (get $container "command") }}
  command: {{ printf "[\"%s\"]" (join "\", \"" (without (splitList " " (get $container "command")) "")) }}
    {{- else }}
  command: {{- include "helpers.tplvalues.render" (dict "value" (get $container "command") "context" $) | nindent 2 }}
    {{- end }}
  {{- end }}
{{ include "helpers.workloads.envs" (dict "value" $container "general" $general "context" $) | nindent 2 }}
{{ include "helpers.workloads.envsFrom" (dict "value" $container "general" $general "context" $) | nindent 2 }}
  {{- with (get $container "ports") }}
  ports: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
  {{- end }}
  {{- with (get $container "lifecycle") }}
  lifecycle: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with (get $container "startupProbe") }}
  startupProbe: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with (get $container "livenessProbe") }}
  livenessProbe: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with (get $container "readinessProbe") }}
  readinessProbe: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- $containerResources := get $container "resources" -}}
  {{- if $containerResources }}
  resources: {{- include "helpers.tplvalues.render" (dict "value" $containerResources "context" $) | nindent 4 }}
  {{- else if $general.resources }}
  resources: {{- include "helpers.tplvalues.render" (dict "value" $general.resources "context" $) | nindent 4 }}
  {{- else if $.Values.generic.resources }}
  resources: {{- include "helpers.tplvalues.render" (dict "value" $.Values.generic.resources "context" $) | nindent 4 }}
  {{- end }}
  volumeMounts: {{- include "helpers.volumes.renderVolumeMounts" (dict "value" $container "general" $general "context" $) | nindent 4 }}
{{- end }}
{{- end }}
volumes: {{- include "helpers.volumes.renderVolume" (dict "value" . "general" $general "context" $) | nindent 2 }}
{{- end }}
{{- end -}}
