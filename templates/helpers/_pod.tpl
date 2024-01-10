{{- define "helpers.pod" -}}
{{- $ := .context -}}
{{- $general := .general -}}
{{- $extraLabels := .extraLabels -}}
{{- $usePredefinedAffinity := $.Values.generic.usePredefinedAffinity -}}
{{- if (ne $general.usePredefinedAffinity nil) }}{{ $usePredefinedAffinity = $general.usePredefinedAffinity }}{{ end -}}
{{- $name := .name -}}
{{- with .value -}}
{{- if .serviceAccountName }}
serviceAccountName: {{- include "helpers.tplvalues.render" (dict "value" .serviceAccountName "context" $) | nindent 2 }}
{{- else if $.Values.generic.serviceAccountName }}
serviceAccountName: {{- include "helpers.tplvalues.render" (dict "value" $.Values.generic.serviceAccountName  "context" $) | nindent 2 }}
{{- end }}
{{- if .hostAliases }}
hostAliases: {{- include "helpers.tplvalues.render" (dict "value" .hostAliases "context" $) | nindent 2 }}
{{- else if $.Values.generic.hostAliases }}
hostAliases: {{- include "helpers.tplvalues.render" (dict "value" $.Values.generic.hostAliases "context" $) | nindent 2 }}
{{- end }}
{{- if .affinity }}
affinity: {{- include "helpers.tplvalues.render" ( dict "value" .affinity "context" $) | nindent 2 }}
{{- else if $general.affinity }}
affinity: {{- include "helpers.tplvalues.render" ( dict "value" $general.affinity "context" $) | nindent 2 }}
{{- else if $usePredefinedAffinity }}
affinity:
  nodeAffinity: {{- include "helpers.affinities.nodes" (dict "type" $.Values.nodeAffinityPreset.type "key" $.Values.nodeAffinityPreset.key "values" $.Values.nodeAffinityPreset.values "context" $) | nindent 4 }}
  podAffinity: {{- include "helpers.affinities.pods" (dict "type" $.Values.podAffinityPreset "extraLabels" $extraLabels "context" $) | nindent 4 }}
  podAntiAffinity: {{- include "helpers.affinities.pods" (dict "type" $.Values.podAntiAffinityPreset "extraLabels" $extraLabels "context" $) | nindent 4 }}
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
{{- with .nodeSelector }}
nodeSelector: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
{{- end }}
{{- with .tolerations }}
tolerations: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
{{- end }}
{{- with .securityContext }}
securityContext: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
{{- end }}
{{ if or $.Values.imagePullSecrets $.Values.generic.extraImagePullSecrets .extraImagePullSecrets .imagePullSecrets }}
imagePullSecrets:
{{- range $sName, $v := $.Values.imagePullSecrets }}
- name: {{ $sName }}
{{- end }}
{{- with .imagePullSecrets }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 0 }}{{- end }}
{{- with .extraImagePullSecrets }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 0 }}{{- end }}
{{- with $.Values.generic.extraImagePullSecrets }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 0 }}{{- end }}
{{- end }}
{{- if .terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ .terminationGracePeriodSeconds }}
{{- end }}
{{- with .initContainers}}
initContainers:
{{- range . }}
  {{- with .name }}
- name: {{ include "helpers.tplvalues.render" ( dict "value" . "context" $) }}
  {{- else }}
