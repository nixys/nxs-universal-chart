{{- define "helpers.ingress.backend" -}}
{{- $apiVersion := (include "helpers.capabilities.ingress.apiVersion" .context) -}}
{{- if or (eq $apiVersion "extensions/v1beta1") (eq $apiVersion "networking.k8s.io/v1beta1") -}}
serviceName: {{ .serviceName }}
servicePort: {{ .servicePort }}
{{- else -}}
service:
  name: {{ .serviceName }}
  port:
    {{- if typeIs "string" .servicePort }}
    name: {{ .servicePort }}
    {{- else if typeIs "float64" .servicePort }}
    number: {{ .servicePort }}
    {{- end }}
{{- end -}}
{{- end -}}

{{- define "helpers.ingress.supportsPathType" -}}
{{- if (semverCompare "<1.18-0" (include "helpers.capabilities.kubeVersion" .)) -}}
{{- print "false" -}}
{{- else -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}