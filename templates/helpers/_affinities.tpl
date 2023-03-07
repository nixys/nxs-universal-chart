{{- define "helpers.affinities.nodes.soft" -}}
{{- $ctx := .context -}}
preferredDuringSchedulingIgnoredDuringExecution:
- weight: 1
  preference:
    matchExpressions:
    - key: {{ include "helpers.tplvalues.render" (dict "value" .key "context" $ctx) }}
      operator: In
      values:
      {{- range .values }}
      {{- if typeIs "string" . }}
      - {{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | quote }}
      {{- else }}
      - {{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
      {{- end }}
      {{- end }}
{{- end -}}

{{- define "helpers.affinities.nodes.hard" -}}
{{- $ctx := .context -}}
requiredDuringSchedulingIgnoredDuringExecution:
  nodeSelectorTerms:
  - matchExpressions:
    - key: {{ include "helpers.tplvalues.render" (dict "value" .key "context" $ctx) }}
      operator: In
      values:
      {{- range .values }}
      {{- if typeIs "string" . }}
      - {{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | quote }}
      {{- else }}
      - {{ include "helpers.tplvalues.render" (dict "value" . "context" $ctx) }}
      {{- end }}
      {{- end }}
{{- end -}}

{{- define "helpers.affinities.nodes" -}}
{{- with .type -}}
{{- if eq . "soft" }}
{{- include "helpers.affinities.nodes.soft" $ -}}
{{- else if eq . "hard" }}
{{- include "helpers.affinities.nodes.hard" $ -}}
{{- end -}}
{{- else -}}
{}
{{- end -}}
{{- end -}}

{{- define "helpers.affinities.pods" -}}
{{- with .type -}}
{{- if eq . "soft" }}
{{- include "helpers.affinities.pods.soft" $ -}}
{{- else if eq . "hard" }}
{{- include "helpers.affinities.pods.hard" $ -}}
{{- end -}}
{{- else -}}
{}
{{- end -}}
{{- end -}}


{{- define "helpers.affinities.pods.soft" -}}
{{- $component := default "" .component -}}
preferredDuringSchedulingIgnoredDuringExecution:
- weight: 100
  podAffinityTerm:
    {{- include "helpers.affinities.pods.labelSelector" $ | nindent 4 }}
{{- end -}}

{{- define "helpers.affinities.pods.hard" -}}
requiredDuringSchedulingIgnoredDuringExecution:
- {{- include "helpers.affinities.pods.labelSelector" $ | nindent 2 }}
{{- end -}}

{{- define "helpers.affinities.pods.labelSelector" -}}
{{- $extraLabels := default "" .extraLabels -}}
labelSelector:
  matchLabels:
    {{- (include "helpers.app.selectorLabels" .context) | nindent 4 }}
    {{- with $extraLabels }}
    {{ toYaml . }}
    {{- end }}
namespaces:
- {{ .context.Release.Namespace | quote }}
topologyKey: kubernetes.io/hostname
{{- end -}}
