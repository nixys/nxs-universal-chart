{{- define "helpers.volumes.templated" -}}
{{- $ctx := .context }}
{{- range .volumes }}
{{- if eq .type "configMap" }}
- name: {{ .name }}
  configMap:
    name: {{ include "helpers.app.fullname" (dict "name" .name "context" $ctx) }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 4 }}
    {{- end }}
{{- else if eq .type "secret" }}
- name: {{ .name }}
  secret:
    secretName: {{ include "helpers.app.fullname" (dict "name" .name "context" $ctx) }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 4 }}
    {{- end }}
{{- end }}
{{- end }}
{{- end -}}
