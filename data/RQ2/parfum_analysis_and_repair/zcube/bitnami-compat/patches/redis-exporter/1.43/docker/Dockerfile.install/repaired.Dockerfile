ADD https://raw.githubusercontent.com/oliver006/redis_exporter/master/LICENSE /opt/bitnami/redis-exporter/licenses/LICENSE
COPY --from=redis-exporter /redis_exporter /opt/bitnami/redis-exporter/bin/