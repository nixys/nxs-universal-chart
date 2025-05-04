{{- define "helpers.securityContext" -}}
{{- $ctx := .context -}}
{{- $sc := .securityContext -}}
{{- $gsc := .genericSecurityContext -}}
{{- $final := dict -}}
{{- if or $sc $gsc }}
  {{- if and $sc $sc.mergeWithGeneric $gsc }}
    {{- $final = merge (omit $sc "mergeWithGeneric") (omit $gsc "mergeWithGeneric") -}}
  {{- else if $sc }}
    {{- $final = $sc -}}
  {{- else }}
    {{- $final = $gsc -}}
  {{- end }}
  {{- if and (include "helpers.capabilities.isOpenshift" $ctx) $ctx.Values.generic.openshift.securityContextConstraintsCompatibility }}
    {{- $final = omit $final "runAsUser" "runAsGroup" "fsGroup" -}}
  {{- end }}
{{- end }}

{{- if $final }}
securityContext:
  {{- include "helpers.tplvalues.renderAndCoerce" (dict "value" $final "context" $ctx) | nindent 2 }}
{{- end }}
{{- end -}}

