# WordPress with Vault Secrets

Complete WordPress application stack with MySQL database managed by the Percona XtraDB Cluster Operator, a Valkey object cache, TLS certificate management via cert-manager, and DB credentials delivered from HashiCorp Vault via the Vault Secret Operator.

Differs from the [`wordpress`](../wordpress) sample in that the plain Kubernetes Secret for the DB password is replaced by a `VaultStaticSecret` backed by a `VaultAuth` using the Kubernetes auth method.

## Used Charts
- `nxs-universal-chart`
- `nuc-mysql-percona-operator`
- `nuc-valkey`
- `nuc-certificates`
- `nuc-vault-secret-operator`

## Used Technologies
- Kubernetes Deployment, Service, Ingress
- PersistentVolumeClaim for uploaded media
- Percona XtraDB Cluster (MySQL 8.0)
- Valkey (Redis-compatible) object cache
- cert-manager Certificate and ClusterIssuer
- HashiCorp Vault KV v2
- Vault Secret Operator — VaultConnection, VaultAuth, VaultStaticSecret

## How secret delivery works

```
Vault KV v2 (apps/wordpress)
        │
        │  VaultStaticSecret "db"
        │  (refreshAfter: 1m)
        ▼
Kubernetes Secret "db"   ←── created and kept in sync by the operator
        │
        │  envSecrets
        ▼
WordPress container env vars
(WORDPRESS_DB_PASSWORD, …)
```

The Vault Secret Operator authenticates to Vault using the pod's ServiceAccount token (`VaultAuth` method: kubernetes), reads the KV v2 path `apps/wordpress`, and materialises the result as a Kubernetes Secret named `db`. WordPress consumes it via `envSecrets`.

## Prerequisites

**Vault KV path.** Store the WordPress DB password in Vault under `apps/wordpress`. The key name becomes the environment variable name injected into the container:

```sh
vault kv put kvv2/apps/wordpress \
  WORDPRESS_DB_PASSWORD=<wp-db-password>
```

**Vault Kubernetes auth role.** Create a role that allows the WordPress pod's ServiceAccount to read the path:

```sh
vault write auth/kubernetes/role/wordpress \
  bound_service_account_names=default \
  bound_service_account_namespaces=default \
  policies=wordpress-policy \
  ttl=1h
```

**MySQL auth secret.** The Percona XtraDB Cluster Operator requires a pre-existing Secret with credentials for all internal cluster users. Create it before deploying:

```sh
kubectl create secret generic mysql-auth \
  --from-literal=root=<root-password> \
  --from-literal=xtrabackup=<xtrabackup-password> \
  --from-literal=monitor=<monitor-password> \
  --from-literal=clustercheck=<clustercheck-password> \
  --from-literal=proxyadmin=<proxyadmin-password> \
  --from-literal=operator=<operator-password> \
  --from-literal=replication=<replication-password>
```

**WordPress database.** After the MySQL cluster is ready, create the application database and user:

```sh
kubectl exec -it mysql-pxc-0 -- \
  mysql -uroot -p<root-password> \
  -e "CREATE DATABASE wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
      CREATE USER 'wordpress'@'%' IDENTIFIED BY '<wp-db-password>';
      GRANT ALL ON wordpress.* TO 'wordpress'@'%';
      FLUSH PRIVILEGES;"
```

## Notes

- **MySQL endpoint.** WordPress connects to `mysql-haproxy` — the HAProxy service created by the Percona operator for the `mysql` cluster.
- **Object cache.** Valkey is deployed as a single-shard instance. To enable object caching in WordPress, install the [Redis Object Cache](https://wordpress.org/plugins/redis-cache/) plugin and point it at the `cache` Valkey service.
- **Storage class.** Adjust `storageClassName: standard` in `pvcs` and `pxc.volumeSpec` to match your cluster's storage provisioner.
- **Domain.** Replace `wordpress.example.local` with your actual domain in both the `ingresses` and `nuc-certificates` sections.
- **Replicas.** The sample uses `pxc.size: 1` for a minimal footprint. For production, set `pxc.size: 3` and `haproxy.size: 2`.
