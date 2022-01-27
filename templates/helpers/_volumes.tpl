{{- define "helpers.volumes.templated" -}}
{{- $ctx := .context }}
{{- range .volumes }}
{{- if eq .type "configMap" }}
- name: {{ .name }}
  configMap:
    {{- with .nameOverride }}
    name: {{ . }}
    {{- else }}
    name: {{ include "helpers.app.fullname" (dict "name" .name "context" $ctx) }}
    {{- end }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 4 }}
    {{- end }}
{{- else if eq .type "secret" }}
- name: {{ .name }}
  secret:
    {{- with .nameOverride }}
    secretName: {{ . }}
    {{- else }}
    secretName: {{ include "helpers.app.fullname" (dict "name" .name "context" $ctx) }}
    {{- end }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 4 }}
    {{- end }}
{{- else if eq .type "pvc" }}
- name: {{ .name }}
  persistentVolumeClaim:
    {{- with .nameOverride }}
    claimName: {{ . }}
    {{- else }}
    claimName:  {{ include "helpers.app.fullname" (dict "name" .name "context" $ctx) }}
    {{- end }}
{{- end }}
{{- end }}
{{- end -}}
