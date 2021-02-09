{{/*Подключает секреты*/}}
{{- define "helpers.secrets.include" -}}
{{- if .Values.global.secretEnvs }}
{{- if typeIs "string" .Values.global.secretEnvs -}}
{{- range $key, $v := fromYaml .Values.global.secretEnvs }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-secret-env
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
{{ printf "%s: %s" $key (toString $value | b64enc) }}
{{- end -}}
{{- end -}}
{{- end -}}