# Nixys common Helm chart

## Volumes

### .volumes

На уровне workload

```yaml
  volumes:
  - name: secret-file
    type: secret
  - name: app-config
    type: configMap
  - name: app-pvc
    type: pvc
    nameOverride: some-name-of-the-resource
```