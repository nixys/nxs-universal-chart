{{- define "helpers.deprecation.notice" -}}
** NOTICE **

Option `imagePullSecrets` for workloads deprecated and will be removed in the future releases.
Please use `extraImagePullSecrets` instead.
{{- end }}


{{- define "helpers.deprecation.workload.imagePullSecrets" -}}
{{- range $name, $wkl := .Values.deployments }}{{- if $wkl.imagePullSecrets }}

** WARNING **

You use deprecated option `imagePullSecrets` for deployment "{{$name}}". Please use `extraImagePullSecrets` instead.
{{- end }}{{ end }}
{{- range $name, $wkl := .Values.hooks }}{{- if $wkl.imagePullSecrets }}

** WARNING **

You use deprecated option `imagePullSecrets` for hook "{{$name}}". Please use `extraImagePullSecrets` instead.
{{- end }}{{ end }}
{{- range $name, $wkl := .Values.cronJobs }}{{- if $wkl.imagePullSecrets }}

** WARNING **

You use deprecated option `imagePullSecrets` for cronjob "{{$name}}". Please use `extraImagePullSecrets` instead.
{{- end }}{{ end }}
{{- range $name, $wkl := .Values.jobs }}{{- if $wkl.imagePullSecrets }}

** WARNING **

You use deprecated option `imagePullSecrets` for job "{{$name}}". Please use `extraImagePullSecrets` instead.
{{- end }}{{ end }}
{{ end }}