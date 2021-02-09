{{- define "app.labels" -}}
helm.sh/chart: {{ include "helpers.app.chart" . }}
{{ include "app.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helpers.app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}