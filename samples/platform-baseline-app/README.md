# Platform Baseline App

Базовый platform-кейс для приложения с основной ingress-точкой через Istio Gateway, сертификатом для Gateway, секретами из Vault, мониторингом через Prometheus Operator, автоскейлингом через KEDA и обычным Deployment приложения.

## Используемые чарты
- `nxs-universal-chart`
- `nuc-istio`
- `nuc-certificates`
- `nuc-vault-secret-operator`
- `nuc-kube-prometheus-stack`
- `nuc-keda`

## Используемые технологии
- Istio Gateway, VirtualService и DestinationRule
- cert-manager Certificate и ClusterIssuer
- Vault Static Secret
- Prometheus ServiceMonitor и PrometheusRule
- KEDA ScaledObject
- Kubernetes Deployment и Service
