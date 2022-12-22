{{- define "helpers.pvc" -}}
{{- $ := .context -}}
{{- with .value -}}

accessModes: {{- include "helpers.tplvalues.render" ( dict "value" .accessModes "context" $ ) | nindent 2 }}
{{- with .volumeMode }}
volumeMode: {{ . }}
{{- end }}
resources:
  requests:
    storage: {{ .size | default "1Gi" }}
{{- with .storageClassName }}
storageClassName: {{ . }}
{{- end }}
{{- with .selector }}
  {{- include "helpers.tplvalues.render" ( dict "value" . "context" $ ) | nindent 4 }}
{{- end }}

{{- end -}}
{{- end -}}