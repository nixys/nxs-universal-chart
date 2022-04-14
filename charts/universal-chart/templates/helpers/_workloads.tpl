{{- define "helpers.workloads.envs" -}}
{{- $ctx := .context -}}
{{- $v := .value -}}
{{- if or (or $v.envsFromConfigmap $v.envsFromSecret) $v.env }}
env:
{{ with $v.envsFromConfigmap }}{{- include "helpers.configmaps.includeEnv" ( dict "value" . "context" $ctx) }}{{- end }}
{{- with $v.envsFromSecret }}{{- include "helpers.secrets.includeEnv" ( dict "value" . "context" $ctx) }}{{- end }}
{{- with $v.env }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{- end }}
{{- end }}

{{- define "helpers.workloads.envsFrom" -}}
{{- $ctx := .context -}}
{{- $v := .value -}}
{{- if or (or $v.envConfigmaps $v.envSecrets) $v.envFrom }}
envFrom:
{{ with $v.envConfigmaps }}{{- include "helpers.configmaps.includeEnvConfigmap" ( dict "value" . "context" $ctx) }}{{- end }}
{{- with $v.envSecrets }}{{- include "helpers.secrets.includeEnvSecret" ( dict "value" . "context" $ctx) }}{{- end }}
{{- with $v.envFrom }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{- end }}
{{- end }}

{{- define "helpers.workload.checksum" -}}
{{ . | toString | sha256sum }}
{{- end -}}
