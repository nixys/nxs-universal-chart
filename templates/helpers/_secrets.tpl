{{/*Подключает секреты*/}}
{{- define "helpers.secrets.include" -}}
{{- if .Values.generic.secretEnvs }}
{{- if typeIs "string" .Values.generic.secretEnvs -}}
{{- range $key, $v := fromYaml .Values.generic.secretEnvs }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-secret-envs
      key: {{ $key }}
{{- end -}}
{{- else -}}
{{- range $key, $v := .Values.generic.secretEnvs }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-secret-env
      key: {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.secrets.encode" -}}
{{if hasPrefix "b64:" .value}}{{trimPrefix "b64:" .value}}{{else}}{{toString .value|b64enc}}{{end}}
{{- end -}}

{{- define "helpers.secrets.render" -}}
{{- if typeIs "string" .value -}}
{{- range $key, $value := fromYaml .value }}
{{ printf "%s: %s" $key (include "helpers.secrets.encode" (dict "value" $value)) }}
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
