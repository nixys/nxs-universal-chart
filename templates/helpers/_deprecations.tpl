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


{{- define "helpers.deprecation.extraVolumeMounts" -}}
{{- if .Values.generic.extraVolumeMounts }}

** WARNING **

You use deprecated option `generic.extraVolumeMounts`. Please use `generic.volumeMounts` instead.
{{- end }}
{{- if .Values.deploymentsGeneral.extraVolumeMounts }}

** WARNING **

You use deprecated option `deploymentsGeneral.extraVolumeMounts`. Please use `deploymentsGeneral.volumeMounts` instead.
{{- end }}
{{- if .Values.statefulSetsGeneral.extraVolumeMounts }}

** WARNING **

You use deprecated option `statefulSetsGeneral.extraVolumeMounts`. Please use `statefulSetsGeneral.volumeMounts` instead.
{{- end }}
{{- if .Values.hooksGeneral.extraVolumeMounts }}

** WARNING **

You use deprecated option `hooksGeneral.extraVolumeMounts`. Please use `hooksGeneral.volumeMounts` instead.
{{- end }}
{{- if .Values.cronJobsGeneral.extraVolumeMounts }}

** WARNING **

You use deprecated option `cronJobsGeneral.extraVolumeMounts`. Please use `cronJobsGeneral.volumeMounts` instead.
{{- end }}
{{- if .Values.jobsGeneral.extraVolumeMounts }}

** WARNING **

You use deprecated option `jobsGeneral.extraVolumeMounts`. Please use `jobsGeneral.volumeMounts` instead.
{{- end }}
{{ end }}
