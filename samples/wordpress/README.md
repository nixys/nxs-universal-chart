# WordPress

Complete WordPress application stack with a MySQL database managed by the Percona XtraDB Cluster Operator, a Valkey object cache, and TLS certificate management via cert-manager.

## Used Charts
- `nxs-universal-chart`
- `nuc-mysql-percona-operator`
- `nuc-valkey`
- `nuc-certificates`

## Used Technologies
- Kubernetes Deployment, Service, Ingress
- PersistentVolumeClaim for uploaded media
- Percona XtraDB Cluster (MySQL 8.0)
- Valkey (Redis-compatible) object cache
- cert-manager Certificate and ClusterIssuer

## Prerequisites

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

Set the same password as the value of `secrets.db.data.password` in `values.yaml`.

## Notes

- **MySQL endpoint.** WordPress connects to `mysql-haproxy` — the HAProxy service created by the Percona operator for the `mysql` cluster.
- **Object cache.** Valkey is deployed as a single-shard instance. To enable object caching in WordPress, install the [Redis Object Cache](https://wordpress.org/plugins/redis-cache/) plugin and point it at the `cache` Valkey service.
- **Storage class.** Adjust `storageClassName: standard` in `pvcs` and `pxc.volumeSpec` to match your cluster's storage provisioner.
- **Domain.** Replace `wordpress.example.local` with your actual domain in both the `ingresses` and `nuc-certificates` sections.
- **Replicas.** The sample uses `pxc.size: 1` for a minimal footprint. For production, set `pxc.size: 3` and `haproxy.size: 2`.
