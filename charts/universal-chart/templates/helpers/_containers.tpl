{{- define "helpers.containers.containers" -}}
{{- $ := .context -}}
{{- $general := .general -}}
{{- $name := .name -}}
{{- $type := .type -}}{{/* must be 'initContainers:' or 'containers:' */}}
{{/*
Use this line (comment) for debug:
{{ (. | toYaml) }}
*/}}
{{- with .value -}}
{{/* containers is a slice (list) */}}
{{/* https://stackoverflow.com/a/71797701/4474332 */}}
{{- if and . (kindIs "slice" .) -}}
{{- with . -}}
{{- printf "%s" $type }}:
{{- range . }}
- name: {{ .name | default (printf "%s-%s" $name (lower (randAlphaNum 5))) | quote }}
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
{{- end }}{{- end }}{{/* end range & with */}}
{{/* !!! containers is a map (dict): */}}
{{- else if and . (kindIs "map" .) }}{{/* start if & range */}}
{{- printf "%s" $type }}:
{{- range $nameContainer, $container := . }}
- name: {{ $nameContainer | quote }}
  {{- $image := $.Values.defaultImage }}{{ with .image }}{{ $image = include "helpers.tplvalues.render" ( dict "value" . "context" $) }}{{ end }}
  {{- $imageTag := $.Values.defaultImageTag }}{{ with .imageTag }}{{ $imageTag = include "helpers.tplvalues.render" ( dict "value" . "context" $) }}{{ end }}
  image: {{ $image }}:{{ $imageTag }}
  imagePullPolicy: {{ .imagePullPolicy | default $.Values.defaultImagePullPolicy }}  {{- with .securityContext }}
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
{{- end }}{{/* end if & range */}}
{{- end }}{{/* end if and .containers .. */}}
{{- end }}{{/* end with .. */}}
{{- end }}{{/* end define .. */}}
