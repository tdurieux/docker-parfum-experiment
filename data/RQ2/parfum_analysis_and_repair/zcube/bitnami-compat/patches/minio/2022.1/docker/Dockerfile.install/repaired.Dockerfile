COPY --from=minio /licenses/ /opt/bitnami/minio/licenses/
COPY --from=minio /opt/bin/ /opt/bitnami/minio/bin/