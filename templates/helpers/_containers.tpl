{{- define "helpers.containers" -}}
{{- $ := .context -}}
{{- $general := .general -}}
{{- $name := .name -}}
{{- $type := .type -}}
{{- range .value }}
  {{- if .name }}
- name: {{ include "helpers.tplvalues.render" ( dict "value" .name "context" $) }}
  {{- else if eq $type "init" }}
- name: {{ printf "%s-init-%s" $name (lower (randAlphaNum 5)) }}
  {{- else }}
- name: {{ printf "%s-%s" $name (lower (randAlphaNum 5)) }}
  {{- end }}
  {{- if not (hasKey . "image") }}
  {{- $_ := set . "image" $.Values.image }}
  {{- end }}
  image: {{ include "helpers.image" (dict "image" .image "context" $) }}
  imagePullPolicy: {{ default "IfNotPresent" $.Values.image.pullPolicy .image.pullPolicy }}
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
  {{- if eq $type "init" }}
  {{- include "helpers.workloads.envs" (dict "value" . "context" $) | indent 2 }}
  {{- include "helpers.workloads.envsFrom" (dict "value" . "context" $) | indent 2 }}
  {{- else }}
  {{- include "helpers.workloads.envs" (dict "value" . "general" $general "context" $) | indent 2 }}
  {{- include "helpers.workloads.envsFrom" (dict "value" . "general" $general "context" $) | indent 2 }}
  {{- end }}
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
{{- end }}