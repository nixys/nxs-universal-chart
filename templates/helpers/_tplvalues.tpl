{{- define "helpers.tplvalues.render" -}}
{{- if typeIs "string" .value }}
{{- tpl (.value | quote) .context }}
{{- else }}
{{- tpl (.value | toYaml) .context }}
{{- end }}
{{- end -}}
