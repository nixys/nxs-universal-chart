{{- define "helpers.secrets.include" -}}
{{- if .Values.generic.secretEnvs }}
{{- if typeIs "string" .Values.generic.secretEnvs -}}
{{- range $key, $v := fromYaml .Values.generic.secretEnvs -}}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-secret-envs
      key: {{ $key }}
{{- end -}}
{{- else -}}
{{- range $key, $v := .Values.generic.secretEnvs -}}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-secret-env
      key: {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.secrets.includeEnv" -}}
{{- $ctx := .context -}}
{{- if typeIs "string" .value -}}
{{- range $sName, $envKeys := fromYaml .value -}}
{{- range $envKeys }}
{{ include "helpers.secrets.renderIncludeEnv" (dict "sName" $sName "envKey" . "context" $ctx) }}
{{- end -}}
{{- end -}}
{{- else if kindIs "map" .value -}}
{{- range $sName, $envKeys := .value -}}
{{- range $envKeys }}
{{ include "helpers.secrets.renderIncludeEnv" (dict "sName" $sName "envKey" . "context" $ctx) }}
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

{{- define "helpers.secrets.renderIncludeEnv" -}}
{{- $sName := .sName -}}
{{- $ctx := .context -}}
{{- if kindIs "string" .envKey -}}
- name: {{ .envKey }}
  valueFrom:
    secretKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ .envKey }}
{{- else if kindIs "map" .envKey -}}
{{- range $envName, $sKey := .envKey -}}
- name: {{ $envName }}
  valueFrom:
    secretKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ $sKey }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.secrets.encode" -}}
{{if hasPrefix "b64:" .value}}{{trimPrefix "b64:" .value}}{{else}}{{toString .value|b64enc}}{{end}}
{{- end -}}

{{- define "helpers.secrets.render" -}}
{{- if kindIs "string" .value -}}
{{- range $key, $value := fromYaml .value }}
{{- if kindIs "string" $value }}
{{ printf "%s: %s" $key (include "helpers.secrets.encode" (dict "value" $value)) }}
{{- else }}
{{ $key }}: {{$value | toJson | b64enc }}
{{- end -}}
{{- end -}}
{{- else -}}
{{- range $key, $value := .value }}
{{- if kindIs "string" $value }}
{{ printf "%s: %s" $key (include "helpers.secrets.encode" (dict "value" $value)) }}
{{- else }}
{{ $key }}: {{$value | toJson | b64enc }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.secretFiles.subPaths" -}}
{{- $str := "" -}}
{{- $previous := "" -}}
{{- range $path, $_ := $.Files.Glob ("extra-files/secret/**") -}}
{{- $subPath := (printf "%s" (index (split "/" (trimPrefix "/" (trimPrefix "extra-files/config" (dir $path)))) "_0")) | default "extra-files" -}}
{{- if not (eq $previous $subPath) -}}
{{- $str = printf "%s$%s" $str $subPath -}}
{{- $previous = $subPath -}}
{{- end -}}
{{- end -}}
{{- trimPrefix "$" $str -}}
{{- end -}}
