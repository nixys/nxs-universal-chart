{{- define "helpers.incompatibleChanges.serviceMonitors" -}}
{{- if .Values.servicemonitors }}

** WARNING **

Option `servicemonitors`  has been renamed to `serviceMonitors`. Please fix it in your values.
{{- end }}
{{ end }}