- name: {{ printf "%s-init-%s" $name (lower (randAlphaNum 5)) }}
  {{- end }}
  {{- $image := $.Values.defaultImage }}{{ with .image }}{{ $image = include "helpers.tplvalues.render" ( dict "value" . "context" $) }}{{ end }}
  {{- $imageTag := $.Values.defaultImageTag }}{{ with .imageTag }}{{ $imageTag = include "helpers.tplvalues.render" ( dict "value" . "context" $) }}{{ end }}
  image: {{ $image }}:{{ $imageTag }}
  imagePullPolicy: {{ .imagePullPolicy | default $.Values.defaultImagePullPolicy }}
  {{- with .securityContext }}
  securityContext: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- if $.Values.diagnosticMode.enabled }}
  args: {{- include "helpers.tplvalues.render" ( dict "value" $.Values.diagnosticMode.args "context" $) | nindent 2 }}
  {{- else if .args }}
  args: {{- include "helpers.tplvalues.render" ( dict "value" .args "context" $) | nindent 2 }}
  {{- end }}
  {{- if $.Values.diagnosticMode.enabled }}
  command: {{- include "helpers.tplvalues.render" ( dict "value" $.Values.diagnosticMode.command "context" $) | nindent 2 }}
  {{- else if .command }}
  {{- if typeIs "string" .command }}
  command: {{ printf "[\"%s\"]" (join ("\", \"") (without (splitList " " .command) "" )) }}
  {{- else }}
  command: {{- include "helpers.tplvalues.render" ( dict "value" .command "context" $) | nindent 2 }}
  {{- end }}
  {{- end }}
  {{- include "helpers.workloads.envs" (dict "value" . "context" $) | indent 2 }}
  {{- include "helpers.workloads.envsFrom" (dict "value" . "context" $) | indent 2 }}
  {{- with .ports }}
  ports: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 2 }}
  {{- end }}
  {{- with .lifecycle }}
  lifecycle: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with .startupProbe }}
  startupProbe: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with .livenessProbe }}
  livenessProbe: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with .readinessProbe }}
  readinessProbe: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with .resources }}
  resources: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  volumeMounts: {{- include "helpers.volumes.renderVolumeMounts" (dict "value" . "general" $general "context" $) | nindent 2 }}
{{- end }}{{- end }}
containers:
{{- range .containers }}
  {{- with .name }}
- name: {{ include "helpers.tplvalues.render" ( dict "value" . "context" $) }}
  {{- else }}
- name: {{ printf "%s-%s" $name (lower (randAlphaNum 5)) }}
  {{- end }}
  {{- $image := $.Values.defaultImage }}{{ with .image }}{{ $image = include "helpers.tplvalues.render" ( dict "value" . "context" $) }}{{ end }}
  {{- $imageTag := $.Values.defaultImageTag }}{{ with .imageTag }}{{ $imageTag = include "helpers.tplvalues.render" ( dict "value" . "context" $) }}{{ end }}
  image: {{ $image }}:{{ $imageTag }}
  imagePullPolicy: {{ .imagePullPolicy | default $.Values.defaultImagePullPolicy }}
  {{- with .securityContext }}
  securityContext: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- if $.Values.diagnosticMode.enabled }}
  args: {{- include "helpers.tplvalues.render" ( dict "value" $.Values.diagnosticMode.args "context" $) | nindent 2 }}
  {{- else if .args }}
  args: {{- include "helpers.tplvalues.render" ( dict "value" .args "context" $) | nindent 2 }}
  {{- end }}
  {{- if $.Values.diagnosticMode.enabled }}
  command: {{- include "helpers.tplvalues.render" ( dict "value" $.Values.diagnosticMode.command "context" $) | nindent 2 }}
  {{- else if .command }}
  {{- if typeIs "string" .command }}
  command: {{ printf "[\"%s\"]" (join ("\", \"") (without (splitList " " .command) "" )) }}
  {{- else }}
  command: {{- include "helpers.tplvalues.render" ( dict "value" .command "context" $) | nindent 2 }}
  {{- end }}
  {{- end }}
  {{- include "helpers.workloads.envs" (dict "value" . "general" $general "context" $) | indent 2 }}
  {{- include "helpers.workloads.envsFrom" (dict "value" . "general" $general "context" $) | indent 2 }}
  {{- with .ports }}
  ports: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 2 }}
  {{- end }}
  {{- with .lifecycle }}
  lifecycle: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with .startupProbe }}
  startupProbe: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with .livenessProbe }}
  livenessProbe: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with .readinessProbe }}
  readinessProbe: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with .resources }}
  resources: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  volumeMounts: {{- include "helpers.volumes.renderVolumeMounts" (dict "value" . "general" $general "context" $) | nindent 2 }}
{{- end }}
volumes: {{- include "helpers.volumes.renderVolume" (dict "value" . "general" $general "context" $) -}}
{{- end -}}
{{- end -}}
