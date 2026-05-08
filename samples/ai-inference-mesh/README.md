# AI Inference Mesh

Inference setup with mesh ingress, KServe, Knative, Vault secrets, and Prometheus monitoring.

## Used Charts
- `nxs-universal-chart`
- `nuc-istio`
- `nuc-kserve`
- `nuc-knative`
- `nuc-vault-secret-operator`
- `nuc-kube-prometheus-stack`

## Used Technologies
- Istio Gateway, VirtualService, AuthorizationPolicy, DestinationRule
- KServe InferenceService
- Knative Service
- VaultConnection, VaultAuth, VaultStaticSecret
- ServiceMonitor, PodMonitor, PrometheusRule
