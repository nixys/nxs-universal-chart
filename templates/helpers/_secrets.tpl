{{/*Подключает секреты*/}}
{{- define "helpers.secrets.include" -}}
{{- if .Values.global.secretEnvs }}
{{- if typeIs "string" .Values.global.secretEnvs -}}
{{- range $key, $v := fromYaml .Values.global.secretEnvs }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-secret-envs
      key: {{ $key }}
{{- end -}}
{{- else -}}
{{- range $key, $v := .Values.global.secretEnvs }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-secret-env
      key: {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.secrets.render" -}}
{{- if typeIs "string" .value -}}
{{- range $key, $value := fromYaml .value }}
{{ printf "%s: %s" $key (toString $value | b64enc) }}
{{- end -}}
{{- else -}}
{{- range $key, $value := .value }}
{{- if kindIs "string" $value }}
{{ printf "%s: %s" $key (toString $value | b64enc) }}
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
