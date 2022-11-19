{{- define "helpers.configmaps.renderConfigMap" -}}
{{- $v := dict -}}
{{- if typeIs "string" .value -}}
{{- $v = fromYaml .value -}}
{{- else if kindIs "map" .value -}}
{{- $v = .value -}}
{{- end -}}
{{- range $key, $value := $v }}
{{- if eq (typeOf $value) "float64" }}
{{ printf "%s: %s" $key (toString $value | quote) }}
{{- else if empty $value }}
{{ printf "%s: %s" $key ("" | quote) }}
{{- else if kindIs "string" $value }}
{{ printf "%s: %s" $key ($value | quote) }}
{{- else }}
{{ $key }}: {{$value | toJson | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.configmaps.includeEnv" -}}
{{- $ctx := .context -}}
{{- $s := dict -}}
{{- if typeIs "string" .value -}}
{{- $s = fromYaml .value -}}
{{- else if kindIs "map" .value -}}
{{- $s = .value -}}
{{- end -}}
{{- range $sName, $envKeys := $s -}}
{{- range $i, $envKey := $envKeys }}
{{- if kindIs "string" $envKey }}
- name: {{ $envKey }}
  valueFrom:
    configMapKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ $envKey }}
{{- else if kindIs "map" $envKey -}}
{{- range $keyName, $key := $envKey }}
- name: {{ $keyName }}
  valueFrom:
    configMapKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.configmaps.includeEnvConfigmap" -}}
{{- $ctx := .context -}}
{{- range $i, $sName := .value }}
- configMapRef:
    name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
{{- end -}}
{{- end -}}