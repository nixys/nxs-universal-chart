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
    {{- $configMap := get $ctx.Values.configMaps $name -}}
    {{- if eq "true" (include "helpers.resources.isEnabled" (dict "value" $configMap)) -}}
      {{- $annotationName := printf "checksum/configmap-%s" $name -}}
      {{- if not (hasKey $reserved $annotationName) -}}
        {{- $_ := set $annotations $annotationName (sha256sum (($configMap | toYaml) | trim)) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- range $name := keys ($ctx.Values.secrets | default dict) | sortAlpha }}
    {{- $secret := get $ctx.Values.secrets $name -}}
    {{- if eq "true" (include "helpers.resources.isEnabled" (dict "value" $secret)) -}}
      {{- $annotationName := printf "checksum/secret-%s" $name -}}
      {{- if not (hasKey $reserved $annotationName) -}}
        {{- $_ := set $annotations $annotationName (sha256sum (($secret | toYaml) | trim)) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- range $name := keys ($ctx.Values.sealedSecrets | default dict) | sortAlpha }}
    {{- $secret := get $ctx.Values.sealedSecrets $name -}}
    {{- if eq "true" (include "helpers.resources.isEnabled" (dict "value" $secret)) -}}
      {{- $annotationName := printf "checksum/sealed-secret-%s" $name -}}
      {{- if not (hasKey $reserved $annotationName) -}}
        {{- $_ := set $annotations $annotationName (sha256sum (($secret | toYaml) | trim)) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if $annotations -}}
{{ toYaml $annotations }}
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
{{- with .nodeSelector }}
nodeSelector: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
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
{{- with .securityContext }}
securityContext: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
{{- end }}
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
  {{- with (get $container "securityContext") }}
  securityContext: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
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
  {{- with (get $container "resources") }}
  resources: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
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
  {{- with (get $container "securityContext") }}
  securityContext: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
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
  {{- with (get $container "resources") }}
  resources: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  volumeMounts: {{- include "helpers.volumes.renderVolumeMounts" (dict "value" $container "general" $general "context" $) | nindent 4 }}
{{- end }}
{{- end }}
volumes: {{- include "helpers.volumes.renderVolume" (dict "value" . "general" $general "context" $) | nindent 2 }}
{{- end }}
{{- end -}}
