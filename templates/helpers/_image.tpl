{{- define "helpers.image" -}}
{{- $ := .context -}}
{{- $image := .image -}}
{{- $registry := default $.Values.image.registry $image.registry -}}
{{- $repository := default $.Values.image.repository $image.repository -}}
{{- $t := "" -}}
{{- $s := "@" -}}
{{- if $image.digest -}}
    {{- $s = "@" -}}
    {{- $t = $image.digest -}}
{{- else if $image.tag -}}
    {{- $s = ":" -}}
    {{- $t = $image.tag -}}
{{- else if $.Values.image.digest -}}
    {{- $s = "@" -}}
    {{- $t = $.Values.image.digest -}}
{{- else -}}
    {{- $s = "@" -}}
    {{- $t = $.Values.image.tag -}}
{{- end -}}
{{- if $registry }}
    {{- printf "%s/%s%s%s" $registry $repository $s $t -}}
{{- else -}}
    {{- printf "%s%s%s"  $repository $s $t -}}
{{- end -}}
{{- end -}}
