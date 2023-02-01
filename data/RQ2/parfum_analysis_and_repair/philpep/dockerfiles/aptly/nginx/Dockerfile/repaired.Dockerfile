ARG REGISTRY
FROM $REGISTRY/nginx
USER root
RUN apt-get update && apt-get -y --no-install-recommends install \
    libnginx-mod-http-fancyindex \
    && rm -rf /var/lib/apt/lists/*
COPY nginx.conf /etc/nginx/sites-available/default
USER www-data
