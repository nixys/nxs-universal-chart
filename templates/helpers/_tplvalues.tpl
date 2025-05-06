{{- define "helpers.tplvalues.render" -}}
{{- if typeIs "string" .value }}
{{- tpl .value .context }}
{{- else }}
{{- tpl (.value | toYaml) .context }}
{{- end }}
{{- end -}}


{{- define "helpers.tplvalues.renderAndCoerce" -}}
  {{- $ctx := .context -}}
  {{- $value := .value -}}
  {{- $raw := $value | toYaml | trimSuffix "\n" -}}
  {{- $rendered := tpl $raw $ctx -}}

  {{- $parsed := dict }}
  {{- if hasPrefix "-" ($rendered | trim) }}
    {{- $parsed = fromYamlArray $rendered }}
  {{- else }}
    {{- $parsed = fromYaml $rendered }}
  {{- end }}

  {{- include "helpers.tplvalues.autotypeConvert" $parsed }}
{{- end -}}

{{- define "helpers.tplvalues.autotypeConvert" -}}
  {{- $data := . -}}
  {{- if kindIs "map" $data }}
    {{- $final := dict -}}
    {{- range $k, $v := $data }}
      {{- include "helpers.tplvalues.coerceStringValue" (dict "key" $k "value" $v "target" $final) }}
    {{- end }}
    {{- toYaml $final | trimSuffix "\n" }}
  {{- else if kindIs "slice" $data }}
    {{- $final := list -}}
    {{- range $item := $data }}
      {{- if kindIs "map" $item }}
        {{- $new := dict -}}
        {{- range $k, $v := $item }}
          {{- include "helpers.tplvalues.coerceStringValue" (dict "key" $k "value" $v "target" $new) }}
        {{- end }}
        {{- $final = append $final $new }}
      {{- else }}
        {{- $final = append $final $item }}
      {{- end }}
    {{- end }}
    {{- toYaml $final | trimSuffix "\n" }}
  {{- else }}
    {{- $data | toYaml | trimSuffix "\n" }}
  {{- end }}
{{- end }}

{{- define "helpers.tplvalues.coerceStringValue" -}}
  {{- $key := .key -}}
  {{- $value := .value -}}
  {{- $target := .target -}}
  {{- if kindIs "string" $value }}
    {{- if eq $value "true" }}
      {{- $_ := set $target $key true }}
    {{- else if eq $value "false" }}
      {{- $_ := set $target $key false }}
    {{- else if regexMatch "^[0-9]+$" $value }}
      {{- $_ := set $target $key (int $value) }}
    {{- else }}
      {{- $_ := set $target $key $value }}
    {{- end }}
  {{- else }}
    {{- $_ := set $target $key $value }}
  {{- end }}
{{- end }}
