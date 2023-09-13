## Configuration and installation details

### Using private registries

To use images from private registers, add your ".dockerauthconfig" to `imagePullSecrets` in the common block. This will
create secrets that include auth from the register and will be used in all workloads.

```yaml
imagePullSecrets:
  my-registry: |
    {"auths":{"registry.org":{"auth":"cnd1c2VyOnNlY3VyZVBANXM="}}}
  some-private-hub: b64:eyJhdXRocyI6eyJyZWdpc3RyeS5vcmciOnsiYXV0aCI6ImNuZDFjMlZ5T25ObFkzVnlaVkJBTlhNPSJ9fX0=
```

If a secrets with registry credentials already was added to namespace, you can use `generic.extraImagePullSecrets` to
add pull secrets to all your workloads or `extraImagePullSecrets` directly in the workload like in Kubernetes manifest
by specifying names of the corresponding secrets.

```yaml
generic:
  extraImagePullSecrets:
  - name: my-registry-secret-name
```

```yaml
deployments:
  my-app:
    ...
    extraImagePullSecrets:
    - name: my-registry-secret-name
    ...
```

### Secrets features

Working with the secrets data you can use values with the next types:

* string - usual string values will be encoded to base64 string
* base64 encoded string with `b64:` prefix - value will be used as is without prefix
* json - json will be encoded to base64 string

#### Secret from string

Values file:

```yaml
secrets:
  secret-file:
    data:
      api.key: "JFczZwReBkJFczZwReBkJFczZwReBkJFczZwReBk"
  extra-envs:
    data:
      BAR: foo
```

`--set` analog:

```bash
--set "secrets.secret-file.data.api\.key=$SOME_ENV_WITH_STRING"
--set "secrets.extra-envs.data.BAR=foo"
```

#### Secret from base64 encoded string

Values file:

```yaml
secrets:
  secret-file:
    data:
      api.key: "b64:SkZjelp3UmVCa0pGY3pad1JlQmtKRmN6WndSZUJrSkZjelp3UmVCaw=="
```

`--set` analog:

```bash
--set "secrets.secret-file.data.api\.key=b64:$(echo -n $SOME_ENV|base64 -w0)"
```

#### Secret from json

Values file:

```yaml
secrets:
  json-file:
    data:
      file.json: {
        "arg": "value"
      }
```

`--set` analog:

```bash
--set "secrets.json-file.data.file\.json=$(printf %q $(cat file.json))"
```

or

```bash
--set-file "secrets.json-file.data.file\.json=path/to/file.json"
```

### Values Templating features

You can use go-templates as part of your values.

> **Note**
> Use single quotes to escape strings containing templates to avoid manifest generation errors.

#### Example 1

Add a pod annotation wih the check sum of the application configuration.

```yaml
deployments:
  api:
    podAnnotations:
      checksum/app-cfg: '{{ include "helpers.workload.checksum" (index $.Values.configMaps "app-config") }}'
```

#### Example 2

Specify docker images via the `--set` flag for multiple deployments.

```yaml
deployments:
  app1:
    containers:
    - name: app1
      image: '{{ $.Values.imageRepo1 }}/{{ $.Values.imageApp1 }}'
      imageTag: '{{ $.Values.imageTagApp1 }}'
  ...
  app2:
    containers:
    - name: app1
      image: '{{ $.Values.imageRepo2 }}/{{ $.Values.imageApp2 }}'
      imageTag: '{{ $.Values.imageTagApp2 }}'
```

Create release with `--set` flag

```bash
helm install my-apps nixys/universal-chart -f values.yaml --set imageRepo1=reg.app.com,imageRepo2=reg.app.net,imageApp1=my-app1,imageTagApp1=v1,imageApp2=my-app2,imageTagApp2=v2
```

#### Example 3

Add `defaultURL` parameter to values and use it in ingress template.

```yaml
ingresses:
  my-app:
    ...
    hosts:
    - hostname: '{{ $.Values.defaultURL }}'
      paths:
      - serviceName: nginx
        servicePort: 8080
```

Create release with `--set` flag

```bash
helm install my-app nixys/universal-chart -f values.yaml --set defaultURL=demo.my-app.com
```

#### Example 4

Deploy of `NetworkPolicy` using `extraDeploy`.

```yaml
extraDeploy:
  net-pol: |-
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: {{ include "helpers.app.fullname" (dict "name" "nw-policy" "context" $) }}
      namespace: {{ .Release.Namespace | quote }}
    spec:
      podSelector:
        matchLabels:
          role: db
      policyTypes:
      - Ingress
      - Egress
      ingress:
      - from:
        - ipBlock:
            cidr: 172.17.0.0/16
            except:
            - 172.17.1.0/24
        - namespaceSelector:
            matchLabels:
              project: myproject
        - podSelector:
            matchLabels:
              role: frontend
        ports:
        - protocol: TCP
          port: 6379
      egress:
      - to:
        - ipBlock:
            cidr: 10.0.0.0/24
        ports:
        - protocol: TCP
          port: 5978
```
