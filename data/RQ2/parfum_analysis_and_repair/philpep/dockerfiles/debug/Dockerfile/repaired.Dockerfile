ARG REGISTRY
FROM $REGISTRY/debian:bullseye-slim
RUN apt-get update && apt-get -y --no-install-recommends install \
    bind9-host \
    curl \
    httpie \
    jq \
    mariadb-client \
    postgresql-client \
    rsync \
    && rm -rf /var/lib/apt/lists/*
