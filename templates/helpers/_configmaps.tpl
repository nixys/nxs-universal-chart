{{- define "helpers.configFiles.subPaths" -}}
{{- $str := "" -}}
{{- $previous := "" -}}
{{- range $path, $_ := $.Files.Glob ("extra-files/config/**") -}}
{{- $subPath := (printf "%s" (index (split "/" (trimPrefix "/" (trimPrefix "extra-files/config" (dir $path)))) "_0")) | default "extra-files" -}}
{{- if not (eq $previous $subPath) -}}
{{- $str = printf "%s$%s" $str $subPath -}}
{{- $previous = $subPath -}}
{{- end -}}
{{- end -}}
{{- trimPrefix "$" $str -}}
{{- end -}}
