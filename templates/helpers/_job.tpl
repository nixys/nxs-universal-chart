{{- define "helpers.job" -}}
{{- $ := .context -}}
{{- $general := .general -}}
{{- $name := .name -}}
{{- with .value -}}
{{- if any .parallelism $general.parallelism }}
parallelism: {{ default $general.parallelism .parallelism }}
{{- end }}
{{- if any .completions $general.completions }}
completions: {{ default $general.completions .completions }}
{{- end }}
{{- if any .activeDeadlineSeconds $general.activeDeadlineSeconds }}
activeDeadlineSeconds: {{ default $general.activeDeadlineSeconds .activeDeadlineSeconds }}
{{- end }}
backoffLimit: {{ default 6 $general.backoffLimit .backoffLimit }}
{{- if any .ttlSecondsAfterFinished $general.ttlSecondsAfterFinished }}
ttlSecondsAfterFinished: {{ default $general.ttlSecondsAfterFinished .ttlSecondsAfterFinished }}
{{- end }}
template:
  metadata:
    labels:
      {{- with $.Values.generic.podLabels }}{{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 6 }}{{- end }}
      {{- with .podLabels }}{{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 6 }}{{- end }}
    annotations:
      {{- with $.Values.generic.podAnnotations }}{{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 6 }}{{- end }}
      {{- with .podAnnotations }}{{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 6 }}{{- end }}
  spec:
    {{- include "helpers.pod" (dict "value" . "general" $general "name" $name "context" $) | indent 4 }}
    restartPolicy: {{ .restartPolicy | default "Never" }}
{{- end -}}
{{- end -}}