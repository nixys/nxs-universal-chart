{{- define "helpers.volumes.typed" -}}
{{- $ctx := .context -}}
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
{{- end }}

{{- define "helpers.volumes.mount" -}}
{{- $ctx := .context -}}
{{- range .mounts }}
- name: {{ .name }}
  mountPath: {{ .mountPath }}
  {{- with .subPath }}
  subPath: {{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}
  {{- end }}
  {{- with .readOnly }}
  readOnly: {{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "helpers.volumes.renderVolume" -}}
{{- $ctx := .context -}}
{{- $general := .general -}}
{{- $val := .value -}}
{{- if or (or $val.volumes $val.extraVolumes) (or $general.extraVolumes $ctx.Values.generic.extraVolumes) }}
{{- with $val.volumes }}{{- include "helpers.volumes.typed" ( dict "volumes" . "context" $ctx) }}{{- end }}
{{- with $val.extraVolumes }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{- with $general.extraVolumes }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{- with $ctx.Values.generic.extraVolumes }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{- else }}
  []
{{- end }}
{{- end }}

{{- define "helpers.volumes.renderVolumeMounts" -}}
{{- $ctx := .context -}}
{{- $general := .general -}}
{{- $val := .value -}}
{{- if or (or $val.volumeMounts $general.extraVolumeMounts) $ctx.Values.generic.extraVolumeMounts }}
{{- with $val.volumeMounts -}}{{- include "helpers.volumes.mount" (dict "mounts" . "context" $ctx) }}{{- end }}
{{- with $val.extraVolumeMounts -}}{{- include "helpers.volumes.mount" (dict "mounts" . "context" $ctx) }}{{- end }}
{{- with $general.extraVolumeMounts -}}{{- include "helpers.volumes.mount" (dict "mounts" . "context" $ctx) }}{{- end }}
{{- with $ctx.Values.generic.extraVolumeMounts -}}{{- include "helpers.volumes.mount" (dict "mounts" . "context" $ctx) }}{{- end -}}
{{- else }}
  []
{{- end }}
{{- end }}
