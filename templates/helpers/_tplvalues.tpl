{{- define "helpers.tplvalues.render" -}}
{{- if typeIs "string" .value }}
{{- tpl .value .context }}
{{- else }}
{{- tpl (.value | toYaml) .context }}
{{- end }}
{{- end -}}

{{- define "helpers.tplvalues.renderWithCommaSeparatedArray" -}}
{{- $value := .value -}}
{{- $ctx := .context -}}
{{- if typeIs "map[string]interface {}" $value -}}
{{- range $k, $v := $value }}
{{- printf "%s:" $k }}
{{- $isArray := eq (include "helpers.tplvalues.isArray" $v) "true" -}}
{{- $ind := 2 -}}
{{- if not $isArray }}{{ print "\n" }}{{- end -}}
{{- if $isArray }}{{ $ind = 1 }}{{- end -}}
{{- (include "helpers.tplvalues.renderWithCommaSeparatedArray" (dict "value" $v "context" $ctx)) | indent $ind }}
{{- end }}
{{- else if eq (include "helpers.tplvalues.isArray" $value) "true" -}}
[{{ range $index, $elem := $value }}{{ if $index }}, {{ end }}"{{ $elem }}"{{ end }}]
{{- else if typeIs "string" .value }}
{{- tpl $value $ctx }}
{{- else }}
{{- tpl ($value | toYaml) $ctx }}
{{- end -}}
{{- end -}}


{{- define "helpers.tplvalues.isArray" -}}
{{- typeIs "[]interface {}" . }}
{{- end -}}