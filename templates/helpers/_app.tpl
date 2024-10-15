{{- define "helpers.app.name" -}}
{{- if and .Values.parentChart .Values.parentChart.name -}}
  {{- .Values.parentChart.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- include "helpers.app.release.name" .context -}}
{{- end -}}
{{- end -}}

{{/*
Chart release name
*/}}
{{- define "helpers.app.release.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helpers.app.chart" -}}
{{- if and .Values.parentChart .Values.parentChart.name .Values.parentChart.version -}}
  {{- printf "%s-%s" .Values.parentChart.name .Values.parentChart.version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart version as used by the chart label.
*/}}
{{- define "helpers.app.chart.version" -}}
{{- if .Chart.AppVersion }}
{{ .Chart.AppVersion | quote }}
{{- else -}}
{{- if and .Values.parentChart .Values.parentChart.version -}}
  {{ .Values.parentChart.version | quote }}
{{- else -}}
  {{ .Chart.version | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helpers.app.fullname" -}}
{{- if .name -}}
{{- if .context.Values.releasePrefix -}}
{{- printf "%s-%s" .context.Values.releasePrefix .name | trunc 63 | trimAll "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "helpers.app.release.name" .context) .name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- include "helpers.app.name" .context -}}
{{- end -}}
{{- end -}}


{{- define "helpers.app.labels" -}}
{{ include "helpers.app.selectorLabels" . }}
helm.sh/chart: {{ include "helpers.app.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ include "helpers.app.chart.version" . }}
{{ include "helpers.app.genericLabels" $ }}
{{- end }}


{{- define "helpers.app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helpers.app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{ include "helpers.app.genericSelectorLabels" $ }}
{{- end }}

{{- define "helpers.app.genericLabels" -}}
{{- with .Values.generic.labels }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" .) }}
{{- end }}
{{- end }}

{{- define "helpers.app.genericSelectorLabels" -}}
{{- with .Values.generic.extraSelectorLabels }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" .) }}
{{- end }}
{{- end }}

{{- define "helpers.app.genericAnnotations" -}}
{{- with .Values.generic.annotations }}
{{ include "helpers.tplvalues.render" (dict "value" . "context" $) }}
{{- end }}
{{- end }}

{{- define "helpers.app.hooksAnnotations" -}}
helm.sh/hook: "pre-install,pre-upgrade"
helm.sh/hook-weight: "-999"
helm.sh/hook-delete-policy: before-hook-creation
{{- end }}
