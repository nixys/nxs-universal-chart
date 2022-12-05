{{- define "helpers.pod" -}}
{{- $ := .context -}}
{{- $general := .general -}}
{{- $name := .name -}}
{{- with .value -}}
{{- if .serviceAccountName }}
serviceAccountName: {{ .serviceAccountName }}
{{- else if $.Values.generic.serviceAccountName }}
serviceAccountName: {{ $.Values.generic.serviceAccountName }}
{{- end }}
{{- if .hostAliases }}
hostAliases: {{- include "helpers.tplvalues.render" (dict "value" .hostAliases "context" $) | nindent 2 }}
{{- else if $.Values.generic.hostAliases }}
hostAliases: {{- include "helpers.tplvalues.render" (dict "value" $.Values.generic.hostAliases "context" $) | nindent 2 }}
{{- end }}
{{- if or (eq $general.enableAffinity nil) (eq $general.enableAffinity true) }}
{{- if .affinity }}
affinity: {{- include "helpers.tplvalues.render" ( dict "value" .affinity "context" $) | nindent 2 }}
{{- else }}
{{- if $general.enableAffinity | default false }}
affinity:
  nodeAffinity: {{- include "helpers.affinities.nodes" (dict "type" $.Values.nodeAffinityPreset.type "key" $.Values.nodeAffinityPreset.key "values" $.Values.nodeAffinityPreset.values) | nindent 4 }}
  podAffinity: {{- include "helpers.affinities.pods" (dict "type" $.Values.podAffinityPreset "context" $) | nindent 4 }}
  podAntiAffinity: {{- include "helpers.affinities.pods" (dict "type" $.Values.podAntiAffinityPreset "context" $) | nindent 4 }}
{{- end }}
{{- end }}
{{- end }}
{{- if .dnsPolicy }}
dnsPolicy: {{ .dnsPolicy }}
{{- else if $.Values.generic.dnsPolicy }}
dnsPolicy: {{ $.Values.generic.dnsPolicy }}
{{- end }}
{{- with .nodeSelector }}
nodeSelector: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
{{- end }}
{{- with .tolerations }}
tolerations: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
{{- end }}
{{- with .securityContext }}
securityContext: {{- include "helpers.tplvalues.render" (dict "value" . "context" $) | nindent 2 }}
{{- end }}
{{ if or $.Values.imagePullSecrets $.Values.generic.extraImagePullSecrets .extraImagePullSecrets .imagePullSecrets }}
imagePullSecrets:
{{- range $sName, $v := $.Values.imagePullSecrets }}
- name: {{ $sName }}
{{- end }}
{{- with .imagePullSecrets }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 0 }}{{- end }}
{{- with .extraImagePullSecrets }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 0 }}{{- end }}
{{- with $.Values.generic.extraImagePullSecrets }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $) | nindent 0 }}{{- end }}
{{- end }}
{{- if .terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ .terminationGracePeriodSeconds }}
{{- end }}
{{/* include initContainers */}}
{{- include "helpers.containers.containers" (dict "type" "initContainers" "value" .initContainers "context" $ "general" $general "name" $name ) }}
{{/* include containers */}}
{{- include "helpers.containers.containers" (dict "type" "containers" "value" .containers "context" $ "general" $general "name" $name ) }}
volumes: {{- include "helpers.volumes.renderVolume" (dict "value" . "general" $general "context" $) -}}
{{- end -}}
{{- end -}}