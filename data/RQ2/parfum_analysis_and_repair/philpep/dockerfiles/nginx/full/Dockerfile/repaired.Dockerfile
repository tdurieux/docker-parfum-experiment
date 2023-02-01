ARG REGISTRY
FROM $REGISTRY/nginx
USER root
RUN apt-get update && apt-get install --no-install-recommends -y \
    nginx-full \
    && rm -rf /var/lib/apt/lists/*
USER www-data
