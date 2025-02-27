{{- define "helpers.volumes.typed" -}}
{{- $ctx := .context -}}
{{- range .volumes -}}
{{- if eq .type "configMap" }}
{{- if eq .type "configMap" }}
- name: {{ tpl .name $ctx }}
  configMap:
    {{- with .originalName }}
    name: {{ tpl . $ctx }}
    {{- else }}
    name: {{ include "helpers.app.fullname" (dict "name" .name "context" $ctx) }}
    {{- end }}
    {{- with .defaultMode }}
    defaultMode: {{ tpl . $ctx }}
    {{- end }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 4 }}
    {{- end }}
{{- else if eq .type "secret" }}
- name: {{ tpl .name $ctx }}
  secret:
    {{- with .originalName }}
    secretName: {{ tpl . $ctx }}
    {{- else }}
    secretName: {{ include "helpers.app.fullname" (dict "name" .name "context" $ctx) }}
    {{- end }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 4 }}
    {{- end }}
{{- else if eq .type "pvc" }}
- name: {{ tpl .name $ctx }}
  persistentVolumeClaim:
    {{- with .originalName }}
    claimName: {{ tpl . $ctx }}
    {{- else }}
    claimName: {{ include "helpers.tplvalues.render" (dict "value" .name "context" $ctx) }}
    {{- end }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 4 }}
    {{- end }}
{{- else if eq .type "emptyDir" }}
- name: {{ .name }}
  {{- if or .sizeLimit .medium }}
  emptyDir:
    {{- if .sizeLimit }}
    sizeLimit: {{ .sizeLimit }}
    {{- end }}
    {{- if .medium }}
    medium: {{ .medium }}
    {{- end }}
  {{- else }}
  emptyDir: {}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "helpers.volumes.renderVolume" -}}
{{- $ctx := .context -}}
{{- $general := .general -}}
{{- $val := .value -}}
{{- if or (or $val.volumes $val.extraVolumes) (or (or $general.extraVolumes $ctx.Values.generic.extraVolumes) (or $general.volumes $ctx.Values.generic.volumes)) }}
{{ with $val.volumes }}{{ include "helpers.volumes.typed" ( dict "volumes" . "context" $ctx) }}{{ end }}
{{ with $general.volumes }}{{ include "helpers.volumes.typed" ( dict "volumes" . "context" $ctx) }}{{ end }}
{{ with $ctx.Values.generic.volumes }}{{ include "helpers.volumes.typed" ( dict "volumes" . "context" $ctx) }}{{ end }}
{{ with $val.extraVolumes }}{{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
{{ with $general.extraVolumes }}{{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
{{ with $ctx.Values.generic.extraVolumes }}{{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
{{- else }}
  []
{{- end }}
{{- end }}

{{- define "helpers.volumes.renderVolumeMounts" -}}
{{- $ctx := .context -}}
{{- $general := .general -}}
{{- $val := .value -}}
{{- if or (or $val.volumeMounts $general.extraVolumeMounts) (or $ctx.Values.generic.extraVolumeMounts (or $general.volumeMounts $ctx.Values.generic.volumeMounts)) -}}
{{ with $val.volumeMounts }}{{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
{{ with $general.volumeMounts }}{{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
{{ with $general.extraVolumeMounts }}{{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
{{ with $ctx.Values.generic.volumeMounts }}{{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
{{ with $ctx.Values.generic.extraVolumeMounts }}{{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
{{- else }}
  []
{{- end }}
{{- end }}
