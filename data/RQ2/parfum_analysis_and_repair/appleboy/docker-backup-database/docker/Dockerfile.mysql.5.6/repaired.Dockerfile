FROM mysql:5.6

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="docker-backup-database" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

COPY release/linux/amd64/docker-backup-database /bin/

ENTRYPOINT ["/bin/docker-backup-database"]