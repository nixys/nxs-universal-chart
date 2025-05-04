{{- define "helpers.configmaps.decode" -}}
{{if hasPrefix "b64:" .value}}{{trimPrefix "b64:" .value | b64dec | quote }}{{else}}{{ quote .value }}{{- end }}
{{- end -}}


{{- define "helpers.configmaps.renderConfigMap" -}}
{{- $ctx := .context -}}
{{- $v := dict -}}
{{- if typeIs "string" .value -}}
{{- $v = fromYaml (tpl .value $ctx) -}}
{{- else if kindIs "map" .value -}}
{{- $v = .value -}}
{{- end -}}
{{- range $key, $value := $v }}
{{- if eq (typeOf $value) "float64" }}
{{ printf "%s: %s" $key (include "helpers.configmaps.decode" (dict "value" $value)) }}
{{- else if empty $value }}
{{ printf "%s: %s" $key ("" | quote) }}
{{- else if kindIs "string" $value }}
{{ printf "%s: %s" $key (tpl $value $ctx | quote) }}
{{- else }}
{{ $key }}: {{ include "helpers.tplvalues.render" (dict "value" $value "context" $ctx) | toJson | quote }}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "helpers.configmaps.includeEnv" -}}
{{- $ctx := .context -}}
{{- $s := dict -}}
{{- if typeIs "string" .value -}}
{{- $s = fromYaml (tpl .value $ctx) -}}
{{- else if kindIs "map" .value -}}
{{- $s = .value -}}
{{- end -}}
{{- range $sName, $envKeys := $s -}}
{{- range $i, $envKey := $envKeys }}
{{- if kindIs "string" $envKey }}
- name: {{ $envKey }}
  valueFrom:
    configMapKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ $envKey }}
{{- else if kindIs "map" $envKey -}}
{{- range $keyName, $key := $envKey }}
- name: {{ tpl $keyName $ctx }}
  valueFrom:
    {{- if kindIs "map" $key }}
    {{- if $key.fieldRef }}
    fieldRef:
      fieldPath: {{ tpl $key.fieldRef.fieldPath $ctx | default (fail (printf "Missing fieldPath in fieldRef for key %s" $keyName)) }}
    {{- else if $key.resourceFieldRef }}
    resourceFieldRef:
      resource: {{ tpl $key.resourceFieldRef.resource $ctx | default (fail (printf "Missing resource in resourceFieldRef for key %s" $keyName)) }}
      divisor: {{ tpl $key.resourceFieldRef.divisor $ctx | default "1" }}
    {{- else if $key.configMapKeyRef }}
    configMapKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ tpl $key.configMapKeyRef.key $ctx | default (fail (printf "Missing key in configMapKeyRef for key %s" $keyName)) }}
    {{- else }}
    {{- fail (printf "Invalid value for key %s: expected fieldRef, resourceFieldRef, or configMapKeyRef" $keyName) }}
    {{- end }}
    {{- else if kindIs "string" $key }}
    configMapKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ tpl $key $ctx }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}


{{- define "helpers.configmaps.includeEnvConfigmap" -}}
{{- $ctx := .context -}}
{{- $configmaps := .value -}}
{{- if typeIs "string" $configmaps -}}
{{- $configmaps = tpl $configmaps $ctx | fromYaml -}}
{{- end -}}
{{- range $i, $sName := $configmaps }}
- configMapRef:
    name: {{ include "helpers.app.fullname" (dict "name" (tpl $sName $ctx) "context" $ctx) }}
{{- end -}}
{{- end -}}