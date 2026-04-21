# AI Inference Mesh

Inference-контур с mesh ingress, KServe, Knative, Vault-секретами и Prometheus-мониторингом.

## Используемые чарты
- `nxs-universal-chart`
- `nuc-istio`
- `nuc-kserve`
- `nuc-knative`
- `nuc-vault-secret-operator`
- `nuc-kube-prometheus-stack`

## Используемые технологии
- Istio Gateway, VirtualService, AuthorizationPolicy, DestinationRule
- KServe InferenceService
- Knative Service
- VaultConnection, VaultAuth, VaultStaticSecret
- ServiceMonitor, PodMonitor, PrometheusRule

