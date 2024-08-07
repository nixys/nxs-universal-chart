{{- define "helpers.capabilities.helmVersion" -}}
{{- if typeIs "string" .Capabilities.KubeVersion -}}
{{- "v2" -}}
{{- else -}}
{{- "v3" -}}
{{- end -}}
{{- end -}}

{{- define "helpers.capabilities.kubeVersion" -}}
{{- if .Values.global }}
{{- if .Values.global.kubeVersion }}
{{- .Values.global.kubeVersion -}}
{{- else }}
{{- if semverCompare "<3" (include "helpers.capabilities.helmVersion" $) -}}
{{- default .Capabilities.KubeVersion .Values.kubeVersion -}}
{{- else -}}
{{- default .Capabilities.KubeVersion.Version .Values.kubeVersion -}}
{{- end -}}
{{- end -}}
{{- else }}
{{- if .Capabilities.KubeVersion.Version -}}
{{- default .Capabilities.KubeVersion.Version .Values.kubeVersion -}}
{{- else -}}
{{- default .Capabilities.KubeVersion .Values.kubeVersion -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.capabilities.cronJob.apiVersion" -}}
{{- if semverCompare "<1.21-0" (include "helpers.capabilities.kubeVersion" $) -}}
{{- print "batch/v1beta1" -}}
{{- else -}}
{{- print "batch/v1" -}}
{{- end -}}
{{- end -}}

{{- define "helpers.capabilities.deployment.apiVersion" -}}
{{- if semverCompare "<1.14-0" (include "helpers.capabilities.kubeVersion" $) -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{- define "helpers.capabilities.statefulSet.apiVersion" -}}
{{- if semverCompare "<1.14-0" (include "helpers.capabilities.kubeVersion" $) -}}
{{- print "apps/v1beta1" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{- define "helpers.capabilities.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" (include "helpers.capabilities.kubeVersion" $) -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19-0" (include "helpers.capabilities.kubeVersion" $) -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end }}
{{- end -}}

{{- define "helpers.capabilities.pdb.apiVersion" -}}
{{- if semverCompare "<1.21-0" (include "helpers.capabilities.kubeVersion" $) -}}
{{- print "policy/v1beta1" -}}
{{- else -}}
{{- print "policy/v1" -}}
{{- end -}}
{{- end -}}


{{- define "helpers.capabilities.traefik.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "traefik.io/v1alpha1" -}}
{{- print "traefik.io/v1alpha1" -}}
{{- else if .Capabilities.APIVersions.Has "traefik.containo.us/v1alpha1" -}}
{{- print "traefik.containo.us/v1alpha1" -}}
{{- end -}}
{{- end -}}

{{- define "helpers.capabilities.istiogateway.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "networking.istio.io/v1" -}}
{{- print "networking.istio.io/v1" -}}
{{- end -}}
{{- end -}}

{{- define "helpers.capabilities.istiovirtualservice.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "networking.istio.io/v1" -}}
{{- print "networking.istio.io/v1" -}}
{{- end -}}
{{- end -}}

{{- define "helpers.capabilities.istiodestinationrule.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "networking.istio.io/v1" -}}
{{- print "networking.istio.io/v1" -}}
{{- end -}}
{{- end -}}