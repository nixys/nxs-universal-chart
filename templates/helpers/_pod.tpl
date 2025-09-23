{{- define "helpers.pod" -}}
{{- $ctx := .context -}}
{{- $general := .general -}}
{{- $extraLabels := .extraLabels -}}
{{- $usePredefinedAffinity := $ctx.Values.generic.usePredefinedAffinity -}}
{{- if (ne $general.usePredefinedAffinity nil) }}{{ $usePredefinedAffinity = $general.usePredefinedAffinity }}{{ end -}}
{{- $name := .name -}}
{{- with .value -}}
{{- if .serviceAccountName }}
serviceAccountName: {{ include "helpers.app.fullname" (dict "name" .serviceAccountName "context" $ctx) }}
{{- else if $ctx.Values.generic.serviceAccountName }}
serviceAccountName: {{ include "helpers.app.fullname" (dict "name" $.Values.generic.serviceAccountName "context" $ctx) }}
{{- end }}
{{- if hasKey . "automountServiceAccountToken" }}
automountServiceAccountToken: {{ .automountServiceAccountToken }}
{{- else if hasKey $ctx.Values.generic "automountServiceAccountToken" }}
automountServiceAccountToken: {{ $ctx.Values.generic.automountServiceAccountToken }}
{{- end }}
{{- if .hostAliases }}
hostAliases: {{- include "helpers.tplvalues.render" (dict "value" .hostAliases "context" $ctx) | nindent 2 }}
{{- else if $ctx.Values.generic.hostAliases }}
hostAliases: {{- include "helpers.tplvalues.render" (dict "value" $.Values.generic.hostAliases "context" $ctx) | nindent 2 }}
{{- end }}
{{- if .affinity }}
affinity: {{- include "helpers.tplvalues.render" ( dict "value" .affinity "context" $ctx) | nindent 2 }}
{{- else if $general.affinity }}
affinity: {{- include "helpers.tplvalues.render" ( dict "value" $general.affinity "context" $ctx) | nindent 2 }}
{{- else if $usePredefinedAffinity }}
affinity:
  nodeAffinity: {{- include "helpers.affinities.nodes" (dict "type" $ctx.Values.nodeAffinityPreset.type "key" $ctx.Values.nodeAffinityPreset.key "values" $ctx.Values.nodeAffinityPreset.values "context" $ctx) | nindent 4 }}
  podAffinity: {{- include "helpers.affinities.pods" (dict "type" $ctx.Values.podAffinityPreset "extraLabels" $extraLabels "context" $ctx) | nindent 4 }}
  podAntiAffinity: {{- include "helpers.affinities.pods" (dict "type" $ctx.Values.podAntiAffinityPreset "extraLabels" $extraLabels "context" $ctx) | nindent 4 }}
{{- end }}
{{- if .priorityClassName }}
priorityClassName: {{ .priorityClassName }}
{{- else if $ctx.Values.generic.priorityClassName }}
priorityClassName: {{ $ctx.Values.generic.priorityClassName }}
{{- end }}
{{- if .dnsPolicy }}
dnsPolicy: {{ .dnsPolicy }}
{{- else if $ctx.Values.generic.dnsPolicy }}
dnsPolicy: {{ $ctx.Values.generic.dnsPolicy }}
{{- end }}
{{- with .nodeSelector }}
nodeSelector: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 2 }}
{{- end }}

{{- $combined := .tolerations | default ( $ctx.Values.generic.tolerations | default list ) }}
{{- if $combined }}
tolerations:
  {{- include "helpers.tplvalues.render" (dict "value" $combined "context" $ctx) | nindent 2 }}
{{- end }}

{{- include "helpers.securityContext" (dict "securityContext" .securityContext "genericSecurityContext" $ctx.Values.generic.podSecurityContext "context" $ctx) }}

{{ if or $ctx.Values.imagePullSecrets $ctx.Values.generic.extraImagePullSecrets .extraImagePullSecrets .imagePullSecrets }}
imagePullSecrets:
{{- range $sName, $v := $ctx.Values.imagePullSecrets }}
- name: {{ $sName }}
{{- end }}
{{- with .imagePullSecrets }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) | nindent 0 }}{{- end }}
{{- with .extraImagePullSecrets }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) | nindent 0 }}{{- end }}
{{- with $ctx.Values.generic.extraImagePullSecrets }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) | nindent 0 }}{{- end }}
{{- end }}
{{- if .terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ .terminationGracePeriodSeconds }}
{{- end }}
{{- with .initContainers}}
initContainers:
{{- range . }}
  {{- with .name }}
