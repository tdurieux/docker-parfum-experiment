ADD https://raw.githubusercontent.com/etcd-io/etcd/main/LICENSE /opt/bitnami/etcd/licenses/LICENSE
COPY --from=etcd /usr/local/bin/etcd* /opt/bitnami/etcd/bin/