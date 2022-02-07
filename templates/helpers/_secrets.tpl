{{- define "helpers.secrets.includeEnv" -}}
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
    secretKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ $envKey }}
{{- else if kindIs "map" $envKey -}}
{{- range $keyName, $key := $envKey }}
- name: {{ $keyName }}
  valueFrom:
    secretKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.secrets.includeEnvSecret" -}}
{{- $ctx := .context -}}
{{- range $i, $sName := .value }}
- secretRef:
    name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
{{- end -}}
{{- end -}}

{{- define "helpers.secrets.encode" -}}
{{if hasPrefix "b64:" .value}}{{trimPrefix "b64:" .value}}{{else}}{{toString .value|b64enc}}{{end}}
{{- end -}}

{{- define "helpers.secrets.render" -}}
{{- $v := dict -}}
{{- if kindIs "string" .value -}}
{{- $v = fromYaml .value }}
{{- else -}}
{{- $v = .value }}
{{- end -}}
{{- range $key, $value := $v }}
{{- if kindIs "string" $value }}
{{ printf "%s: %s" $key (include "helpers.secrets.encode" (dict "value" $value)) }}
{{- else }}
{{ $key }}: {{$value | toJson | b64enc }}
{{- end -}}
{{- end -}}
{{- end -}}