- name: {{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}
  {{- else }}
- name: {{ printf "%s-init-%s" $name (lower (randAlphaNum 5)) }}
  {{- end }}
  {{- $image := $ctx.Values.defaultImage }}{{ with .image }}{{ $image = include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
  {{- $imageTag := $ctx.Values.defaultImageTag }}{{ with .imageTag }}{{ $imageTag = include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
  image: {{ $image }}:{{ $imageTag }}
  imagePullPolicy: {{ .imagePullPolicy | default $ctx.Values.defaultImagePullPolicy }}
  {{- include "helpers.securityContext" (dict "securityContext" .securityContext "genericSecurityContext" $ctx.Values.generic.containerSecurityContext "context" $ctx) | nindent 2 }}
  {{- if $ctx.Values.diagnosticMode.enabled }}
  args: {{- include "helpers.tplvalues.render" ( dict "value" $ctx.Values.diagnosticMode.args "context" $ctx) | nindent 2 }}
  {{- else if .args }}
  args: {{- include "helpers.tplvalues.render" ( dict "value" .args "context" $ctx) | nindent 2 }}
  {{- end }}
  {{- if $ctx.Values.diagnosticMode.enabled }}
  command: {{- include "helpers.tplvalues.render" ( dict "value" $ctx.Values.diagnosticMode.command "context" $ctx) | nindent 2 }}
  {{- else if .command }}
  {{- if typeIs "string" .command }}
  command: {{ printf "[\"%s\"]" (join ("\", \"") (without (splitList " " .command) "" )) }}
  {{- else }}
  command: {{- include "helpers.tplvalues.render" ( dict "value" .command "context" $ctx) | nindent 2 }}
  {{- end }}
  {{- end }}
  {{- include "helpers.workloads.envs" (dict "value" . "context" $ctx) | indent 2 }}
  {{- include "helpers.workloads.envsFrom" (dict "value" . "context" $ctx) | indent 2 }}
  {{- with .ports }}
  ports: {{- include "helpers.tplvalues.renderAndCoerce" ( dict "value" . "context" $ctx) | nindent 2 }}
  {{- end }}
  {{- with .lifecycle }}
  lifecycle: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) | nindent 4 }}
  {{- end }}
  {{- with .startupProbe }}
  startupProbe: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) | nindent 4 }}
  {{- end }}
  {{- with .livenessProbe }}
  livenessProbe: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) | nindent 4 }}
  {{- end }}
  {{- with .readinessProbe }}
  readinessProbe: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) | nindent 4 }}
  {{- end }}
  {{- with .resources }}
  resources: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) | nindent 4 }}
  {{- end }}
  volumeMounts: {{- include "helpers.volumes.renderVolumeMounts" (dict "value" . "general" $general "context" $ctx) | nindent 2 }}
{{- end }}{{- end }}
containers:
{{- range .containers }}
  {{- with .name }}
- name: {{ include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}
  {{- else }}
- name: {{ printf "%s-%s" $name (lower (randAlphaNum 5)) }}
  {{- end }}
  {{- $image := $ctx.Values.defaultImage }}{{ with .image }}{{ $image = include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
  {{- $imageTag := $ctx.Values.defaultImageTag }}{{ with .imageTag }}{{ $imageTag = include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{ end }}
  image: {{ $image }}:{{ $imageTag }}
  imagePullPolicy: {{ .imagePullPolicy | default $ctx.Values.defaultImagePullPolicy }}
  {{- include "helpers.securityContext" (dict "securityContext" .securityContext "genericSecurityContext" $ctx.Values.generic.containerSecurityContext "context" $ctx) | nindent 2 }}
  {{- if $ctx.Values.diagnosticMode.enabled }}
  args: {{- include "helpers.tplvalues.render" ( dict "value" $ctx.Values.diagnosticMode.args "context" $ctx) | nindent 2 }}
  {{- else if .args }}
  args: {{- include "helpers.tplvalues.render" ( dict "value" .args "context" $ctx) | nindent 2 }}
  {{- end }}
  {{- if $ctx.Values.diagnosticMode.enabled }}
  command: {{- include "helpers.tplvalues.render" ( dict "value" $ctx.Values.diagnosticMode.command "context" $ctx) | nindent 2 }}
  {{- else if .command }}
  {{- if typeIs "string" .command }}
  command: {{ printf "[\"%s\"]" (join ("\", \"") (without (splitList " " .command) "" )) }}
  {{- else }}
  command: {{- include "helpers.tplvalues.render" ( dict "value" .command "context" $ctx) | nindent 2 }}
  {{- end }}
  {{- end }}
  {{- include "helpers.workloads.envs" (dict "value" . "general" $general "context" $ctx) | indent 2 }}
  {{- include "helpers.workloads.envsFrom" (dict "value" . "general" $general "context" $ctx) | indent 2 }}
  {{- with .ports }}
  ports: {{- include "helpers.tplvalues.renderAndCoerce" ( dict "value" . "context" $ctx) | nindent 2 }}
  {{- end }}
  {{- $lifecycle := merge (default (dict) .lifecycle) (default (dict) $ctx.Values.generic.lifecycle) -}}
  {{- $startupProbe := merge (default (dict) .startupProbe) (default (dict) $ctx.Values.generic.startupProbe) -}}
  {{- $livenessProbe := merge (default (dict) .livenessProbe) (default (dict) $ctx.Values.generic.livenessProbe) -}}
  {{- $readinessProbe := merge (default (dict) .readinessProbe) (default (dict) $ctx.Values.generic.readinessProbe) -}}
  {{- with $lifecycle }}
  lifecycle: {{- include "helpers.tplvalues.render" ( dict "value" $lifecycle "context" $ctx) | nindent 4 }}
  {{- end }}
  {{- with $startupProbe }}
  startupProbe: {{- include "helpers.tplvalues.render" ( dict "value" $startupProbe "context" $ctx) | nindent 4 }}
  {{- end }}
  {{- with $livenessProbe }}
  livenessProbe: {{- include "helpers.tplvalues.render" ( dict "value" $livenessProbe "context" $ctx) | nindent 4 }}
  {{- end }}
  {{- with $readinessProbe }}
  readinessProbe: {{- include "helpers.tplvalues.render" ( dict "value" $readinessProbe "context" $ctx) | nindent 4 }}
  {{- end }}
  {{- with .resources }}
  resources: {{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) | nindent 4 }}
  {{- end }}
  volumeMounts: {{- include "helpers.volumes.renderVolumeMounts" (dict "value" . "general" $general "context" $ctx) | nindent 2 }}
{{- end }}
volumes: {{- include "helpers.volumes.renderVolume" (dict "value" . "general" $general "context" $ctx) -}}
{{- end -}}
{{- end -}}
