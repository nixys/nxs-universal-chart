{{- define "helpers.pod" -}}
{{- $ := .context -}}
{{- $general := .general -}}
{{- $extraLabels := .extraLabels -}}
{{- $usePredefinedAffinity := $.Values.generic.usePredefinedAffinity -}}
{{- if (ne $general.usePredefinedAffinity nil) }}{{ $usePredefinedAffinity = $general.usePredefinedAffinity }}{{ end -}}
{{- $name := .name -}}
{{- with .value -}}
{{- if .serviceAccountName }}
serviceAccountName: {{- include "helpers.tplvalues.render" (dict "value" .serviceAccountName "context" $) | nindent 2 }}
{{- else if $.Values.generic.serviceAccountName }}
serviceAccountName: {{- include "helpers.tplvalues.render" (dict "value" $.Values.generic.serviceAccountName  "context" $) | nindent 2 }}
{{- end }}
{{- if .hostAliases }}
hostAliases: {{- include "helpers.tplvalues.render" (dict "value" .hostAliases "context" $) | nindent 2 }}
{{- else if $.Values.generic.hostAliases }}
hostAliases: {{- include "helpers.tplvalues.render" (dict "value" $.Values.generic.hostAliases "context" $) | nindent 2 }}
{{- end }}
{{- if .affinity }}
affinity: {{- include "helpers.tplvalues.render" ( dict "value" .affinity "context" $) | nindent 2 }}
{{- else if $usePredefinedAffinity }}
affinity:
  nodeAffinity: {{- include "helpers.affinities.nodes" (dict "type" $.Values.nodeAffinityPreset.type "key" $.Values.nodeAffinityPreset.key "values" $.Values.nodeAffinityPreset.values "context" $) | nindent 4 }}
  podAffinity: {{- include "helpers.affinities.pods" (dict "type" $.Values.podAffinityPreset "extraLabels" $extraLabels "context" $) | nindent 4 }}
  podAntiAffinity: {{- include "helpers.affinities.pods" (dict "type" $.Values.podAntiAffinityPreset "extraLabels" $extraLabels "context" $) | nindent 4 }}
{{- end }}
{{- if .dnsPolicy }}
{{- if .priorityClassName }}
priorityClassName: {{ .priorityClassName }}
{{- else if $.Values.generic.priorityClassName }}
priorityClassName: {{ $.Values.generic.priorityClassName }}
{{- end }}
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
{{- with .terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
{{- end }}
volumes: {{- include "helpers.volumes.renderVolume" (dict "value" . "general" $general "context" $) }}
{{- with .initContainers}}
initContainers:
  {{- include "helpers.containers" (dict "value" . "type" "init"  "name" $name "general" $general "context" $) | indent 2 }}
{{ end }}
containers:
  {{- include "helpers.containers" (dict "value" .containers  "name" $name "general" $general "context" $) | indent 2 }}
{{- end -}}
{{- end -}}